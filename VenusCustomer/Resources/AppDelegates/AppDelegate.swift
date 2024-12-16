//
//  AppDelegate.swift
//  VenusCustomer
//
//  Created by Amit on 29/06/23.
//

import UIKit
import CoreData
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import GooglePlaces
import StripePaymentSheet
var isNotificationReceivedForMessage = false
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var appEnvironment: AppEnvironment = .production
    var isFromNotification = false
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        GMSServices.provideAPIKey(ClientModel.currentClientData.google_map_keys ?? "AIzaSyByqSAa9MeiTS4DfPkO8VtuP-2PumjwK7Q") //AIzaSyA12Rbcs3mWSpYuJkkSODZameeQRmlXR4U
        GMSPlacesClient.provideAPIKey(ClientModel.currentClientData.google_map_keys ?? "AIzaSyByqSAa9MeiTS4DfPkO8VtuP-2PumjwK7Q")
        LocationTracker.shared.checkLocationEnableStatus()
        if LocationTracker.shared.isLocationPermissionGranted() {
            LocationTracker.shared.enableLocationServices()
        } else {
            DispatchQueue.main.async {
                LocationTracker.shared.enableLocationServices()
            }
        }
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotification()
        
        isFromNotification = false
        if launchOptions?[.remoteNotification] != nil {
            isFromNotification = true
        } else {
            // VDRouter.setInitialViewController()
        }
        
        
        VCSocketIOManager.shared.closeConnection()
        VCSocketIOManager.shared = VCSocketIOManager()
        VCSocketIOManager.shared.connectSocket {
            VCSocketServices.shared.listenForDriverEvents()
            NotificationCenter.default.post(name: .updateLocationListenerOnConnect, object: nil)
        }
        
        
//        if isNotificationReceivedForMessage == true{
//            NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: nil)
//           
//            let storyboard = UIStoryboard(name: "Ride", bundle: nil)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "VCChatVC") as! VCChatVC
//            let navigationController = UINavigationController(rootViewController: viewController)
//            navigationController.navigationBar.isHidden = true
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//            
//            
//    }
        
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (!stripeHandled) {
            var configuration = PaymentSheet.Configuration()
            configuration.returnURL = "your-app://stripe-redirect"
        }
        return stripeHandled
    }

  

    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        isFromNotification = false
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        isFromNotification = false
        startBackgroundTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }
    
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "SocketBackgroundTask") {
            self.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VenusCustomer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

