//
//  UserProfileModel.swift
//  VenusCustomer
//
//  Created by AB on 24/10/23.
//

import Foundation

struct UserProfileModel : Codable {
    let driver_id : Int?
    let name : String?
    let phone_no : String?
    let user_image : String?
    let email : String?
    let vehicle_no : String?
    let vehicle_brand : String?
    let vehicle_name : String?
    let vehicle_year : String?
    let address : String?
    let first_name : String?
    let last_name : String?

    enum CodingKeys: String, CodingKey {

        case driver_id = "driver_id"
        case name = "user_name"
        case phone_no = "phone_no"
        case user_image = "user_image"
        case email = "user_email"
        case vehicle_no = "vehicle_no"
        case vehicle_brand = "vehicle_brand"
        case vehicle_name = "vehicle_name"
        case vehicle_year = "vehicle_year"
        case address = "address"
        case first_name = "first_name"
        case last_name = "last_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
        vehicle_brand = try values.decodeIfPresent(String.self, forKey: .vehicle_brand)
        vehicle_name = try values.decodeIfPresent(String.self, forKey: .vehicle_name)
        do {
            vehicle_year = try values.decodeIfPresent(String.self, forKey: .vehicle_year)
        } catch {
            let year = try values.decodeIfPresent(Int.self, forKey: .vehicle_year)
            vehicle_year = "\(String(describing: year))"
        }
        address = try values.decodeIfPresent(String.self, forKey: .address)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
    }

}
