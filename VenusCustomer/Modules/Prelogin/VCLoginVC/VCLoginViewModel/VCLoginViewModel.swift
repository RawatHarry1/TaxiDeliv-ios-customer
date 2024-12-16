//
//  VCLoginViewModel.swift
//  VenusCustomer
//
//  Created by AB on 21/10/23.
//

import Foundation
import CoreLocation

class VCLoginViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var otpVerifiedCallBack: ((UserModel, Bool) -> ()) = { _,_  in}

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    

    override init() {
        super.init()
    }
}

//MARK: LOGIN API'S
extension VCLoginViewModel {
    func validateLoginDetails(_ dial_code: String, _ phone: String, _ location: CLLocation?, _ isLogin: Bool){
        if phone == "" {
            error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
            return
        } else if phone.count < 10 || phone.count > 10{
            error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
            return
        }
//        else if location == nil {
//            error = CustomError(title: "", description: Const_Str.notabletoGetLocation, code: 0)
//            return
//        } 
        else {
            var attributes = [String:Any]()
            attributes["countryCode"] = dial_code
            attributes["phoneNo"] = phone
            attributes["loginType"] = isLogin ? 2:1
//            attributes["longitude"] = location?.coordinate.longitude
//            attributes["latitude"] = location?.coordinate.latitude
            loginWithPhoneNumber(attributes, isLogin)
        }
    }
    
    func loginWithPhoneNumber(_ attributes: [String:Any], _ isLogin: Bool) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }
        
        WebServices.generateOtpWithLogin(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(isLogin)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func loginWithOtp(_ attributes: [String:Any], _ isLogin: Bool) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.verifyLoginOTP(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.otpVerifiedCallBack(data as! UserModel, isLogin)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func logoutApi() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.logoutDriver(parameters: paramToModifyVehicleDetails) { (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                codeTitle = ""
                codeID = 0
                promoCodeID = 0
                promoTitle = ""
                VCUserDefaults.removeAllValues()
                VCRouter.loadPreloginScreen()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
