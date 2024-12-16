//
//  GooglePlacesModel.swift
//  VenusCustomer
//
//  Created by AB on 07/11/23.
//

import Foundation

struct GooglePlacesModel : Codable {
    let structured_formatting : Structured_formatting?
    let place_id : String?
    let matched_substrings : [Matched_substrings]?
    let reference : String?
    let terms : [Terms]?
    var description : String? = ""
    let types : [String]?

//    enum CodingKeys: String, CodingKey {
//
//        case structured_formatting = "structured_formatting"
//        case place_id = "place_id"
//        case matched_substrings = "matched_substrings"
//        case reference = "reference"
//        case terms = "terms"
//        case description = "description"
//        case types = "types"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        structured_formatting = try values.decodeIfPresent(Structured_formatting.self, forKey: .structured_formatting)
//        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
//        matched_substrings = try values.decodeIfPresent([Matched_substrings].self, forKey: .matched_substrings)
//        reference = try values.decodeIfPresent(String.self, forKey: .reference)
//        terms = try values.decodeIfPresent([Terms].self, forKey: .terms)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        types = try values.decodeIfPresent([String].self, forKey: .types)
//    }

}

struct Main_text_matched_substrings : Codable {
    let offset : Int?
    let length : Int?
//
//    enum CodingKeys: String, CodingKey {
//
//        case offset = "offset"
//        case length = "length"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
//        length = try values.decodeIfPresent(Int.self, forKey: .length)
//    }

}

struct Matched_substrings : Codable {
    let offset : Int?
    let length : Int?
//
//    enum CodingKeys: String, CodingKey {
//
//        case offset = "offset"
//        case length = "length"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
//        length = try values.decodeIfPresent(Int.self, forKey: .length)
//    }

}

struct Structured_formatting : Codable {
    let secondary_text : String?
    let main_text : String?
    let main_text_matched_substrings : [Main_text_matched_substrings]?

//    enum CodingKeys: String, CodingKey {
//
//        case secondary_text = "secondary_text"
//        case main_text = "main_text"
//        case main_text_matched_substrings = "main_text_matched_substrings"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        secondary_text = try values.decodeIfPresent(String.self, forKey: .secondary_text)
//        main_text = try values.decodeIfPresent(String.self, forKey: .main_text)
//        main_text_matched_substrings = try values.decodeIfPresent([Main_text_matched_substrings].self, forKey: .main_text_matched_substrings)
//    }

}

struct Terms : Codable {
    let offset : Int?
    let value : String?

//    enum CodingKeys: String, CodingKey {
//
//        case offset = "offset"
//        case value = "value"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
//        value = try values.decodeIfPresent(String.self, forKey: .value)
//    }

}


struct GeometryFromPlaceID : Codable {
    var location : LocationFromPlaceID? 

//    enum CodingKeys: String, CodingKey {
//        case location = "location"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        location = try values.decodeIfPresent(LocationFromPlaceID.self, forKey: .location)
//    }

}


struct LocationFromPlaceID : Codable {
    var lng : Double?
    var lat : Double?

//    enum CodingKeys: String, CodingKey {
//
//        case lng = "lng"
//        case lat = "lat"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
//        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//         try container.encode(lat, forKey: .lat)
//        try container.encode(lng, forKey: .lng)
//     }
}
