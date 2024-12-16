//
//  VCTripHistoryViewModel.swift
//  VenusCustomer
//
//  Created by Amit on 16/11/23.
//

import Foundation

class VCTripHistoryViewModel: NSObject {

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callBackForTripHistory: (([TripHistoryModel]) -> ()) = {_ in}
    var callBackForScheduleHistory: (([ScheduledData]) -> ()) = {_ in}
    var callBackForTripHistoryDetails: ((TripHistoryDetails) -> ()) = {_ in}
    var objCancelScheduleModal : cancelScheduleModal?
    var objGetTripSummaryModal: getTripSummaryModal?
    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var tripHistory : [TripHistoryModel]! {
        didSet {
            callBackForTripHistory(tripHistory)
        }
    }
    
    private(set) var tripSchedule : [ScheduledData]! {
        didSet {
            callBackForScheduleHistory(tripSchedule)
        }
    }

    private(set) var tripHistoryDetails : TripHistoryDetails! {
        didSet {
            callBackForTripHistoryDetails(tripHistoryDetails)
        }
    }

    override init() {
        super.init()
    }
}


extension VCTripHistoryViewModel {
    
    func tripSummaryApi(urlSting: String,completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            let att = [String:Any]()
            
            return att
        }
        WebServices.tripSummaryApi( url: urlSting, parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? getTripSummaryModal else { return }
                print(dataModel)
                self?.objGetTripSummaryModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }


    func getRecentTrips() {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["start_from"] = "0"
            
            if requestRideType != 0{
                att["request_ride_type"] = requestRideType
            }
            return att
        }
        WebServices.getRecentRides(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? [TripHistoryModel] else { return }
                self?.tripHistory = dataModel
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    func scheduleTrips() {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            if requestRideType != 0{
                att["request_ride_type"] = requestRideType
            }
            return att
        }
        WebServices.getScheduleRides(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? [ScheduledData] else { return }
                self?.tripSchedule = dataModel
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func getTripDetails(_ trip: TripHistoryModel) {

        var attributes : JSONDictionary {
            var att = [String:Any]()
            att["tripId"] = trip.engagement_id
//            att["driverId"] = trip.driver_id
            return att
        }
        WebServices.getRecentRideDetails(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? TripHistoryDetails else { return }
                self?.tripHistoryDetails = dataModel
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    func cancelSchedule(pickip_Id : String,completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["pickup_id"] = pickip_Id
            return att
        }
       
        WebServices.cancelScheduleApi(pickupID: pickip_Id,parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? cancelScheduleModal else { return }
                self?.objCancelScheduleModal = dataModel
                completion()
              
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func rateDriver(_ param: JSONDictionary) {
        WebServices.apiToRateDriver(parameters: param, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
//                guard let dataModel = data as? TripHistoryDetails else { return }
//                self?.tripHistoryDetails = dataModel
                self?.successCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
