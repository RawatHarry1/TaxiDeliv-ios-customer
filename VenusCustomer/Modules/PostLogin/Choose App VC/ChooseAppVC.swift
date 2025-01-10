//
//  ChooseAppVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 18/09/24.
//

import UIKit
import GoogleMaps

var requestRideType = 0
class ChooseAppVC: VCBaseVC {
    
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var viewRide: UIView!
    @IBOutlet weak var imgViewCarICon: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var txtFldLoc: UITextField!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var createRideView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var giftView: VDView!
    @IBOutlet weak var topCollViewBackgroundView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    private var accountViewModel: VCAccountViewModel = VCAccountViewModel()
    
    var markerUser : GMSMarker?
    var imgArr = [UIImage(named: "car"), UIImage(named: "courier")]
    var titleArr = ["TAXI BOOKING","PICKUP & DELIVERY"]
    var selectedIndex = 0
    var  operator_availablity : operator_availablityy?
    var navigate = false
    var banner :[bannerData]?
    var bannerSelectedIndex = -1
    var timer: Timer?
    var currentIndex = 0
    var bg = [UIImage(named: "bgBlue"),UIImage(named: "bgGreen")]
    var objTrips: [OngoingTripModel]?
    private var viewModel = VCHomeViewModel()
    
    private var userData: UserProfileModel?
    
    static func create() -> ChooseAppVC {
        let obj = ChooseAppVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func viewDidLoad() {
        topCollViewBackgroundView.layer.cornerRadius = 20
        topCollViewBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

        callBacks()
        accountViewModel.getAccountDetail()
        imgViewProfile.setImage(withUrl: UserModel.currentUser.login?.user_image ?? "") { status, image in}
        lblName.text = "Hi, \(UserModel.currentUser.login?.user_name ?? "")"
        pageControl.numberOfPages = UserModel.currentUser.login?.banner?.count ?? 0
                pageControl.currentPage = 0
        startAutoScroll()
        super.viewDidLoad()
      //  createRideView.addShadowView()
    }
    
    func callBacks() {
        self.accountViewModel.successCallBack = { details in
            print(details)
            self.userData = details
            UserModel.currentUser.login?.user_name = self.userData?.name
            if let urlStr = details.user_image {
                self.imgViewProfile.setImage(urlStr)
            }
            self.lblName.text = "Hi, \(details.name ?? "")"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestRideType = 0
        self.viewRide.isHidden = true
        setHomeVC()
        navigate = false
        addNewTab()
        viewModel.fetchOngoingRide(completion: {})
        responseFetchOnGoingRide()
    }
    
    
    func removeSpecificTab() {
         if let tabBarVC = self.tabBarController as? VCTabbarVC {
             tabBarVC.removeTabWithClass(ServicesVC.self) // Call the method to remove the tab based on class
         }
     }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        addMarkerToPosition(coordinates)
        getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
            if let address = address {
                DispatchQueue.main.async {
                    self.txtFldLoc.text = address
                }
                
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
    }
    
    
    func responseFetchOnGoingRide(){
        
        viewModel.callBackForOngoingRides = { trips in
            if self.viewModel.ongoingTrips.count > 0{
                if self.objTrips?[0].service_type == 1{
                    self.imgViewCarICon.image = UIImage(named: "NowRide")
                    self.lblDesc.text = "You have on going ride"
                    self.imgViewBg.image = UIImage(named: "bgBlue1")
                }else{
                    self.imgViewCarICon.image = UIImage(named: "NowDel")
                    self.lblDesc.text = "You have on going delivery"
                    self.lblTitle.text = "Ongoing Delivery Ride"
                    self.imgViewBg.image = UIImage(named: "bgBlue1")
                }
                self.viewRide.isHidden = false
                self.objTrips = trips
            }
        }
        
        
        viewModel.fetchOngoingRide(completion: {
            if self.viewModel.ongoingTrips.count > 0{
                
              
            }
        })
    }
    
    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
        mapView.clear()
        markerUser?.map = nil
       
        markerUser = GMSMarker(position: coordinates)
        markerUser?.icon = VCImageAsset.locationMarker.asset
      //  markerUser?.isFlat = false
        markerUser?.position = coordinates
        markerUser?.isDraggable = true
        markerUser?.map = mapView
        let camera = GMSCameraPosition.init(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 10)

        self.mapView.animate(to: camera)
    }
    
    func setHomeVC(){
        self.tabBarController?.tabBar.items?[0].selectedImage = VCImageAsset.homeSelected.asset?.withRenderingMode(.alwaysTemplate)
        self.tabBarController?.tabBar.items?[0].title = "Home"
        self.tabBarController?.tabBar.items?[0].imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        self.collectionView.reloadData()

    }
    
    func selectedView(view:UIView){
        view.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
        view.layer.borderWidth = 2
    }
    
    func unSelectedView(view:UIView){
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0
    }
    
    @IBAction func btnWhereToAction(_ sender: Any) {
        let vc = VCHomeVC.create()
        vc.hidesBottomBarWhenPushed = false
        vc.objOperator_availablity = self.operator_availablity
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        let vc = VCCreateProfileVC.create()
        vc.screenType = 1
        vc.userData = self.userData
        vc.comesFromAccount = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAction(_ sender: Any) {
        if self.viewModel.ongoingTrips?[0].status != 0{
            if self.objTrips?.count ?? 0 > 0{
                VCRouter.goToOngoingRide(self.objTrips!)
            }
        }
    }
    
    
    @IBAction func btnReferNow(_ sender: Any) {
      
        self.navigationController?.pushViewController(ReferralVC.create(), animated: true)
    }
    
    func startAutoScroll() {
           timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
       }

       @objc func scrollCollectionView() {
           let numberOfItems = bannerCollectionView.numberOfItems(inSection: 0)
           if currentIndex < numberOfItems - 1 {
               currentIndex += 1
           } else {
               currentIndex = 0
           }
           let indexPath = IndexPath(item: currentIndex, section: 0)
           bannerCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
           pageControl.currentPage = currentIndex
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Invalidate the timer to stop scrolling when the view is not visible
           timer?.invalidate()
       }
}

extension ChooseAppVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == bannerCollectionView{
            return UserModel.currentUser.login?.banner?.count ?? 0
        }else{
            return ClientModel.currentClientData.operator_availablity?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            let obj = UserModel.currentUser.login?.banner?[indexPath.row]
            if let urlStr = obj?.banner_image {
                cell.imgViewBanner.setImage(urlStr)
            }
          //  pageControl.currentPage = currentIndex
            if self.bannerSelectedIndex == indexPath.row{
                if let url = URL(string: obj?.action_url ?? ""), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
          
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseAppCollectionCell", for: indexPath) as! ChooseAppCollectionCell
            let obj = ClientModel.currentClientData.operator_availablity?[indexPath.row]
            cell.imgView.setImage(withUrl: obj?.image ?? "") { status, image in}
            cell.lblTitle.text = obj?.name ?? ""
            cell.lblDesc.text = obj?.description ?? ""
            cell.imgViewBg.image = bg[indexPath.row]

            if selectedIndex == indexPath.row{
                self.selectedView(view: cell.baseView)
                self.operator_availablity = obj
                if navigate == true{
                    
                    removeSpecificTab()
                    requestRideType = self.operator_availablity?.id ?? 0
                    let vc = VCHomeVC.create()
                    vc.hidesBottomBarWhenPushed = false
                    vc.objOperator_availablity = self.operator_availablity
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                self.unSelectedView(view: cell.baseView)
               // cell.baseView.addShadowView()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }else{
            return CGSize(width: (collectionView.frame.width / 2) , height: 235)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView{
            self.bannerSelectedIndex = indexPath.row
            self.bannerCollectionView.reloadData()
        }else{
            selectedIndex = indexPath.row
            navigate = true
            self.collectionView.reloadData()
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      //  scrollCollectionView()
    }
    
     func addNewTab() {
        if let tabBarVC = self.tabBarController as? VCTabbarVC {
            // Get the current view controllers
            var controllers = tabBarVC.viewControllers ?? []
            
            // Check if the "New Tab" is already added by title or class
            let isTabAlreadyAdded = controllers.contains(where: { navController in
                if let nav = navController as? UINavigationController,
                   let rootVC = nav.viewControllers.first {
                    return rootVC is ServicesVC // You can also compare titles here
                }
                return false
            })

            // If the tab is not already added, add it at index 1
            if !isTabAlreadyAdded {
                // Insert the new tab at index 1 if there are enough controllers
                if controllers.count >= 1 {
                    controllers.insert(tabBarVC.setServicesVC(), at: 1) // Insert at index 1
                    tabBarVC.viewControllers = controllers
                } else {
                    // If there are no view controllers or less than 1, just append it
                    controllers.append(tabBarVC.setServicesVC())
                    tabBarVC.viewControllers = controllers
                }
            } else {
                print("Tab is already added.")
            }
        }
    }

    
    
}

extension ChooseAppVC{
    
    func getDetailedAddressFromLatLon(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let apiKey = ClientModel.currentClientData.google_map_keys
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(apiKey ?? "")")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first {
                    
                    var addressString = ""
                    
                    if let formattedAddress = firstResult["formatted_address"] as? String {
                        addressString += formattedAddress
                    }
                    
                    // Extract specific components if needed
                    if let addressComponents = firstResult["address_components"] as? [[String: Any]] {
                        for component in addressComponents {
                            if let types = component["types"] as? [String],
                               types.contains("establishment") {
                                if let establishmentName = component["long_name"] as? String {
                                    addressString = establishmentName + ", " + addressString
                                }
                            }
                        }
                    }
                    
                    
                    
                    completion(addressString)
                } else {
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }


}
