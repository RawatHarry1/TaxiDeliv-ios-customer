//
//  OngoingTripModel.swift
//  VenusCustomer
//
//  Created by Amit on 17/11/23.
//

import Foundation


struct OngoingTripModel : Codable {
    let trip_id : Int?
    let customer_id : Int?
    let driver_id : Int?
    let latitude : Double?
    let driver_current_latitude : Double?
    let driver_current_longitude : Double?
    let longitude : Double?
    let pickup_address : String?
    let drop_address : String?
    let status : Int?
    let currency : String?
    let driver_name : String?
    let driver_image : String?
    let driver_rating : Double?
    let current_time : String?
    let license_plate : String?
    let brand : String?
    let model_name : String?
    let image : String?
    let session_id : Int?
    let request_drop_latitude : Double?
    let request_drop_longitude : Double?
    let driver_phone_no : String?
    let estimated_driver_fare : String?
    let estimated_distance : String?
    let dry_eta : String?
    let date : String?
    let eta: Double?
    let service_type : Int?

    enum CodingKeys: String, CodingKey {

        case customer_id = "customer_id"
        case estimated_distance = "estimated_distance"
        case driver_rating = "driver_rating"
        case pickup_address = "pickup_address"
        case driver_name = "driver_name"
        case dry_eta = "dry_eta"
        case session_id = "session_id"
        case currency = "currency"
        case date = "date"
        case request_drop_longitude = "request_drop_longitude"
        case driver_id = "driver_id"
        case trip_id = "trip_id"
        case driver_image = "driver_image"
        case status = "status"
        case request_drop_latitude = "request_drop_latitude"
        case longitude = "longitude"
        case drop_address = "drop_address"
        case estimated_driver_fare = "estimated_driver_fare"
        case brand = "brand"
        case license_plate = "license_plate"
        case image = "image"
        case model_name = "model_name"
        case latitude = "latitude"
        case current_time = "current_time"
        case driver_phone_no = "driver_phone_no"
        case eta = "eta"
        case driver_current_latitude = "driver_current_latitude"
        case driver_current_longitude = "driver_current_longitude"
        case service_type = "service_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        estimated_distance = try values.decodeIfPresent(String.self, forKey: .estimated_distance)
        driver_rating = try values.decodeIfPresent(Double.self, forKey: .driver_rating)
        pickup_address = try values.decodeIfPresent(String.self, forKey: .pickup_address)
        driver_name = try values.decodeIfPresent(String.self, forKey: .driver_name)
        dry_eta = try values.decodeIfPresent(String.self, forKey: .dry_eta)
        session_id = try values.decodeIfPresent(Int.self, forKey: .session_id)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        request_drop_longitude = try values.decodeIfPresent(Double.self, forKey: .request_drop_longitude)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        trip_id = try values.decodeIfPresent(Int.self, forKey: .trip_id)
        driver_image = try values.decodeIfPresent(String.self, forKey: .driver_image)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        request_drop_latitude = try values.decodeIfPresent(Double.self, forKey: .request_drop_latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        estimated_driver_fare = try values.decodeIfPresent(String.self, forKey: .estimated_driver_fare)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        license_plate = try values.decodeIfPresent(String.self, forKey: .license_plate)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        current_time = try values.decodeIfPresent(String.self, forKey: .current_time)
        driver_phone_no = try values.decodeIfPresent(String.self, forKey: .driver_phone_no)
        eta = try values.decodeIfPresent(Double.self, forKey: .eta)
        driver_current_latitude = try values.decodeIfPresent(Double.self, forKey: .driver_current_latitude)
        driver_current_longitude = try values.decodeIfPresent(Double.self, forKey: .driver_current_longitude)
        service_type = try values.decodeIfPresent(Int.self, forKey: .service_type)
        
   
    }

}
