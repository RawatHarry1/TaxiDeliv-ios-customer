//
//  VDRouters.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation


struct VCRouter {

    // MARK: - To Set Initial ViewController
    static func setInitialViewController() {
        let navigationController = UINavigationController(rootViewController: VCSplashVC.create())
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        sharedAppDelegate.window?.rootViewController = navigationController
        sharedAppDelegate.window?.makeKeyAndVisible()
    }

    // MARK: - To Check Initial App Flow
    static func checkAppinitializationFlow() {
        if UserModel.currentUser.access_token != "" &&  UserModel.currentUser.access_token != nil && (UserModel.currentUser.login?.is_registration_complete ?? false) == true {
            goToSaveUserVC()
        } else {
            loadPreloginScreen()
        }
    }

    // MARK: - Go To Splash Screen
    static func loadPreloginScreen(_ shouldRetainUserDefaults: Bool = false) {
        VCUserDefaults.removeAllValues()
        let landingScene = VCWelcomeVC.create()
        let navigationController = UINavigationController(rootViewController: landingScene)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        navigationController.navigationBar.isHidden = true
        setRoot(viewController: navigationController)
    }

    // MARK: - Set Root VC
    private static func setRoot(viewController: UIViewController?) {
//        sharedAppDelegate.window?.rootViewController = viewController
//        sharedAppDelegate.window?.makeKeyAndVisible()
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    static func setRootInTabbar() {
        // Access the root TabBarController
        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController else {
            print("Root is not a UITabBarController")
            return
        }
        
        // Access the navigation controller at the 0th tab
        guard let navController = tabBarController.viewControllers?.first as? UINavigationController else {
            print("No navigation controller found at index 0")
            return
        }
        
        // Create your new root view controller
        let newRootViewController = VCHomeVC.create()
        
        // Set it as the root of the navigation controller
        navController.setViewControllers([newRootViewController], animated: false)
        
        // Optional: Switch to the 0th tab
        tabBarController.selectedIndex = 0
    }


    static func goToSaveUserVC() {
        let navigationController = UINavigationController(rootViewController: VCTabbarVC.create())
        
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        navigationController.navigationBar.isHidden = true
        setRoot(viewController: navigationController)
    }
    
    static func goToSaveUserVC1() {
        // Access the window's root view controller (ensure it's a UITabBarController)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let tabBarController = window.rootViewController as? VCTabbarVC {
            
          //  UIApplication.shared.windows.first?.rootViewController = viewController
           // UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            
            print("TabBarController is initialized: \(tabBarController)")
            
            // Step 1: Set the selected index to 0 to switch to the first tab
            tabBarController.selectedIndex = 0
            
            // Step 2: Access the navigation controller at index 0 (if embedded in UINavigationController)
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                
                // Step 3: Initialize the view controller you want to push
                let saveUserVC = VCHomeVC()
                
                // Step 4: Push the new view controller
                navController.pushViewController(saveUserVC, animated: true)
            } else {
                print("Navigation Controller at index 0 is not found!")
            }
        } else {
            print("TabBarController is not initialized or not found!")
        }
    }


    static func goToOngoingRide(_ trips : [OngoingTripModel]) {
        let vc = VCRideStatusVC.create()
        vc.ongoingTrips = trips
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        navigationController.navigationBar.isHidden = true
        setRoot(viewController: navigationController)
    }

//    static func goToWalletVC() {
//        let vc = VDWalletVC.create()
//        vc.fromNotificationClick = true
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.isHidden = true
//        setRoot(viewController: navigationController)
//    }
}
