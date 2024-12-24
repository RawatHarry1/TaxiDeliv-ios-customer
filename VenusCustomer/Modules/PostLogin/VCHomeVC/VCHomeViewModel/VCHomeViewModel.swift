//
//  VCHomeViewModel.swift
//  VenusCustomer
//
//  Created by Amit on 17/11/23.
//

import Foundation

class VCHomeViewModel: NSObject {

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callBackForOngoingRides: (([OngoingTripModel]) -> ())?
    var callBackForFetchNearbyDriver: (([Drivers]?) -> ())?
    var polylineCallBack: ((String) -> ())?
    var distanceThresholdValue = 20
    var objSOSModal : FindDriverModel?
    
    var error: CustomError? {
        
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var ongoingTrips: [OngoingTripModel]! {
        didSet { self.callBackForOngoingRides?(ongoingTrips)}
    }

    override init() {
        super.init()
    }
}

extension VCHomeViewModel {
    func fetchOngoingRide(completion:@escaping() -> Void) {
        var params : JSONDictionary {
            return [String:Any]()
        }
        WebServices.apiTogetOngoingRide(parameters: params, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? [OngoingTripModel] else { return }
                self?.ongoingTrips = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func findnearbyDriver(id:Int) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["latitude"] = LocationTracker.shared.lastLocation?.coordinate.latitude
            attribute["longitude"] = LocationTracker.shared.lastLocation?.coordinate.longitude
            attribute["request_ride_type"] = promoCodeID
            
            return attribute
        }
        WebServices.findDriver(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let findDriver = data as? FindDriverData else {return}
                self?.callBackForFetchNearbyDriver?(findDriver.drivers)

            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func SOSAPI(tripID : Int,completion:@escaping() -> Void){
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["engagement_id"] = tripID
            
            return attribute
        }
        WebServices.SOSEmergency(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let findDriver = data as? FindDriverModel else {return}
                self?.objSOSModal = findDriver
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }

    func distanceMatrixAPI(_ origin: String, _ destination: String) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["units"] = "km"
            attribute["mode"] = "driving"
            attribute["destinations"] = "place_id:" + destination
            attribute["origins"] = "place_id:" + origin
            attribute["key"] = googleAPIKey
            return attribute
        }

        WebServices.getGoogleDistanceMatrix(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
//                guard let findDriver = data as? FindDriverData else {return}
//                self?.callBackForFetchNearbyDriver?(findDriver.drivers)

            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }

    func getNewPolyline(_ origin: String, _ destination: String) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["mode"] = "driving"
            attribute["destination"] = destination
            attribute["origin"] = origin
            attribute["key"] = googleAPIKey
            return attribute
        }

        WebServices.getNewTripPolyline(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
               
                if let overview_polyline = data as? [String:Any] {
                    let point = overview_polyline["points"] as! String
                    self?.polylineCallBack?(point)
                }

            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }

//    func calculateFearStructure(list: [Fare_structure]) {
//            val fare = list.find { it.vehicleType == vehicleType.orEmpty() } ?: kotlin.run { throw Exception() }
//            if (fare.fare_per_km_threshold_distance.convertDouble() > 0.0){
//                ((fare.fare_fixed.convertDouble() +
//                        if ((rideTotalDistance.splitSpace().convertDouble() - fare.fareThresholdDistance.convertDouble()) < 0)
//                            0.0
//                        else
//                            if ((rideTotalDistance.splitSpace().convertDouble() - fare.fare_per_km_threshold_distance.convertDouble()) < 0)
//                                (rideTotalDistance.splitSpace().convertDouble() - fare.fareThresholdDistance.convertDouble()) * fare.farePerKm.convertDouble()
//                            else
//                                (fare.fare_per_km_threshold_distance.convertDouble() - fare.fareThresholdDistance.convertDouble()) * fare.farePerKm.convertDouble() +
//                                        (rideTotalDistance.splitSpace().convertDouble() - fare.fare_per_km_threshold_distance.convertDouble()) * fare.farePerKm.convertDouble()) +
//                        if (rideTotalTime.splitSpace().convertDouble() - fare.fareThresholdTime.convertDouble() < 0)
//                            0.0
//                        else
//                            (rideTotalTime.splitSpace().convertDouble() - fare.fareThresholdTime.convertDouble()) * fare.farePerMin.convertDouble() +
//                                    fare.farePerXmin.convertDouble()).toString()
//            } else {
//                 (fare.fare_fixed.convertDouble() +
//                        (if ((rideTotalDistance.splitSpace().convertDouble() - fare.fare_per_km_threshold_distance.convertDouble()) < 0){
//                            0.0
//                        } else {
//                            rideTotalDistance.splitSpace().convertDouble() - fare.fare_per_km_threshold_distance.convertDouble()
//                        }) * fare.farePerKm.convertDouble() +
//                        (if ((rideTotalTime.splitSpace().convertDouble() - fare.fareThresholdTime.convertDouble()) < 0){
//                            0.0
//                        } else {
//                            rideTotalTime.splitSpace().convertDouble() - fare.fareThresholdTime.convertDouble()
//                        }) * fare.farePerMin.convertDouble() + fare.farePerXmin.convertDouble()).toString()
//            }
//        }
}

