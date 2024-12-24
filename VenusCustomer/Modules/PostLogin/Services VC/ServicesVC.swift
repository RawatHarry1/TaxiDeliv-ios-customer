//
//  ServicesVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 18/10/24.
//

import UIKit
var isRideClicked = 0
class ServicesVC: UIViewController {
    
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    
    
    var onBackCallback: (() -> Void)?
  
    
    static func create() -> ServicesVC {
        let obj = ServicesVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    var banner = [UIImage(named:"banner1"),UIImage(named: "banner2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func removeSpecificTab() {
         if let tabBarVC = self.tabBarController as? VCTabbarVC {
             tabBarVC.removeTabWithClass(ServicesVC.self) // Call the method to remove the tab based on class
         }
     }
    
    @IBAction func btnRideAction(_ sender: Any) {
        if let tabBarVC = self.tabBarController as? VCTabbarVC {
            tabBarVC.selectedIndex = 0
            // if let callback = onBackCallback {
          //  isRideClicked = 1
            
            if let tabBarVC = self.tabBarController as? VCTabbarVC {
                tabBarVC.selectedIndex = 0 // Switch to the first tab
                removeSpecificTab()
                if let navController = tabBarVC.viewControllers?[0] as? UINavigationController {
                    let vc = VCHomeVC.create()
                    vc.hidesBottomBarWhenPushed = false
                    vc.objOperator_availablity =  ClientModel.currentClientData.operator_availablity?[0]
                    navController.pushViewController(vc, animated: true)
                }
            }
            
            
        }
    }
    
    @IBAction func btnScheduleRideAction(_ sender: Any) {
        if let tabBarVC = self.tabBarController as? VCTabbarVC {
            tabBarVC.selectedIndex = 0
            
        
           // isRideClicked = 1
           
            if let tabBarVC = self.tabBarController as? VCTabbarVC {
                tabBarVC.selectedIndex = 0 // Switch to the first tab
                removeSpecificTab()
                if let navController = tabBarVC.viewControllers?[0] as? UINavigationController {
                    let vc = VCHomeVC.create()
                    vc.hidesBottomBarWhenPushed = false
                    vc.objOperator_availablity =  ClientModel.currentClientData.operator_availablity?[0]
                    navController.pushViewController(vc, animated: true)
                }
            }

        }
    }
    
    @IBAction func btnNowAction(_ sender: Any) {
        if let tabBarVC = self.tabBarController as? VCTabbarVC {
            tabBarVC.selectedIndex = 0
            
          
          //  isRideClicked = 2
           
            if let tabBarVC = self.tabBarController as? VCTabbarVC {
                tabBarVC.selectedIndex = 0 // Switch to the first tab
                removeSpecificTab()
                if let navController = tabBarVC.viewControllers?[0] as? UINavigationController {
                    let vc = VCHomeVC.create()
                    vc.hidesBottomBarWhenPushed = false
                    vc.objOperator_availablity =  ClientModel.currentClientData.operator_availablity?[1]
                    navController.pushViewController(vc, animated: true)
                }
            }

        }
    }
    
    @IBAction func btnScheduleDeliveryAction(_ sender: Any) {
        if let tabBarVC = self.tabBarController as? VCTabbarVC {
            tabBarVC.selectedIndex = 0
          //  isRideClicked = 2
           
            if let tabBarVC = self.tabBarController as? VCTabbarVC {
                tabBarVC.selectedIndex = 0 // Switch to the first tab
                removeSpecificTab()
                if let navController = tabBarVC.viewControllers?[0] as? UINavigationController {
                    let vc = VCHomeVC.create()
                    vc.hidesBottomBarWhenPushed = false
                    vc.objOperator_availablity =  ClientModel.currentClientData.operator_availablity?[1]
                    navController.pushViewController(vc, animated: true)
                }
            }

        }
    }
}
extension ServicesVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollCell", for: indexPath) as! HomeBannerCollCell
        cell.imgviewBanner.image = banner[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionViewBanner.frame.width, collectionViewBanner.frame.height)
    }
    
    
    
}
