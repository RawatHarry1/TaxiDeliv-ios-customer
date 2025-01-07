//
//  Webservices+Rides.swift
//  VenusCustomer
//
//  Created by AB on 12/11/23.
//

import Foundation

extension WebServices {
    // MARK: - To Find Driver
    static func findDriver(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .findDriverApi, loader: false) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(FindDriverData.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func removeAddress(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addAddress, loader: false) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(AddAddressModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func addCards(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func raiseTicketApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .generate_ticket, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(TicketModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    static func deleteCard(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .deleteCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getCard(url: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getCard,toAppend: url, loader: true) { (result) in
            
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(GetCardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func confirmCard(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .confirmCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    
    static func SOSEmergency(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .sosUrl, loader: false) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(FindDriverModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Request a ride
    static func requestRide(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .requestTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(RequestRideResponse.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func scheduleRequestRide(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .scheduleRequestTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(ScheduleRequestRideResponse.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    
    // MARK: - To Cancel Trip
    static func cancelTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonDeleteAPIWithAppendinURL(parameters: parameters, endPoint: .cancelTrip, append: "", loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                //                let data = try! json[APIKeys.data.rawValue].rawData()
                //                let model = try! JSONDecoder().decode(BlockDriverModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Get recent ride
    static func getRecentRides(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .getrecentRides, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["rides"].rawData()
                let model = try! JSONDecoder().decode([TripHistoryModel].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func transactionHistory(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .walletHistory, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(WalletHistoryModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func addMoney(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .add_money_via_stripe, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(cancelScheduleModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getpromocode(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .getPromocode, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(PromoCodeModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func tripSummaryApi(url: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .tripSummary,toAppend: url, loader: true) { (result) in
            
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(getTripSummaryModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getTicketList(url: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .list_support_tickets,toAppend: url, loader: true) { (result) in
            
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(TicketListModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    static func getpromo(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .enterCode, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(PromoModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func deleteAccount(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .deleteAccount, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(PromoModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getScheduleRides(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .getScheduleRides, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode([ScheduledData].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Get Ride Details
    static func getRecentRideDetails(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getRideDetails, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(TripHistoryDetails.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func cancelScheduleApi(pickupID: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .cancelSchedule, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(cancelScheduleModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    // MARK: - To Rate Driver
    static func apiToRateDriver(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .rateDriver, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                //                let data = try! json["data"].rawData()
                //                let model = try! JSONDecoder().decode(TripHistoryDetails.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Fetch Ongoing Ride
    static func apiTogetOngoingRide(parameters: JSONDictionary, response: @escaping ((Result<([OngoingTripModel],[ DeliveryPackages]), Error>) -> Void)) {
        commonPostAPI(parameters: parameters, endPoint: .fetchOngoingRide, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                do {
                    // Parse trips data (Model 1)
                    let data = try! json["data"]["trips"].rawData()
                    let tripsData = data
                    let model1 = try! JSONDecoder().decode([OngoingTripModel].self, from: tripsData)
                    
                    // Check if "deliveryPackages" key exists in the JSON
                    var model2: [DeliveryPackages] = []
                    if  (json["data"]["deliveryPackages"] != JSON.null) {
                        // Only attempt to decode if the key exists and has data
                        do {
                            let deliveryPackagesData =  try! json["data"]["deliveryPackages"].rawData()
                            model2 = try JSONDecoder().decode([DeliveryPackages].self, from: deliveryPackagesData)
                        } catch {
                            printDebug("Failed to parse deliveryPackages: \(error.localizedDescription)")
                        }
                    }
                    // Send both models as a tuple
                    response(.success((model1, model2)))
                } catch {
                    printDebug(error.localizedDescription)
                    response(.failure(error))  // Send the error if there's an issue parsing
                }
                
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    
    //MARK: - To fetch notifications
    static func fetchNotificationList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchNotifications, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode([NotificationDetails].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
