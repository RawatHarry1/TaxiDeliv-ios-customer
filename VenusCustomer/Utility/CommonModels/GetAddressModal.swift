

import Foundation
struct GetAddressModal : Codable {
    let flag : Int?
    let message : String?
    let data : GetAddData?
    
    enum CodingKeys: String, CodingKey {

        case flag = "flag"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(GetAddData.self, forKey: .data)
    }
}
struct GetAddData : Codable {
    let password : String?
    let autos_user_id : Int?
    let saved_addresses : [Saved_addresses]?
    let autos_addresses : [auto_address]?
    
    enum CodingKeys: String, CodingKey {

        case password = "password"
        case autos_user_id = "autos_user_id"
        case saved_addresses = "saved_addresses"
        case autos_addresses = "autos_addresses"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        autos_user_id = try values.decodeIfPresent(Int.self, forKey: .autos_user_id)
        saved_addresses = try values.decodeIfPresent([Saved_addresses].self, forKey: .saved_addresses)
        autos_addresses = try values.decodeIfPresent([auto_address].self, forKey: .autos_addresses)
    }
}
struct Saved_addresses : Codable {
    let addr : String?
    let type : String?
    //let instr : String?
    let lat : Double?
    let lng : Double?
    let google_place_id : String?
    let freq : Int?
    let id : Int?
    let is_confirmed : Int?
    let nick_name : String?
    enum CodingKeys: String, CodingKey {

        case addr = "addr"
        case type = "type"
      //  case instr = "instr"
        case lat = "lat"
        case lng = "lng"
        case google_place_id = "google_place_id"
        case freq = "freq"
        case id = "id"
        case is_confirmed = "is_confirmed"
        case nick_name = "nick_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        type = try values.decodeIfPresent(String.self, forKey: .type)
       // instr = try values.decodeIfPresent(String.self, forKey: .instr)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        google_place_id = try values.decodeIfPresent(String.self, forKey: .google_place_id)
        freq = try values.decodeIfPresent(Int.self, forKey: .freq)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        is_confirmed = try values.decodeIfPresent(Int.self, forKey: .is_confirmed)
        nick_name = try values.decodeIfPresent(String.self, forKey: .nick_name)
    }
}
struct auto_address: Codable{
    var engagement_id: Int?
    var lat: Double?
    var lng: Double?
    var freq: Int?
    var addr: String?
    var last_used_on: String?
    
    
    enum CodingKeys: String, CodingKey {

        case engagement_id = "engagement_id"
        case lat = "lat"
        case lng = "lng"
        case freq = "freq"
        case addr = "addr"
        case last_used_on = "last_used_on"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        freq = try values.decodeIfPresent(Int.self, forKey: .freq)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        last_used_on = try values.decodeIfPresent(String.self, forKey: .last_used_on)
    }
}
