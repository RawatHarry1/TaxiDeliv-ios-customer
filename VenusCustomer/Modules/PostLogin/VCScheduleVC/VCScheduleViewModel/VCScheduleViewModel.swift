//
//  VCScheduleViewModel.swift
//  VenusCustomer
//
//  Created by AB on 09/11/23.
//

import Foundation

class VCScheduleViewModel : NSObject {
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((UserProfileModel) -> ()) = { _ in }
    var findDriverSuccessCallBack : ((FindDriverData) -> ()) = { _ in }
    var objAddressModal : AddAddressModal?

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var findDriverData : FindDriverData! {
        didSet {
            self.findDriverSuccessCallBack(findDriverData)
        }
    }

    override init() {
        super.init()
    }
}

// MARK: -> APIs
extension VCScheduleViewModel {
    func findDriver(_ pickupLocation: GeometryFromPlaceID? , _ dropLocation: GeometryFromPlaceID?,typeID : Int) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["latitude"] = pickupLocation?.location?.lat
            attribute["longitude"] = pickupLocation?.location?.lng
            attribute["op_drop_latitude"] = dropLocation?.location?.lat
            attribute["op_drop_longitude"] = dropLocation?.location?.lng
            attribute["promo_to_apply"] = "\(promoCodeID)"
            attribute["request_ride_type"] = typeID
            return attribute
        }
        WebServices.findDriver(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let findDriver = data as? FindDriverData else {return}
                self?.findDriverData = findDriver
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
        
    }
    
    func removeAddress(addressID: String,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["address_id"] = addressID
            attribute["delete_flag"] = 1

            return attribute
        }
        WebServices.removeAddress(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let addressModal = data as? AddAddressModal else {return}
                self?.objAddressModal = addressModal
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
