//
//  Notification.name+Extension.swift
//  VenusCustomer
//
//  Created by Amit on 11/06/23.
//

import Foundation

extension Notification.Name {
    static let gpsStatus = Notification.Name("gpsStatus")

    static let clearNotification = Notification.Name("clear_ongoing_notification")
    static let updateAccessTokenAPI = Notification.Name("updateAccessTokenAPI")
    static let updateWalletBalance = Notification.Name("updateWalletBalance")

    static let updateRideStatus = Notification.Name("updateRideStatus")
    static let rideEnded = Notification.Name("rideEnded")
    static let cancelRide = Notification.Name("cancelRide")
    static let driverLocationListner = Notification.Name("driverLocationListner")
    static let updateLocationListenerOnConnect = Notification.Name("updateLocationListenerOnConnect")
    static let newMessage = Notification.Name("newMessage")
    static let messageReceiver = Notification.Name("messageReceiver")
    

}
