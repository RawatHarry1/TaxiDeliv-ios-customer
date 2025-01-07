//
//  VCTabbarVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCTabbarVC: UITabBarController {

    //  To create ViewModel
    static func create() -> VCTabbarVC {
        let obj = VCTabbarVC.instantiate(fromAppStoryboard: .tabbar)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        VCRouter.goToSaveUserVC1()

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       if ClientModel.currentClientData.enabled_service! == 1{
           enableService1()
        }else if ClientModel.currentClientData.enabled_service! == 2{
            enableService1()
        }else{
            configureVC()
        }
        
        tabBar.tintColor = hexStringToUIColor(hex: "#003C6E")

       // tabBar.textColor = UIColor.black
    }

    override func viewDidLayoutSubviews() {
        
    }

    func configureVC() {
       
       // self.viewControllers = [setChooseApp(),setHomeVC(),setDeliveryHomeVC(), setTripsVC(), setAccountVC()]
        self.viewControllers = [setChooseAppVC(),setServicesVC(), setTripsVC(),  setNotificationVC() , setAccountVC()]
    }
    
    func enableService1(){
        self.viewControllers = [setHomeVC(), setTripsVC(),  setNotificationVC() , setAccountVC()]
    }
    
    func navigateToHome(){
        let vc = VCHomeVC.create()
        vc.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//    // TODO: -> Home TabbarItem
//    func setChooseApp() -> UINavigationController{
//        let vc = ChooseAppVC.create()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        let item = UITabBarItem()
//        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        item.title = "SharpXally"
//        item.image = VCImageAsset.sharpUnselected.asset?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = VCImageAsset.sharpSelected.asset?.withRenderingMode(.alwaysOriginal)
//        
//        nav.tabBarItem = item
//        return nav
//    }
//    
    func setHomeVC() -> UINavigationController{
        let vc = VCHomeVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        item.title = "Ride"
        item.image = VCImageAsset.rideUnselected.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.rideSelected.asset?.withRenderingMode(.alwaysTemplate)
        
        nav.tabBarItem = item
        return nav
    }
//    
//    func setDeliveryHomeVC() -> UINavigationController{
//        let vc = DeliveryHomeVC.create()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        let item = UITabBarItem()
//        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        item.title = "Delivery"
//        item.image = VCImageAsset.deliveryUnselected.asset?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = VCImageAsset.deliverySelected.asset?.withRenderingMode(.alwaysTemplate)
//        
//        nav.tabBarItem = item
//        return nav
//    }
//
//    // TODO: -> Trips TabbarItem
//    func setTripsVC() -> UINavigationController{
//        let vc = VCTripHistoryVC.create()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        let item = UITabBarItem()
//        item.title = "Trips"
//        item.image = VCImageAsset.orderUnselected.asset?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = VCImageAsset.orderSelected.asset?.withRenderingMode(.alwaysTemplate)
//        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
//        nav.tabBarItem = item
//        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        return nav
//    }
//
//    // TODO: -> Notification TabbarItem
//    func setNotificationVC() -> UINavigationController{
//        let vc = VCNotificationVC.create()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        let item = UITabBarItem()
//        item.title = "Notifications"
//        item.image = VCImageAsset.notification.asset?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = VCImageAsset.notificationSelected.asset?.withRenderingMode(.alwaysTemplate)
//        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
//        nav.tabBarItem = item
//        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        return nav
//    }
//
//    // TODO: -> Account TabbarItem
//    func setAccountVC() -> UINavigationController{
//        let vc = VCAccountVC.create()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        let item = UITabBarItem()
//        item.title = "Account"
//        item.image = VCImageAsset.accountTab.asset?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = VCImageAsset.accountTabSelected.asset?.withRenderingMode(.alwaysTemplate)
//        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
//        nav.tabBarItem = item
//        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        return nav
//    }

}
extension VCTabbarVC{
    

    
    func setChooseAppVC() -> UINavigationController{
        let vc = ChooseAppVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        item.title = "Home"
        item.image = VCImageAsset.backGray.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.homeSelected.asset?.withRenderingMode(.alwaysTemplate)
        nav.tabBarItem = item
        return nav
    }
    
    func setServicesVC() -> UINavigationController{
        let vc = ServicesVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.title = "Services"
        item.image = VCImageAsset.serviceUnselected.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.servicesSelected.asset?.withRenderingMode(.alwaysTemplate)
        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
        nav.tabBarItem = item
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return nav
    }
    
    // TODO: -> Trips TabbarItem
    func setTripsVC() -> UINavigationController{
        let vc = VCTripHistoryVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.title = "Trips"
        item.image = VCImageAsset.trips.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.tripsSelected.asset?.withRenderingMode(.alwaysTemplate)
        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
        nav.tabBarItem = item
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return nav
    }

    // TODO: -> Notification TabbarItem
    func setNotificationVC() -> UINavigationController{
        let vc = VCNotificationVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.title = "Notifications"
        item.image = VCImageAsset.notification.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.notificationSelected.asset?.withRenderingMode(.alwaysTemplate)
        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
        nav.tabBarItem = item
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return nav
    }

    // TODO: -> Account TabbarItem
    func setAccountVC() -> UINavigationController{
        let vc = VCAccountVC.create()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        let item = UITabBarItem()
        item.title = "Account"
        item.image = VCImageAsset.accountTab.asset?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = VCImageAsset.accountTabSelected.asset?.withRenderingMode(.alwaysTemplate)
        item.selectedImage?.withTintColor(hexStringToUIColor(hex: "#003C6E"))
        nav.tabBarItem = item
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return nav
    }
}
extension VCTabbarVC {

    // Method to remove a tab if the view controller belongs to a specific class
    func removeTabWithClass(_ viewControllerClass: AnyClass) {
        var controllers = self.viewControllers ?? []

        // Find the index of the tab that contains the target view controller class
        if let index = controllers.firstIndex(where: { navController in
            if let nav = navController as? UINavigationController,
               let rootVC = nav.viewControllers.first {
                return rootVC.isKind(of: viewControllerClass)
            }
            return false
        }) {
            // Remove the view controller at the found index
            controllers.remove(at: index)
            self.viewControllers = controllers
            print("Removed tab with class \(viewControllerClass)")
        } else {
            print("Tab with class \(viewControllerClass) not found")
        }
    }
}
