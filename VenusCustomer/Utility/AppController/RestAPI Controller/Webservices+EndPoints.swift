//
//  Webservices+EndPoints.swift
//
//
//  Created by Admin on 03/11/21.
//

import Foundation

extension WebServices {
    
    enum EndPoint: String {
        
        case getClientConfig = "/customer/getClientConfig"
        case generateLoginOtp = "/customer/sendLoginOtp"
        case login = "/customer/verifyOtp"
        case loginViaAccessToken = "/loginViaAccessToken"
        case logout_driver = "/logout_driver"
        case addAccount = "/payouts/addAccount"
        case accountDetail = "/customer/profile"
        case findDriverApi = "/customer/findDriver"
        case sosUrl = "/emergency/alert"
        case getInformationUrls = "/getInformationUrls"
        case googlePlaces = "maps/api/place/autocomplete/json"
        case googlePlaceDetails = "/maps/api/place/details/json"
        case requestTrip = "/customer/requestTrip"
        case scheduleRequestTrip = "/insert_pickup_schedule"
        case getrecentRides = "/get_recent_rides"
        case walletHistory = "/get_transaction_history"
        case getPromocode = "/getCouponsAndPromotions"
        case getScheduleRides = "/show_pickup_schedules"
        case cancelTrip  = "/customer/cancelTrip"
        case getRideDetails = "/getTripSummary"
        case tripSummary = "/getTripSummary?tripId="
        case cancelSchedule = "/remove_pickup_schedule"
        case rateDriver = "/rateTheDriver"
        case fetchOngoingRide = "/customer/fetchOngoingTrip"
        case distancematrix = "maps/api/distancematrix/json"
        case newRidePolyline = "maps/api/directions/json"
        case findadriver = "/find_a_driver"
        case fetchNotifications = "/customer/notifications"
        case addAddress = "/add_home_and_work_address"
        case getAddress = "/customer/fetch_user_address"
        case enterCode = "/enter_code"
        case addCard = "/stripe/add_card_3d"
        case confirmCard = "/stripe/confirm_card_3d"
        case getCard = "/fetch/cardDetails?payment_method_type=1"
        case deleteCard = "/removeCard"
        case deleteAccount = "/removeAccount"
        case add_money_via_stripe = "/add_money_via_stripe"
        // MARK: - API url path
        var path: String {
            return sharedAppDelegate.appEnvironment.baseURL + rawValue
        }
        
        var googlePlacePath : String {
            return sharedAppDelegate.appEnvironment.googlePlaceURL + rawValue
        }
    }
}
