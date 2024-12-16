//
//  VCCreateProfileVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit
import AVFoundation

class VCCreateProfileVC: VCBaseVC {
    
    // MARK: - outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtFldReferal: VCTextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameTF: VCTextField!
    @IBOutlet weak var lastNameTF: VCTextField!
    @IBOutlet weak var userNameTF: VCTextField!
    @IBOutlet weak var emailTF: VCTextField!
    @IBOutlet weak var emergencyphoneTF: VCTextField!
    @IBOutlet weak var phoneNumberTF: VCTextField!
    @IBOutlet weak var streetNameTF: VCTextField!
    @IBOutlet weak var locationTF: VCTextField!
    @IBOutlet weak var postalCodeTF: VCTextField!
    @IBOutlet weak var viewReferal: UIStackView!
    
    var screenType = 0
    var data_img: Data?
    var name_img:String?
    var profielViewModel: VCCreateProfileViewModel = VCCreateProfileViewModel()
    var userData: UserProfileModel?
    var comesFromAccount = false
    //  To create ViewModel
    static func create(_ type: Int = 0) -> VCCreateProfileVC {
        let obj = VCCreateProfileVC.instantiate(fromAppStoryboard: .preLogin)
        obj.screenType = type
        return obj
    }
    
    override func initialSetup() {
        if comesFromAccount == true{
            viewReferal.isHidden = true
        }else{
            viewReferal.isHidden = false
        }
        
        txtFldReferal.delegate = self
        phoneNumberTF.setLeftPaddingPoints(40.0)
        titleLabel.text = (screenType != 0) ? "Edit Your Profile" : "Create Your Profile"
        setUpTextField()
        callBacks()
        setUpProfileData()
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        userNameTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    func setUpProfileData() {
        if screenType == 1 {
            if let data = userData {
                firstNameTF.text = data.first_name ?? ""
                lastNameTF.text = data.last_name ?? ""
                emailTF.text = data.email ?? ""
                userNameTF.text = data.name ?? ""
                streetNameTF.text = data.address ?? ""
                if let urlStr = data.user_image {
                    self.profileImg.setImage(urlStr)
                }
                
                if let urlStr = data.user_image {
                    self.profileImg.setImage(withUrl: urlStr) { status, image in
                        if status {
                            if let img = image {
                                self.data_img = img.jpegData(compressionQuality: 1.0)
                                self.profileImg.image = img
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setUpTextField() {
        firstNameTF.addLeftViewPadding(16)
        lastNameTF.addLeftViewPadding(16)
        userNameTF.addLeftViewPadding(16)
        emailTF.addLeftViewPadding(16)
        emergencyphoneTF.addLeftViewPadding(50)
        phoneNumberTF.addLeftViewPadding(50)
        streetNameTF.addLeftViewPadding(16)
        locationTF.addLeftViewPadding(16)
        postalCodeTF.addLeftViewPadding(16)
        txtFldReferal.addLeftViewPadding(16)
    }
    
    func callBacks() {
        profielViewModel.successCallBack = { status in
            if self.screenType == 0 {
                var userData = UserModel.currentUser
                userData.login?.is_customer_profile_complete = 1
                UserModel.currentUser = userData
                self.navigationController?.pushViewController(VCSignUpCompleteVC.create(), animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        // Show Error Alert
        self.profielViewModel.showAlertClosure = {
            if let error = self.profielViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
    }
    
    func requestCameraPermission() {
           let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

           switch cameraAuthorizationStatus {
           case .notDetermined:
               // The user has not yet been asked for camera access
               AVCaptureDevice.requestAccess(for: .video) { granted in
                   if granted {
                       DispatchQueue.main.async {
                           UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
                       }
                      
                   } else {
                       print("Camera access denied")
                   }
               }
           case .authorized:
               // The user has previously granted access
               UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
               print("Camera access previously granted")
           case .restricted, .denied:
               // The user has previously denied access or access is restricted
               DispatchQueue.main.async {
                   UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
               }
               print("Camera access denied or restricted")
               showCameraAccessAlert()
           @unknown default:
               fatalError("Unknown case in camera authorization status")
           }
       }
    
    func showCameraAccessAlert() {
         let alert = UIAlertController(title: "Camera Access Required",
                                       message: "Please enable camera access in Settings to use this feature.",
                                       preferredStyle: .alert)

         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
             guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                 return
             }
             if UIApplication.shared.canOpenURL(settingsUrl) {
                 UIApplication.shared.open(settingsUrl, completionHandler: nil)
             }
         }))

         present(alert, animated: true, completion: nil)
     }
    
    @IBAction func selectImgBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.requestCameraPermission()
    }
}

extension VCCreateProfileVC {
    @IBAction func btnSubmit(_ sender: UIButton) {
        view.resignFirstResponder()
        var img : UIImage?
        if self.self.data_img != nil {
            img = self.profileImg.image
        }

        profielViewModel.validateLoginDetails(
            (firstNameTF.text ?? "").trimmed,
            (lastNameTF.text ?? "").trimmed,
            (userNameTF.text ?? "").trimmed,
            (emailTF.text ?? "").trimmed,
            (streetNameTF.text ?? ""),
            (streetNameTF.text ?? ""),
            (postalCodeTF.text ?? "").trimmed,
            (phoneNumberTF.text ?? "").trimmed,
            img,
            (txtFldReferal.text ?? "").trimmed
        )
    }

  
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

//MARK: UploadFileAlertDelegates
extension VCCreateProfileVC: UploadFileAlertDelegates {
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            self.profileImg.image = UIImage(data: dt)
            self.data_img = data
            self.name_img = name
        }
    }
}


extension VCCreateProfileVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.firstNameTF || textField == lastNameTF || textField == userNameTF || textField == txtFldReferal{
//            let validString = CharacterSet(charactersIn: " !@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
//
//            if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
//                return false
//            }
//            if let range = string.rangeOfCharacter(from: validString)
//            {
//                return false
//            }
            
            if textField == userNameTF || textField == txtFldReferal{
                if (string == " ") {
                    return false
                }
            }else{
                if (textField.text?.count ?? 0) >= 30 && string != "" {
                    return false
                } else {
                    return true
                }
            }
            
            
        }
        return true
    }
}
