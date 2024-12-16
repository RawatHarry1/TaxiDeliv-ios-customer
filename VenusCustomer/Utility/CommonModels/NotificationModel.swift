//
//  NotificationModel.swift
//  VenusCustomer
//
//  Created by Amit on 22/03/24.
//

import Foundation

struct NotificationDetails : Codable {
    let notification_id : Int?
    let title : String?
    let message : String?
    let time_sent : String?

    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case title = "title"
        case message = "message"
        case time_sent = "time_sent"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_id = try values.decodeIfPresent(Int.self, forKey: .notification_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        time_sent = try values.decodeIfPresent(String.self, forKey: .time_sent)
    }

    init() {
        notification_id = nil
        title = nil
        message = nil
        time_sent = nil
    }

}
