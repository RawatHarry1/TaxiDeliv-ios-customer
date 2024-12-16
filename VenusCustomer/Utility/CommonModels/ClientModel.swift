//
//  ClientModel.swift
//  VenusCustomer
//
//  Created by AB on 20/10/23.
//

import Foundation
struct ClientModel : Codable {
    let show_terms : String?
    let locale : String?
    let terms_of_use_url : String?
    let show_google_login : String?
    let login_channel : String?
    let operator_token : String?
    let show_facebook_login : String?
    let client_id : String?
    let default_country_code : String?
    let default_country_iso : String?
    let default_lang : String?
    let operator_id : Int?
    let google_map_keys : String?
    let city_list : [City_list]?
    let walk_through_title : String?
    let walk_through_desc: String?
    let operator_availablity : [operator_availablityy]?
    let enabled_service : Int?
    

    // MARK: - Parameters
    static var currentClientData = ClientModel.getFromUserDefaults() {
        didSet {
            ClientModel.currentClientData.saveToUserDefaults()
        }
    }

    enum CodingKeys: String, CodingKey {

        case show_terms = "show_terms"
        case locale = "locale"
        case terms_of_use_url = "terms_of_use_url"
        case show_google_login = "show_google_login"
        case login_channel = "login_channel"
        case operator_token = "operator_token"
        case show_facebook_login = "show_facebook_login"
        case client_id = "client_id"
        case default_country_code = "default_country_code"
        case default_lang = "default_lang"
        case default_country_iso = "default_country_iso"
        case operator_id = "operator_id"
        case city_list = "city_list"
        case google_map_keys = "google_map_keys"
        case walk_through_title = "walk_through_title"
        case walk_through_desc = "walk_through_desc"
        case operator_availablity = "operator_availablity"
        case enabled_service = "enabled_service"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        show_terms = try values.decodeIfPresent(String.self, forKey: .show_terms)
        locale = try values.decodeIfPresent(String.self, forKey: .locale)
        terms_of_use_url = try values.decodeIfPresent(String.self, forKey: .terms_of_use_url)
        show_google_login = try values.decodeIfPresent(String.self, forKey: .show_google_login)
        login_channel = try values.decodeIfPresent(String.self, forKey: .login_channel)
        operator_token = try values.decodeIfPresent(String.self, forKey: .operator_token)
        show_facebook_login = try values.decodeIfPresent(String.self, forKey: .show_facebook_login)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        default_country_code = try values.decodeIfPresent(String.self, forKey: .default_country_code)
        default_lang = try values.decodeIfPresent(String.self, forKey: .default_lang)
        default_country_iso = try values.decodeIfPresent(String.self, forKey: .default_country_iso)
        google_map_keys = try values.decodeIfPresent(String.self, forKey: .google_map_keys)
        operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
        
        walk_through_title = try values.decodeIfPresent(String.self, forKey: .walk_through_title)
        walk_through_desc = try values.decodeIfPresent(String.self, forKey: .walk_through_desc)
        city_list = try values.decodeIfPresent([City_list].self, forKey: .city_list)
        operator_availablity = try values.decodeIfPresent([operator_availablityy].self, forKey: .operator_availablity)
        enabled_service = try values.decodeIfPresent(Int.self, forKey: .enabled_service)
    }

    init() {
        show_terms = nil
        locale = nil
        terms_of_use_url = nil
        show_google_login = nil
        login_channel = nil
        operator_token = nil
        show_facebook_login = nil
        client_id = nil
        default_country_code = nil
        default_lang = nil
        default_country_iso = nil
        operator_id = nil
        city_list = nil
        google_map_keys = nil
        walk_through_title = nil
        walk_through_desc = nil
        operator_availablity = nil
        enabled_service = nil
    }

    // MARK: - Custom Functions
    private func saveToUserDefaults() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        VCUserDefaults.save(value: data, forKey: .clientData)
    }

    private static func getFromUserDefaults() -> ClientModel {
        guard let data = try? VCUserDefaults.value(forKey: .clientData).rawData(), let user = try? JSONDecoder().decode(ClientModel.self, from: data) else { return ClientModel() }
        return user
    }
}

struct operator_availablityy: Codable{
    var description : String?
    var id : Int?
    var image : String?
    var name : String?
}


struct City_list : Codable {
    let config_json : String?
    let city_id : Int?
    let elm_verification_enabled : Int?
    let vehicle_model_enabled : Int?
    let city_name : String?
    let is_gender_enabled : Int?
    let bank_list : String?
    let mandatory_fleet_registration : Int?

    enum CodingKeys: String, CodingKey {

        case config_json = "config_json"
        case city_id = "city_id"
        case elm_verification_enabled = "elm_verification_enabled"
        case vehicle_model_enabled = "vehicle_model_enabled"
        case city_name = "city_name"
        case is_gender_enabled = "is_gender_enabled"
        case bank_list = "bank_list"
        case mandatory_fleet_registration = "mandatory_fleet_registration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        config_json = try values.decodeIfPresent(String.self, forKey: .config_json)
        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
        elm_verification_enabled = try values.decodeIfPresent(Int.self, forKey: .elm_verification_enabled)
        vehicle_model_enabled = try values.decodeIfPresent(Int.self, forKey: .vehicle_model_enabled)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
        is_gender_enabled = try values.decodeIfPresent(Int.self, forKey: .is_gender_enabled)
        bank_list = try values.decodeIfPresent(String.self, forKey: .bank_list)
        mandatory_fleet_registration = try values.decodeIfPresent(Int.self, forKey: .mandatory_fleet_registration)
    }

}
