//
//  VDEnums.swift
//  VenusCustomer
//
//  Created by Amit on 11/06/23.
//

import Foundation

enum GPSStatus {
    case always
    case whenInUse
    case never
}

enum notificationTypes: String {
    case new_ride_request = "0"
    case request_timeout = "1"
    case request_cancelled = "2"
    case ride_started = "3"
    case ride_ended = "4"
    case ride_cancel = "11"
    case ride_accepted = "5"
    case ride_rejected_by_driver = "7"
    case ride_arriving = "72"
    case newMessage = "600"
}
