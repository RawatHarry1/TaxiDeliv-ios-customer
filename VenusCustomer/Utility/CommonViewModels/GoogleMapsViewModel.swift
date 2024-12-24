//
//  GoogleMapsViewModel.swift
//  VenusCustomer
//
//  Created by AB on 07/11/23.
//

import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation

class GoogleMapsViewModel: NSObject {
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var callBackForGooglePlaceSearch: (() -> ())?
    var callBackForGeometryFromPlaceID: ((GeometryFromPlaceID) -> ())?
    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    private(set) var searchedPlaces: [GooglePlacesModel]! {
        didSet { self.callBackForGooglePlaceSearch?()}
    }

    private(set) var locationFromPlaceID: GeometryFromPlaceID! {
        didSet { self.callBackForGeometryFromPlaceID?(locationFromPlaceID)}
    }

    override init() {
        super.init()
    }

    func removeSearchedLocations() {
        searchedPlaces = [GooglePlacesModel]()
    }
}

// MARK: - APIs
extension GoogleMapsViewModel {
    
    // MARK: - Get places from API
    func getGooglePlacesFromApi(value: String) {
        searchedPlaces = [GooglePlacesModel]()
        if value == "" { return }
        var params = [String : Any]()
        params["input"] = value
        if let location = LocationTracker.shared.lastLocation {
            params["location"] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        }
        params["radius"] = 50
        params["key"] = sharedAppDelegate.appEnvironment.googlPlacesKey
        params["sessiontoken"] = Date().timeIntervalInMiliSeconds
//        params["components"] = "country:es|country:in"// Spain & India

        WebServices.getGooglePlaces(parameters: params) { (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let places = data as? [GooglePlacesModel] else {return}
                self.searchedPlaces = places
            case .failure(let error):
                printDebug(error)
            }
        }
    }

    func getGooglePlacesDetailsFromApi(placeID: String) {
        var params : JSONDictionary {
            var arr = [String:Any]()
            arr["fields"] = "geometry"
            arr["place_id"] = placeID
            arr["key"] = googleAPIKey
            return arr
        }
        WebServices.getGooglePlacesDetails(parameters: params) { (result) in
            switch result {
            case .success(let data):
                guard let obj = data as? GeometryFromPlaceID else {return}
                self.locationFromPlaceID = obj
            case .failure(let error):
                printDebug(error)
            }
        }
    }
}
