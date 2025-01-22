//
//  RequestRideResponse.swift
//  VenusCustomer
//
//  Created by Amit on 15/11/23.
//

import Foundation

struct MobileMoneyModel: Codable {
    let flag: Int?
    let message: String?
    let data: DataResponse?
    
    struct DataResponse: Codable {
        let accessCode: String?
        let authorizationUrl: String?
        let reference: String?
        
        enum CodingKeys: String, CodingKey {
            case accessCode = "access_code"
            case authorizationUrl = "authorization_url"
            case reference
        }
    }
}


struct ScheduleRequestRideResponse : Codable {
    let error : String?
    let flag : Int?
}

struct RequestRideResponse : Codable {
    let message : String?
    let flag : Int?
    let data : RequestRideData?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case flag = "flag"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
        data = try values.decodeIfPresent(RequestRideData.self, forKey: .data)
    }

}


struct RequestRideData : Codable {
    let longitude : Double?
    var pickup_location_address : String?
    let start_time : String?
    var session_id : Int?
    let log : String?
    let tip_amount : Int?
    let latitude : Double?
    let gps_lock_status : Int?
    let order_id : Int?
    let message : String?
    var drop_location_address : String?

    enum CodingKeys: String, CodingKey {

        case longitude = "longitude"
        case pickup_location_address = "pickup_location_address"
        case start_time = "start_time"
        case session_id = "session_id"
        case log = "log"
        case tip_amount = "tip_amount"
        case latitude = "latitude"
        case gps_lock_status = "gps_lock_status"
        case order_id = "order_id"
        case message = "message"
        case drop_location_address = "drop_location_address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        pickup_location_address = try values.decodeIfPresent(String.self, forKey: .pickup_location_address)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        session_id = try values.decodeIfPresent(Int.self, forKey: .session_id)
        log = try values.decodeIfPresent(String.self, forKey: .log)
        tip_amount = try values.decodeIfPresent(Int.self, forKey: .tip_amount)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        gps_lock_status = try values.decodeIfPresent(Int.self, forKey: .gps_lock_status)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        drop_location_address = try values.decodeIfPresent(String.self, forKey: .drop_location_address)
    }

}
