//
//  VCLoginVC.swift
//  VenusCustomer
//
//  Created by Amit on 08/06/23.
//

import UIKit
import CoreLocation

class VCLoginVC: VCBaseVC {
    // MARK: - Outlets
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var welcomeSpaceText: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var signUpSelectionLbl: UILabel!
    @IBOutlet weak var signInSelectionLbl: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var loginScrollView: UIScrollView!

    // Login
    @IBOutlet weak var loginEmailTF: VCTextField!
    @IBOutlet weak var loginPasswordTF: VCTextField!
    @IBOutlet weak var signInViaPhone: UIButton!
    @IBOutlet weak var signInForgotPass: UIButton!
    @IBOutlet weak var phonesinginTF: VCTextField!
    @IBOutlet weak var flagloginLbl: UILabel!
    @IBOutlet weak var countrycodeloginLbl: UILabel!
    
    // Sign Up
    @IBOutlet weak var signUpEmailTF: VCTextField!
    @IBOutlet weak var signUpPassTF: VCTextField!
    @IBOutlet weak var signUpConfirmPassTF: VCTextField!
    @IBOutlet weak var signUpViaPhone: UIButton!
    @IBOutlet weak var phoneSignupTF: VCTextField!
    @IBOutlet weak var flagSignUpLbl: UILabel!
    @IBOutlet weak var countrycodeSignupLbl: UILabel!
    
    // MARK: - Variables
    var onbordingViewModel: VCLoginViewModel = VCLoginViewModel()
    var currentLocation: CLLocation?
    var dialcode = ""
    var signupdialcode = ""
    var isLogin: Bool = true


    //  To create ViewModel
    static func create() -> VCLoginVC {
        let obj = VCLoginVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        locationManager.requestWhenInUseAuthorization()
        viewWidth.constant = UIScreen.main.bounds.size.width * 2
        if isLogin {
            signInSelection()
            
        } else {
            signUpSelection()
        }
        loginScrollView.delegate = self
        setUptextFieldsUI()
        loginScrollView.isPagingEnabled = true
        callbacks()
        let regionCode = Locale.current.regionCode
        let defaultCountry = CountryList.filter({$0.code == regionCode?.replacingOccurrences(of: "+", with: "")})
        if defaultCountry.count > 0 {
           
            dialcode = "+" + (defaultCountry.first?.dialcode ?? "91")
            signupdialcode = "+" + (defaultCountry.first?.dialcode ?? "91")
            self.flagloginLbl.text = defaultCountry.first?.flag
            self.countrycodeloginLbl.text =  "+" + (defaultCountry.first?.dialcode ?? "")
            self.flagSignUpLbl.text = defaultCountry.first?.flag
            self.countrycodeSignupLbl.text = "+" + (defaultCountry.first?.dialcode ?? "")
        }
     
    }

    override func viewDidAppear(_ animated: Bool) {
        viewWidth.constant = UIScreen.main.bounds.size.width * 2
       
        if isLogin {
            signInSelection()
        } else {
            signUpSelection()
        }

    }

    override func viewDidLayoutSubviews() {
        btnFacebook.imageEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: self.btnFacebook.bounds.width - 40)
        btnApple.imageEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: self.btnFacebook.bounds.width - 40)
        btnGoogle.imageEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: self.btnFacebook.bounds.width - 40)

    }
    
    func checkLocationPermission() {
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined:
               // First time, show the default permission pop-up
               locationManager.requestWhenInUseAuthorization()  // or requestAlwaysAuthorization() depending on your app's need
              
           case .restricted, .denied:
               // Permission was previously denied, guide the user to settings
               showPermissionDeniedAlert()
           case .authorizedWhenInUse, .authorizedAlways:
               // Location services already authorized, start using location services
               locationManager.startUpdatingLocation()
               onbordingViewModel.validateLoginDetails(self.signupdialcode, self.phoneSignupTF.text ?? "", currentLocation, false)
           @unknown default:
               break
           }
       }
    
    func showPermissionDeniedAlert() {
          let alert = UIAlertController(title: "Location Permission Required",
                                        message: "Location access is needed to provide better service. Please enable location in the app settings.",
                                        preferredStyle: .alert)
          let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
              if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                  UIApplication.shared.open(appSettings)
              }
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alert.addAction(settingsAction)
          alert.addAction(cancelAction)
          present(alert, animated: true, completion: nil)
      }
    
    @IBAction func loginFlagLbl(_ sender: Any) {
        self.view.endEditing(true)
        let vc = CountryCodeVC.create()
        vc.modalPresentationStyle = .overFullScreen
        vc.countryCodeSelected = { country in
            self.dialcode = "+" + (country.dialcode ?? "")
            self.flagloginLbl.text = country.flag
            self.countrycodeloginLbl.text = "+" + (country.dialcode ?? "")
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func signUpFlagLbl(_ sender: Any) {
        self.view.endEditing(true)
        let vc = CountryCodeVC.create()
        vc.modalPresentationStyle = .overFullScreen
        vc.countryCodeSelected = { country in
            self.signupdialcode = "+" + (country.dialcode ?? "")
            self.flagSignUpLbl.text = country.flag
            self.countrycodeSignupLbl.text = "+" + (country.dialcode ?? "")
        }
        self.present(vc, animated: true)
    }
    
    func callbacks() {
        onbordingViewModel.successCallBack = {  result in
            print(result)
            let vc = VCOtpVC.create()
            if self.isLogin {
                vc.phoneNumber = self.phonesinginTF.text ?? ""
                vc.countryCode = self.dialcode
            } else {
                vc.phoneNumber = self.phoneSignupTF.text ?? ""
                vc.countryCode = self.signupdialcode
            }
            vc.isLogin = self.isLogin
            vc.modalPresentationStyle = .overFullScreen
            vc.onSuccess = { success in
                if UserModel.currentUser.login?.is_customer_profile_complete == 0 {
                    let vc = VCCreateProfileVC.create()
                    vc.comesFromAccount = false
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.navigationController?.pushViewController(VCTabbarVC.create(), animated: true)
                }
            }
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
        self.currentLocation = LocationTracker.shared.lastLocation
        LocationTracker.shared.locateMeCallback = { location in
            self.currentLocation = location
        }
        
        // Show Error Alert
        self.onbordingViewModel.showAlertClosure = {
            if let error = self.onbordingViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
    }

    func setUptextFieldsUI(){
        loginEmailTF.addLeftView(VCImageAsset.message.asset)
        loginPasswordTF.addLeftView(VCImageAsset.pass.asset)
        loginPasswordTF.roundCornerTF()
        loginEmailTF.roundCornerTF()

        signUpEmailTF.addLeftView(VCImageAsset.message.asset)
        signUpEmailTF.roundCornerTF()
        signUpPassTF.addLeftView(VCImageAsset.pass.asset)
        signUpPassTF.roundCornerTF()
        signUpConfirmPassTF.addLeftView(VCImageAsset.pass.asset)
        signUpConfirmPassTF.roundCornerTF()

        phoneSignupTF.roundCornerTF()
        phonesinginTF.roundCornerTF()
        phonesinginTF.addLeftViewPadding(80)
        phoneSignupTF.addLeftViewPadding(80)

        if isLogin {
            signInSelection()
        } else {
            signUpSelection()
        }
        setUpUnderLineText()

    }

    func
    signInSelection() {
        signUpSelectionLbl.backgroundColor = .clear
        signInSelectionLbl.backgroundColor = VCColors.signUpSelection.color

        btnSignUp.setTitleColor(VCColors.placeHolderColor.color, for: .normal)
        btnSignIn.setTitleColor(VCColors.buttonSelectedOrange.color, for: .normal)

        titleLbl.text = "Welcome Back"
        subtitleLbl.text = "Thanks for going green!"
        isLogin = true
        phoneSignupTF.text = ""
        loginScrollView.contentOffset = CGPoint(x: 0, y: 0)
        topStackView.isHidden = false
        welcomeText.isHidden = true
        welcomeSpaceText.isHidden = true

    }

    func signUpSelection() {
        signUpSelectionLbl.backgroundColor = VCColors.signUpSelection.color
        signInSelectionLbl.backgroundColor = .clear

        btnSignIn.setTitleColor(VCColors.placeHolderColor.color, for: .normal)
        btnSignUp.setTitleColor(VCColors.buttonSelectedOrange.color, for: .normal)

        titleLbl.text = "Create An Account"
        subtitleLbl.text = "Enter your phone to receive a verification code."
        isLogin = false
        phonesinginTF.text = ""
        loginScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.size.width, y: 0)
        topStackView.isHidden = false
        welcomeText.isHidden = true
        welcomeSpaceText.isHidden = true

    }

    func setUpUnderLineText() {
        let attrs = [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor : VCColors.textColor.color,
                      NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        let attributeString = NSMutableAttributedString(string: "Via Phone", attributes: attrs)
        signInViaPhone.setAttributedTitle(attributeString, for: .normal)
        signUpViaPhone.setAttributedTitle(attributeString, for: .normal)

        let btnattributeString = NSMutableAttributedString(string: "Forgot password?", attributes: attrs)
        signInForgotPass.setAttributedTitle(btnattributeString, for: .normal)
    }
}

// MARK: - IBActions
extension VCLoginVC {
    @IBAction func closeBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnForgotPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCForgotPasswordVC.create(), animated: true)
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)//
        onbordingViewModel.validateLoginDetails(self.dialcode,self.phonesinginTF.text ?? "" , currentLocation, true)
    }

    @IBAction func signUpBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        checkLocationPermission()
    }

    @IBAction func signInSelectionBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        signInSelection()
    }

    @IBAction func signUpSelectionBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        signUpSelection()
    }
}

// MARK: - UIScrollViewDelegates
extension VCLoginVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x  == 0 {
            loginScrollView.contentOffset = CGPoint(x: 0, y: 0)
            signUpSelectionLbl.backgroundColor = .clear
            signInSelectionLbl.backgroundColor = VCColors.signUpSelection.color
        } else if scrollView.contentOffset.x  == UIScreen.main.bounds.size.width {
            loginScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.size.width, y: 0)
            signUpSelectionLbl.backgroundColor = VCColors.signUpSelection.color
            signInSelectionLbl.backgroundColor = .clear

            btnSignIn.setTitleColor(VCColors.placeHolderColor.color, for: .normal)
            btnSignUp.setTitleColor(VCColors.buttonSelectedOrange.color, for: .normal)
        }
    }
}


extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}
