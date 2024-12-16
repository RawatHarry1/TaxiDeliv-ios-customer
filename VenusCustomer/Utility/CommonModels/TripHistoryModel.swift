//
//  TripHistoryModel.swift
//  VenusCustomer
//
//  Created by Amit on 16/11/23.
//

import Foundation

struct TripHistoryModel : Codable {
    let customer_fare_factor : Int?
    let manually_edited : Int?
    let drop_longitude : Double?
    let cancellation_charges : Int?
    let created_at : String?
    let distance_unit : String?
    let is_rated_before : Int?
    let drop_latitude : Double?
    let currency_symbol : String?
    let vehicle_type : Int?
    let pickup_longitude : Double?
    let date : String?
    let wait_time : Int?
    let product_type : Int?
    let currency : String?
    let pickup_latitude : Double?
    let drop_address : String?
    let autos_status_text : String?
    let is_cancelled_ride : Int?
    let utc_offset : String?
    let user_id : Int?
    let amount : Int?
    let ride_type : Int?
    let driver_id : Int?
    let engagement_id : Int?
    let distance : Double?
    let autos_status : Int?
    let images : String?
    let autos_status_color : String?
    let ride_time : Int?
    let pickup_address : String?
    let driver_rating : Int?
    let pickup_time: String?
    let drop_time: String?

    enum CodingKeys: String, CodingKey {

        case customer_fare_factor = "customer_fare_factor"
        case manually_edited = "manually_edited"
        case drop_longitude = "drop_longitude"
        case cancellation_charges = "cancellation_charges"
        case created_at = "created_at"
        case distance_unit = "distance_unit"
        case is_rated_before = "is_rated_before"
        case drop_latitude = "drop_latitude"
        case currency_symbol = "currency_symbol"
        case vehicle_type = "vehicle_type"
        case pickup_longitude = "pickup_longitude"
        case date = "date"
        case wait_time = "wait_time"
        case product_type = "product_type"
        case currency = "currency"
        case pickup_latitude = "pickup_latitude"
        case drop_address = "drop_address"
        case autos_status_text = "autos_status_text"
        case is_cancelled_ride = "is_cancelled_ride"
        case utc_offset = "utc_offset"
        case user_id = "user_id"
        case amount = "amount"
        case ride_type = "ride_type"
        case driver_id = "driver_id"
        case engagement_id = "engagement_id"
        case distance = "distance"
        case autos_status = "autos_status"
        case images = "images"
        case autos_status_color = "autos_status_color"
        case ride_time = "ride_time"
        case pickup_address = "pickup_address"
        case driver_rating = "driver_rating"
        case pickup_time = "pickup_time"
        case drop_time = "drop_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_fare_factor = try values.decodeIfPresent(Int.self, forKey: .customer_fare_factor)
        manually_edited = try values.decodeIfPresent(Int.self, forKey: .manually_edited)
        drop_longitude = try values.decodeIfPresent(Double.self, forKey: .drop_longitude)
        cancellation_charges = try values.decodeIfPresent(Int.self, forKey: .cancellation_charges)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        is_rated_before = try values.decodeIfPresent(Int.self, forKey: .is_rated_before)
        drop_latitude = try values.decodeIfPresent(Double.self, forKey: .drop_latitude)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        pickup_longitude = try values.decodeIfPresent(Double.self, forKey: .pickup_longitude)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
        product_type = try values.decodeIfPresent(Int.self, forKey: .product_type)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        pickup_latitude = try values.decodeIfPresent(Double.self, forKey: .pickup_latitude)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        autos_status_text = try values.decodeIfPresent(String.self, forKey: .autos_status_text)
        is_cancelled_ride = try values.decodeIfPresent(Int.self, forKey: .is_cancelled_ride)
        utc_offset = try values.decodeIfPresent(String.self, forKey: .utc_offset)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        ride_type = try values.decodeIfPresent(Int.self, forKey: .ride_type)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        autos_status = try values.decodeIfPresent(Int.self, forKey: .autos_status)
        images = try values.decodeIfPresent(String.self, forKey: .images)
        autos_status_color = try values.decodeIfPresent(String.self, forKey: .autos_status_color)
        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
        pickup_address = try values.decodeIfPresent(String.self, forKey: .pickup_address)
        driver_rating = try values.decodeIfPresent(Int.self, forKey: .driver_rating)
        pickup_time = try values.decodeIfPresent(String.self, forKey: .pickup_time)
        drop_time = try values.decodeIfPresent(String.self, forKey: .drop_time)
    }
}
