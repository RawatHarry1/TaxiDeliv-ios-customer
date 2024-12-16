//
//  AddPackageVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 06/11/24.
//

import UIKit
import AVFoundation

struct PackageDetail: Codable {
    var quantity : String?
    var image: [String]?
    var description: String?
    var type: String?
    var id: String?
    var package_size : String?
}

class AddPackageVC: VCBaseVC , UITextFieldDelegate{

    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var txtFldPackage: UITextField!
    @IBOutlet weak var txtFldWeight: UITextField!
    @IBOutlet weak var txtFldHeight: UITextField!
    @IBOutlet weak var txtFldWidth: UITextField!
    @IBOutlet weak var txtFldLength: UITextField!
    @IBOutlet weak var txtFldQuantity: UITextField!
    @IBOutlet weak var txtFldItem: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex = -1
    let picker = UIPickerView()
    var photo : UIImage?
    var packageDetailsArray: [PackageDetail] = []
    var objPackageDetailsArray: PackageDetail?
    var objUplodPhotoModal : UplodPhotoModal?
    var size = ""
    var idPackage = ""
    var selectedPhoto = false
    var dismissController:(()->Void)?
    var index = 0
    var isEdit = false
    var editImg = ""
    static func create() -> AddPackageVC {
        let obj = AddPackageVC.instantiate(fromAppStoryboard: .tabbar)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFldItem.delegate = self
        txtFldQuantity.delegate = self
        if isEdit == true{
            if objPackageDetailsArray?.package_size == "Small"{
                self.selectedIndex = 0
            }else if objPackageDetailsArray?.package_size == "Medium"{
                self.selectedIndex = 1
            }else{
                self.selectedIndex = 2
            }

            self.txtFldPackage.text = objPackageDetailsArray?.type ?? ""
            self.txtFldItem.text = objPackageDetailsArray?.description ?? ""
            self.txtFldQuantity.text = objPackageDetailsArray?.quantity ?? ""
            self.idPackage = objPackageDetailsArray?.id ?? ""
            self.size = objPackageDetailsArray?.package_size ?? ""
            if objPackageDetailsArray?.image?.count ?? 0 != 0{
                
                let urlString = objPackageDetailsArray?.image?[0] ?? ""

                loadImage(from: urlString) { image in
                    if let image = image {
                        self.imgViewPhoto.image = image
                    } else {
                        print("Failed to load image.")
                    }
                }
            }
        }
        
        picker.delegate = self
        picker.dataSource = self
        txtFldPackage.inputView = picker  // Set picker as input view
     
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtFldPackage.inputAccessoryView = toolbar
    }
    
   
    
    @IBAction func btnAddPackageAction(_ sender: Any) {
      
        validation()
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUploadPhoto(_ sender: Any) {
        self.view.endEditing(true)
        self.requestCameraPermission()
    }
    
    func validation(){
        self.txtFldPackage.resignFirstResponder()
        self.txtFldItem.resignFirstResponder()
        self.txtFldQuantity.resignFirstResponder()
        if isEdit == true{
            if txtFldPackage.text == ""{
                SKToast.show(withMessage: "Please select Package Description.")
            }else if txtFldItem.text == ""{
                SKToast.show(withMessage: "Please enter Item Description.")
            }else if txtFldQuantity.text == ""{
                SKToast.show(withMessage: "Please enter Quantity.")
            }else if txtFldLength.text == ""{
                SKToast.show(withMessage: "Please add Package Size.")
            }else{
                if selectedPhoto == true{
                    self.createProfileAPI()
                }else{
                    self.editPackageDetail(newImage:objPackageDetailsArray?.image?[0] ?? "")
                }
               
            }
        }else{
            if txtFldPackage.text == ""{
                SKToast.show(withMessage: "Please select Package Description.")
            }else if txtFldItem.text == ""{
                SKToast.show(withMessage: "Please enter Item Description.")
            }else if txtFldQuantity.text == ""{
                SKToast.show(withMessage: "Please enter Quantity.")
            }else if txtFldLength.text == ""{
                SKToast.show(withMessage: "Please add Package Size.")
            }else if selectedPhoto == false{
                SKToast.show(withMessage: "Please Upload Image.")
            }else{
                self.createProfileAPI()
            }
        }
        
    }
    func editPackageDetail( newImage: String) {
        var savedPackageDetails = loadPackageDetails()
        // Check if index is within bounds
        guard index < savedPackageDetails.count else { return }
       
        // Update the item
        savedPackageDetails[index].quantity = txtFldQuantity.text ?? ""
        savedPackageDetails[index].image = [newImage]
        savedPackageDetails[index].description = txtFldItem.text ?? ""
        savedPackageDetails[index].type = txtFldPackage.text ?? ""
        savedPackageDetails[index].id = self.idPackage
        savedPackageDetails[index].package_size = self.size
        
        // Save the updated array to UserDefaults
        savePackageDetails(savedPackageDetails)
        
        // Reload the specific row in the table view to show the update

    }
    
    func saveArray(img: String) {
        // Create a new PackageDetail object
        let newPackageDetail = PackageDetail(
            
            quantity: txtFldQuantity.text ?? "",
            image: [img],
            description: txtFldItem.text ?? "",
            type: txtFldPackage.text ?? "",
            id: self.idPackage,
            package_size : self.size
        )
        
        // Load existing data from UserDefaults
        var savedPackageDetails = loadPackageDetails()
        
        // Append the new data
        savedPackageDetails.append(newPackageDetail)
        
        // Save the updated array
        savePackageDetails(savedPackageDetails)
    }

    func loadPackageDetails() -> [PackageDetail] {
        if let data = UserDefaults.standard.data(forKey: "packageDetailsKey") {
            let decoder = JSONDecoder()
            if let decodedDetails = try? decoder.decode([PackageDetail].self, from: data) {
                return decodedDetails
            }
        }
        return []
    }

    func savePackageDetails(_ details: [PackageDetail]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(details) {
            UserDefaults.standard.set(encoded, forKey: "packageDetailsKey")
            UserDefaults.standard.synchronize()
            selectedPhoto = false
            self.dismissController!()
            self.dismiss(animated: true)
        }
    }

}
extension AddPackageVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserModel.currentUser.login?.package_details?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCollectionCell", for: indexPath) as! PackageCollectionCell
        let obj = UserModel.currentUser.login?.package_details?[indexPath.row]
        cell.imgView.setImage(withUrl: obj?.package_3d_image ?? "") { status, image in}
        cell.lblSmall.text = obj?.package_size ?? ""
        cell.lblSize.text = obj?.package_description ?? ""
        
        if selectedIndex == indexPath.row{
            cell.baseView.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
            self.txtFldLength.text = "\(obj?.package_length ?? 0)"
            self.txtFldWidth.text = "\(obj?.package_width ?? 0.0)"
            self.txtFldHeight.text = "\(obj?.package_height ?? 0)"
            self.txtFldWeight.text = "\(obj?.package_weight ?? 0)"
            self.size = obj?.package_size ?? ""
            self.idPackage = "\(obj?.package_id ?? 0)"
        }else{
            cell.baseView.layer.borderColor = UIColor.systemGray4.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(110, 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.collectionView.reloadData()
    }
}

extension AddPackageVC:UIPickerViewDelegate, UIPickerViewDataSource{
    
    @objc func doneTapped() {
        txtFldPackage.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserModel.currentUser.login?.package_types?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserModel.currentUser.login?.package_types?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtFldPackage.text = UserModel.currentUser.login?.package_types?[row]
    }
}
//MARK: UploadFileAlertDelegates
extension AddPackageVC: UploadFileAlertDelegates {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Get the current text in the text field
            let currentText = textField.text ?? ""
            
            // Check if this is the first character and if the replacement is a space
            if range.location == 0 && string == " " {
                return false
            }
            
            return true
        }
    
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            self.imgViewPhoto.image = UIImage(data: dt)
            photo = UIImage(data: dt)!
            selectedPhoto = true
//            self.data_img = data
//            self.name_img = name
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
               DispatchQueue.main.async {
                   UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
                   print("Camera access previously granted")
               }
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
}
extension AddPackageVC{
    func createProfileAPI() {
        
        WebServices.commonPostAPIWithImage(endPoint: .uploadPhoto, parameters: [:], image: ["image": self.photo!]) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                let data = try! data.rawData()
                let model = try! JSONDecoder().decode(UplodPhotoModal.self, from: data)
                
                self?.objUplodPhotoModal = model
                if self?.isEdit == true{
                    self?.editPackageDetail(newImage: self?.objUplodPhotoModal?.data?.file_path ?? "")
                }else{
                    self?.saveArray(img: self?.objUplodPhotoModal?.data?.file_path ?? "")
                }
               
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Convert string to URL
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Create a data task to fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors and valid data
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Call completion on the main thread with the resulting image
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
