//
//  ServicesVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 18/10/24.
//

import UIKit
var isRideClicked = 0
class ServicesVC: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    
    var onBackCallback: (() -> Void)?
    var timer: Timer?
    var currentPage = 0
    static func create() -> ServicesVC {
        let obj = ServicesVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    var banner = [UIImage(named:"banner1"),UIImage(named: "banner2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
                setupPageControl()
                startAutoScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopAutoScroll() // Stop timer when leaving the view
        }
    
    private func setupCollectionView() {
          
           if let layout = collectionViewBanner.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .horizontal
               layout.minimumLineSpacing = 0
           }
        collectionViewBanner.isPagingEnabled = true
       }

       private func setupPageControl() {
           pageControl.numberOfPages = banner.count
           pageControl.currentPage = 0
           pageControl.hidesForSinglePage = true
       }

       // MARK: - Auto Scroll
       private func startAutoScroll() {
           timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
               self?.scrollToNextPage()
           }
       }

       private func stopAutoScroll() {
           timer?.invalidate()
           timer = nil
       }

       private func scrollToNextPage() {
           guard !banner.isEmpty else { return }
           let nextIndex = (currentPage + 1) % banner.count
           let indexPath = IndexPath(item: nextIndex, section: 0)
           collectionViewBanner.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
           currentPage = nextIndex
           pageControl.currentPage = currentPage
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
           currentPage = pageIndex
           pageControl.currentPage = pageIndex
       }

       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           stopAutoScroll() // Stop auto-scroll when user starts dragging
       }

       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           startAutoScroll() // Restart auto-scroll after user stops dragging
       }
    
}
