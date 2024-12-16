//
//  Webservices+GoogleApi.swift
//  VenusCustomer
//
//  Created by AB on 07/11/23.
//

import Foundation

// MARK: - Google Place API
extension WebServices {
    static func getGooglePlaces(parameters: JSONDictionary,showLoader:Bool = false,response: @escaping ((Result<(Any?),Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .googlePlaces, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                let data = try! json["predictions"].rawData()
                let model = try! JSONDecoder().decode([GooglePlacesModel].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    static func getGooglePlacesDetails(parameters: JSONDictionary,showLoader:Bool = true,response: @escaping ((Result<(Any?),Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .googlePlaceDetails, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["result"]["geometry"].rawData()
                let model = try! JSONDecoder().decode(GeometryFromPlaceID.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    static func getGoogleDistanceMatrix(parameters: JSONDictionary,showLoader:Bool = true,response: @escaping ((Result<(Any?),Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .distancematrix, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                if let objc = json.dictionaryObject {
                    if let objc_rows = objc["rows"] as? [[String:Any]] {
                        if objc_rows.count > 0 {
                            if let objc_rows_elements = objc_rows[0]["elements"] as? [[String:Any]] {
                                if objc_rows_elements.count > 0 {
                                    response(.success(objc_rows_elements[0]))
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    static func getNewTripPolyline(parameters: JSONDictionary,showLoader:Bool = false,response: @escaping ((Result<(Any?),Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .newRidePolyline, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                if let objc = json.dictionaryObject {
                    if let objc_rows = objc["routes"] as? [[String:Any]] {
                        if objc_rows.count > 0 {
                            if let objc_rows_elements = objc_rows[0]["overview_polyline"] as? [String:Any] {
//                                if objc_rows_elements.count > 0 {
                                    response(.success(objc_rows_elements))
//                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
