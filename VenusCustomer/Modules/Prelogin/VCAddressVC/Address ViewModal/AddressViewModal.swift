//
//  AddressViewModal.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 12/06/24.
//

import Foundation

class AddressViewModal: NSObject{
    
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callBackForGetAddress: ((GetAddData) -> ()) = {_ in}
    
    private(set) var objAddressModal : GetAddData! {
        didSet {
            callBackForGetAddress(objAddressModal)
        }
    }
    
    func addAddressApi(_ attributes: [String:Any], _ isLogin: Bool) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }
        
        WebServices.addAddress(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
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
    
    
    func getAddressApi(_ attributes: [String:Any], _ isLogin: Bool) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }
        
        WebServices.getAddress(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let dataModel = data as? GetAddData else { return }
                self?.objAddressModal = dataModel
              //  self?.callBackForGetAddress(dataModel)
                printDebug(data)
                self?.successCallBack(isLogin)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
