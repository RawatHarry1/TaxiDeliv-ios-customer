//
//  FindDriverModel.swift
//  VenusCustomer
//
//  Created by AB on 13/11/23.
//

import Foundation


struct FindDriverModel : Codable {
    let data : FindDriverData?
    let message : String?
    let flag : Int?

//    enum CodingKeys: String, CodingKey {
//
//        case data = "data"
//        case message = "message"
//        case flag = "flag"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        data = try values.decodeIfPresent(FindDriverData.self, forKey: .data)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
//    }

}


struct FindDriverData : Codable {
    let driver_fare_factor : Int?
    let fare_factor : Int?
    let city_id : Int?
    let points_of_interest : [String]?
    let regions : [Regions]?
    let request_levels : [Request_levels]?
    let services : [String]?
    let show_region_specific_fare : Int?
    let autos_enabled : Int?
//    let fare_structure : [Fare_structure]?
    let currency : String?
    let operational_hours_data : Operational_hours_data?
    let pay_enabled : Int?
    let total_rides_as_user : Int?
    let distance_unit : String?
    let customerETA : etaData?
      
    let drivers : [Drivers]?

//    enum CodingKeys: String, CodingKey {
//
//        case driver_fare_factor = "driver_fare_factor"
//        case fare_factor = "fare_factor"
//        case city_id = "city_id"
//        case points_of_interest = "points_of_interest"
//        case regions = "regions"
//        case request_levels = "request_levels"
//        /Users/gurindersingh/Documents/Rebuild apps/venus-ios-customer final/VenusCustomer/Utility/CommonModels/FindDriverModel/FindDriverModel.swift   case services = "services"
//        case show_region_specific_fare = "show_region_specific_fare"
//        case autos_enabled = "autos_enabled"
////        case fare_structure = "fare_structure"
//        case currency = "currency"
//        case operational_hours_data = "operational_hours_data"
//        case pay_enabled = "pay_enabled"
//        case total_rides_as_user = "total_rides_as_user"
//        case distance_unit = "distance_unit"
//        case drivers = "drivers"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        driver_fare_factor = try values.decodeIfPresent(Int.self, forKey: .driver_fare_factor)
//        fare_factor = try values.decodeIfPresent(Int.self, forKey: .fare_factor)
//        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
//        points_of_interest = try values.decodeIfPresent([String].self, forKey: .points_of_interest)
//        regions = try values.decodeIfPresent([Regions].self, forKey: .regions)
//        request_levels = try values.decodeIfPresent([Request_levels].self, forKey: .request_levels)
//        services = try values.decodeIfPresent([String].self, forKey: .services)
//        show_region_specific_fare = try values.decodeIfPresent(Int.self, forKey: .show_region_specific_fare)
//        autos_enabled = try values.decodeIfPresent(Int.self, forKey: .autos_enabled)
////        fare_structure = try values.decodeIfPresent([Fare_structure].self, forKey: .fare_structure)
//        currency = try values.decodeIfPresent(String.self, forKey: .currency)
//        operational_hours_data = try values.decodeIfPresent(Operational_hours_data.self, forKey: .operational_hours_data)
//        pay_enabled = try values.decodeIfPresent(Int.self, forKey: .pay_enabled)
//        total_rides_as_user = try values.decodeIfPresent(Int.self, forKey: .total_rides_as_user)
//        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
//        drivers = try values.decodeIfPresent([Drivers].self, forKey: .drivers)
//    }

}
struct etaData: Codable{
    var rideDistance : Double?
    var rideTime : Double?
}

