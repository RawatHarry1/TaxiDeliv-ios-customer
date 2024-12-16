//
//  VCOtpVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit
import CoreLocation

class VCOtpVC: VCBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpTitleLbl: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    var onSuccess:((Bool) -> Void)?
    var myValue = false
    var otpStackView = OTPStackView()
    var onBoardingViewModel: VCLoginViewModel = VCLoginViewModel()
    var isLogin: Bool = true
    var timer: Timer?
    var remainingTime = 60
    //  To create ViewModel
    static func create() -> VCOtpVC {
        let obj = VCOtpVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }
    
    // MARK: - Variables
    var phoneNumber = ""
    var countryCode = ""
    var fullText = ""
    var currentLocation : CLLocation?

    override func initialSetup() {
        fullText = "Enter the 4-digit code sent to you at\n \(countryCode)\(phoneNumber)"
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
        self.lblTimer.isHidden = true
        // Show Error Alert
        self.onBoardingViewModel.showAlertClosure = {
            if let error = self.onBoardingViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
        
        onBoardingViewModel.otpVerifiedCallBack = { (model, isLogin) in
            print(model)
            self.dismiss(animated: true) { [self] in
                onSuccess?(true)
            }
        }
        
        onBoardingViewModel.successCallBack = {  result in
            SKToast.show(withMessage: "OTP sent successfully.")
        }
        
        titleLabelAttributes()
    }

    override func viewDidLayoutSubviews() {
        
    }
    
    func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        @objc func updateTimer() {
            if remainingTime > 0 {
                remainingTime -= 1
                updateTimerLabel()
                DispatchQueue.main.async {
                    self.btnResend.isHidden = true
                    self.lblTimer.isHidden = false
                    self.view.setNeedsLayout()
                }
               
            } else {
                DispatchQueue.main.async {
                    self.btnResend.isEnabled = true
                    self.btnResend.isHidden = false
                    self.lblTimer.isHidden = true
                    self.view.setNeedsLayout()
                }
               
                timer?.invalidate()
                timer = nil
            }
        }
        
        func updateTimerLabel() {
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            lblTimer.text = String(format: "%02d:%02d", minutes, seconds)
        }
    
    func titleLabelAttributes() {
        let clickAble = "\(countryCode)\(phoneNumber)"

        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: VCColors.buttonSelectedOrange.color.cgColor, range: rangeClickableText)
        otpTitleLbl.attributedText = attributedString
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func verifyBtn(_ sender: UIButton) {
        view.endEditing(true)
        let otp = self.otpStackView.getOTP()
        if otp.count == 0 || otp.count < 4 {
            SKToast.show(withMessage: "Please enter otp.")
            return
        }
        var attribute = [String : Any]()
        attribute["loginOtp"] = otp
        attribute["phoneNo"] = phoneNumber
        attribute["countryCode"] = countryCode
        if let location = LocationTracker.shared.lastLocation {
            attribute["latitude"] = location.coordinate.latitude
            attribute["longitude"] = location.coordinate.longitude
        } else {
            SKToast.show(withMessage: "Not able to fetch your current location. Please check location permission in settings.")
            return
        }

        onBoardingViewModel.loginWithOtp(attribute, isLogin)
    }
    
    @IBAction func resendOtpBtn(_ sender: UIButton) {
        view.endEditing(true)
        btnResend.isEnabled = false
        startTimer()
        onBoardingViewModel.validateLoginDetails(self.countryCode, phoneNumber, currentLocation, isLogin)
    }
    
}

extension VCOtpVC: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if isValid {
//            let otp = self.otpStackView.getOTP()
//
//            var attribute = [String : Any]()
//            attribute["loginOtp"] = otp
//            attribute["phoneNo"] = phoneNumber
//            attribute["countryCode"] = countryCode
//            if let location = LocationTracker.shared.lastLocation {
//                attribute["latitude"] = location.coordinate.latitude
//                attribute["longitude"] = location.coordinate.longitude
//            }
//            onBoardingViewModel.loginWithOtp(attribute, <#Bool#>)
        }
    }
}
