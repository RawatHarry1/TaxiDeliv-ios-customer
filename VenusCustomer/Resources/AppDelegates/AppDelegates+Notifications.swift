//
//  AppDelegates+Notifications.swift
//  VenusCustomer
//
//  Created by Amit on 21/11/23.
//

import Foundation
import UIKit
import os.log
import UserNotifications
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let navigation = (window?.rootViewController as? UINavigationController)
        NSLog("User Info didReceive = ",response.notification.request.content.userInfo)
        if let userInfo = response.notification.request.content.userInfo as NSDictionary? as? [String: Any] {
            if let infoData = userInfo["notification_type"] as? String {
                let notificationType = notificationTypes(rawValue: infoData)
                switch notificationType {
                case .request_cancelled, .request_timeout, .ride_rejected_by_driver, .ride_accepted, .ride_started, .ride_arriving :
                    NotificationCenter.default.post(name: .updateRideStatus, object: nil, userInfo: nil)
                case .ride_ended :
                    NotificationCenter.default.post(name: .rideEnded, object: nil, userInfo: nil)
                case .newMessage:
                    isNotificationReceivedForMessage = true
                    if !isChatViewController() {
                        NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: nil)
                           }
               
                 
                default :
                    printDebug(userInfo["notification_type"] as? String ?? "0")
                }
            } else {

            }
        }
        completionHandler()
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        let userInfo = notification.request.content.userInfo //notification.request.content.userInfo
        printDebug(userInfo)
//NotificationCenter.default.post(name: .checkCoordinatesInServiceArea, object: nil, userInfo: ["model":model])
        if let infoData = userInfo["notification_type"] as? String {
            let notificationType = notificationTypes(rawValue: infoData)
            switch notificationType {
            case .request_cancelled, .request_timeout, .ride_rejected_by_driver, .ride_accepted, .ride_started, .ride_arriving :
                NotificationCenter.default.post(name: .updateRideStatus, object: nil, userInfo: nil)
            case .ride_ended :
                NotificationCenter.default.post(name: .rideEnded, object: nil, userInfo: nil)
            case .ride_cancel:
                
                NotificationCenter.default.post(name: .cancelRide, object: nil, userInfo: nil)
            case.newMessage:
                NotificationCenter.default.post(name: .messageReceiver, object: nil, userInfo: nil)
            default :
                printDebug(userInfo["notification_type"] as? String ?? "0")
            }
        }
        completionHandler( [.alert, .sound,.badge])
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NSLog("User Info didReceive = ",userInfo)
        let userInfo = userInfo //notification.request.content.userInfo
        printDebug(userInfo)
//NotificationCenter.default.post(name: .checkCoordinatesInServiceArea, object: nil, userInfo: ["model":model])
        if let infoData = userInfo["notification_type"] as? String {
            let notificationType = notificationTypes(rawValue: infoData)
            switch notificationType {
            case .request_cancelled, .request_timeout, .ride_rejected_by_driver, .ride_accepted, .ride_started, .ride_arriving :
                NotificationCenter.default.post(name: .updateRideStatus, object: nil, userInfo: nil)
            case .ride_ended :
                NotificationCenter.default.post(name: .rideEnded, object: nil, userInfo: nil)
              
            case.newMessage:
                NotificationCenter.default.post(name: .messageReceiver, object: nil, userInfo: nil)
            default :
                printDebug(userInfo["notification_type"] as? String ?? "0")
            }
        }
//        completionHandler( [.alert, .sound])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        printDebug(token)
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printDebug(error.localizedDescription)
        SKToast.show(withMessage: "FCM tokem Failed!!! \(error.localizedDescription)")

    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        DeviceDetail.deviceToken = fcmToken!
    }

    func registerForPushNotification() {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            guard error == nil else {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    //                    NotificationCenter.default.post(name: .notficationIdentifier, object: [true])
                }
            } else {
                //                NotificationCenter.default.post(name: .notficationIdentifier, object: [false])
            }
        }
    }

//    func sortDataForNewRide(_ objc: [String:Any]) -> PushNotification? {
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//
//        if let status = objc["status"] as? String {
//            switch status {
//            case notificationTypes.new_ride_request.rawValue :
//                var notificationModel = PushNotification()
//                notificationModel.status = objc["status"] as? String
//                notificationModel.title =  objc["title"] as? String
//                notificationModel.latitude = objc["latitude"] as? String
//                notificationModel.longitude = objc["longitude"] as? String
//                notificationModel.currency = objc["currency"] as? String
//                notificationModel.customer_id = objc["customer_id"] as? String
//                notificationModel.currency = objc["currency"] as? String
//                notificationModel.customer_image = objc["customer_image"] as? String
//                notificationModel.customer_name = objc["customer_name"] as? String
//                notificationModel.drop_address = objc["drop_address"] as? String
//                notificationModel.dry_eta = objc["dry_eta"] as? String
//                notificationModel.estimated_distance = objc["estimated_distance"] as? String
//                notificationModel.pickup_address = objc["pickup_address"] as? String
//                notificationModel.token = objc["token"] as? String
//                notificationModel.trip_id = objc["trip_id"] as? String
//                notificationModel.estimated_driver_fare = objc["estimated_driver_fare"] as? String
//                if let myDate = objc["date"] as? String {
//                    notificationModel.date = ConvertDateFormater(date: myDate)
//                } else {
//                    notificationModel.date = objc["date"] as? String
//                }
//
//                return notificationModel
////                NotificationCenter.default.post(name: .newRideRequest, object: notificationModel)
//            case notificationTypes.request_cancelled.rawValue, notificationTypes.request_timeout.rawValue:
//                sharedAppDelegate.notficationDetails = nil
//                NotificationCenter.default.post(name: .clearNotification, object: nil)
//                return nil
//            default:
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
    func topViewController(_ rootViewController: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabBarController = rootViewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = rootViewController?.presentedViewController {
            return topViewController(presented)
        }
        return rootViewController
    }
    
    func isChatViewController() -> Bool {
        if let currentVC = topViewController() {
            return currentVC is VDChatVC
        }
        return false
    }
}
