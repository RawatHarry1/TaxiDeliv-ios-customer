//
//  VCRideVehiclesListViewModel.swift
//  VenusCustomer
//
//  Created by Amit on 15/11/23.
//

import Foundation

class VCRideVehiclesListViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callbackRequestRideData : ((RequestRideData) -> ()) = {_ in }
    var callbackScheduleRequestRideData : ((ScheduleRequestRideResponse) -> ()) = {_ in }
    var callbackMobileMoneyData : ((MobileMoneyModel) -> ()) = {_ in }
    var callbackVerifyMobileMoneyData : ((VerifyMobileMoneyModel) -> ()) = {_ in }

    var objPromoModal: PromoModal?
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
    private(set) var scheduleSequestRideData : ScheduleRequestRideResponse! {
        didSet {
            self.callbackScheduleRequestRideData(scheduleSequestRideData)
        }
    }
    private(set) var mobileMoneyData : MobileMoneyModel! {
        didSet {
            self.callbackMobileMoneyData(mobileMoneyData)
        }
    }
    private(set) var verifyMobileMoneyData : VerifyMobileMoneyModel! {
        didSet {
            self.callbackVerifyMobileMoneyData(verifyMobileMoneyData)
        }
    }
    override init() {
        super.init()
    }
}

// MARK: - APIs
extension VCRideVehiclesListViewModel {

    func requestRideApi(_ params: JSONDictionary) {
        WebServices.requestRide(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let obj = data as? RequestRideResponse else {return}
                self?.requestRideData = obj.data
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func scheduleRequestRideApi(_ params: JSONDictionary) {
        WebServices.scheduleRequestRide(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let obj = data as? ScheduleRequestRideResponse else {return}
                self?.scheduleSequestRideData = obj
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func initializeMobileMoneyApi(_ params: JSONDictionary) {
        WebServices.initializeMobileMoney(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let obj = data as? MobileMoneyModel else {return}
                self?.mobileMoneyData = obj
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    func verifyMobileMoneyApi(_ params: JSONDictionary) {
        WebServices.verifyMobileMoney(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let obj = data as? VerifyMobileMoneyModel else {return}
                self?.verifyMobileMoneyData = obj
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    func promoCodeApi(parms : [String:Any],completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            let att = parms
            return att
        }
        WebServices.getpromo(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? PromoModal else { return }
                print(dataModel)
                self!.objPromoModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}

