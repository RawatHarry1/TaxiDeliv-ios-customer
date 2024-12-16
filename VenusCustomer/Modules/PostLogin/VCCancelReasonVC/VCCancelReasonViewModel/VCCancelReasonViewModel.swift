//
//  VCCancelReasonViewModel.swift
//  VenusCustomer
//
//  Created by Amit on 16/11/23.
//

import Foundation

class VCCancelReasonViewModel: NSObject {

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callbackRequestRideData : ((RequestRideData) -> ()) = {_ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var requestRideData : RequestRideData! {
        didSet {
            self.callbackRequestRideData(requestRideData)
        }
    }

    override init() {
        super.init()
    }
}

extension VCCancelReasonViewModel {

    func cancelRideApi(_ sessionID: Int, _ reason: String) {
        var paramToModifyVehicleDetails: JSONDictionary {
               var attributes = [String:Any]()
            attributes["sessionId"] = sessionID
//            attributes["reasons"] = reason
            return attributes
        }

        WebServices.cancelTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                SKToast.show(withMessage: "Your ride request has been cancelled.")
                VCRouter.goToSaveUserVC()
//                guard let dataModel = data as? BlockDriverModel else { return }
//                self?.cancelRideModel = dataModel
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

}
