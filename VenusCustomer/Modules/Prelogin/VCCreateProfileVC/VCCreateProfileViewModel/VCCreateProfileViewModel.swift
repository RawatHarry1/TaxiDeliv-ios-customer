//
//  VCCreateProfileViewModel.swift
//  VenusCustomer
//
//  Created by AB on 22/10/23.
//

import Foundation

class VCCreateProfileViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }

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
extension VCCreateProfileViewModel {
    func validateLoginDetails(_ firstName: String, _ lastName: String, _ userName: String, _ email: String, _ address: String, _ addressLine2: String, _ postalCode: String, _ phoneNumber: String, _ image: UIImage?,_ referalCode: String) {
            var attributes = [String:Any]()
            if firstName == "" {
                error = CustomError(title: "", description: Const_Str.invalid_first_name, code: 0)
                return
            } else if firstName.count < 3 {
                error = CustomError(title: "", description: Const_Str.first_name_tooShot, code: 0)
                return
            } else if firstName.count > 50 {
                error = CustomError(title: "", description: Const_Str.first_name_toolong, code: 0)
                return
            } else if lastName == "" {
                error = CustomError(title: "", description: Const_Str.invalid_last_name, code: 0)
                return
            }else if lastName.count < 3 {
                error = CustomError(title: "", description: Const_Str.last_name_tooShot, code: 0)
                return
            } else if lastName.count > 50 {
                error = CustomError(title: "", description: Const_Str.last_name_toolong, code: 0)
                return
            } else if userName == "" {
                error = CustomError(title: "", description: Const_Str.invalid_user_name, code: 0)
                return
            } else if userName.count < 3 {
                error = CustomError(title: "", description: Const_Str.username_tooShot, code: 0)
                return
            } else if userName.count > 50 {
                error = CustomError(title: "", description: Const_Str.username_toolong, code: 0)
                return
            } else if email == "" {
                error = CustomError(title: "", description: Const_Str.invalid_email, code: 0)
                return
            } else if email.checkInvalidity(.email) {
                error = CustomError(title: "", description: Const_Str.invalid_email_address, code: 0)
                return
//            } else if phoneNumber == "" {
//                error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
//                return
//            } else if phoneNumber.count < 10 || phoneNumber.count > 10{
//                error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
//                return
//            } else if address == "" {
//                error = CustomError(title: "", description: Const_Str.invalid_street, code: 0)
//                return
//            } else if addressLine2 == "" {
//                error = CustomError(title: "", description: Const_Str.invalid_address, code: 0)
//                return
//            } else if postalCode == "" {
//                error = CustomError(title: "", description: Const_Str.invalid_postal_code, code: 0)
//                return
            } else if image == nil {
                error = CustomError(title: "", description: Const_Str.select_profile_image, code: 0)
                return
            }

        attributes["firstName"] = firstName
        attributes["lastName"] = lastName
        attributes["userName"] = userName
        attributes["address"] = address //+ "," + addressLine2 + "," + postalCode
        attributes["updatedUserEmail"] = email
        attributes["referral_code"] = referalCode
//        attributes["dateOfBirth"] = "1999/04/04"
        createProfileAPI(attributes, image!)
    }


    func createProfileAPI(_ attributes : [String : Any] , _ image : UIImage) {
        let image = ["updatedUserImage" : image]
        WebServices.createProfileWithImage(parameters: attributes, image: image) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
