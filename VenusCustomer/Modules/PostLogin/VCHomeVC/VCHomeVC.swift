//
//  VCHomeVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit
import GoogleMaps
import CoreLocation
import FloatingPanel
import ImageIO
import SwiftyGif

class VCHomeVC: VCBaseVC {
    
    // MARK: -> Outlets
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var mapBaseView: UIView!
    @IBOutlet weak var createRideView: UIView!
 
    @IBOutlet weak var lblRentals: UILabel!
    @IBOutlet weak var imgRentals: UIImageView!
    @IBOutlet weak var imgOutStation: UIImageView!
    @IBOutlet weak var heightPromotionCollView: NSLayoutConstraint!
    // @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtFldLoc: UITextField!
    var timer: Timer?
    var timerBanner: Timer?
    @IBOutlet weak var btnRental: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var promotionCollView: UICollectionView!
    @IBOutlet weak var lblRide: UILabel!
    // @IBOutlet weak var lblNow: UILabel!
    //  @IBOutlet weak var btnNow: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewRide: UIImageView!
    
    @IBOutlet weak var lblCurrentLoc: UILabel!
    @IBOutlet weak var imgViewSchedule: UIImageView!
    
    @IBOutlet weak var heightBannerCollView: NSLayoutConstraint!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    //  @IBOutlet weak var lblRide: UILabel!
    
    
    // MARK: - Variables
    private var currentIndex = 0
    private var pickUpPlace: GooglePlacesModel?
    private var pickUpLocation: GeometryFromPlaceID?
    lazy var fpc = FloatingPanelController()
    private var dropPlace: GooglePlacesModel?
    private var dropLocation: GeometryFromPlaceID?
    
    private var markerDriver: GMSMarker?
    var currentGMSPath: GMSPath?
    var completeGmsPath : GMSPath?
    var travelledGmsPath : GMSPath?
    var completePolyline : GMSPolyline?
    var travelledPolyline : GMSPolyline?
    var pickUpLoc = ""
    var dropOffLoc = ""
    var utcDate = ""
    var isSechdule = false
    var markerUser : GMSMarker?
    //    var infoWindowETA : MarkerInfoView?
    var requestedPathCoordinates : CLLocationCoordinate2D?
    private var isScheduleViewVisible = false
    
    // Update Nearby drivers variables
    private var timerToRefreshNearbyDriver: Timer?
    private let timerIntervalToRefersh: TimeInterval = 60.0
    var didPressHome: (()->Void)?
    var objOperator_availablity : operator_availablityy?
    var currentPage = 0
    var currentPageBanner = 0

    // TODO: - DEINIT METHOD
    deinit {
        stopTimer()
    }
    var bannerPromotion : [homeBanners]?
    var banner : [homeBanners]?

    //  To create ViewModel
    private var viewModel = VCHomeViewModel()
    var commingFrom = 1
    
    static func create() -> VCHomeVC {
        let obj = VCHomeVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func initialSetup() {
        
   
        bannerPromotion = UserModel.currentUser.login?.home_banners?.filter { $0.banner_type_id == 1 }
        banner = UserModel.currentUser.login?.home_banners?.filter { $0.banner_type_id != 1 }
        heightPromotionCollView.constant = (self.view.frame.width - 30) / 2.56
        checkLocationPermission()
        
        
        
        if isNotificationReceivedForMessage == true{
            NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: nil)
        }
        // mapBaseView.addShadowView()
        createRideView.addShadowView()
        
        callbacks()
        addObservers()
        self.startTimerToRefreshNearbyDrivers()
        self.resetMapToDefaultState()
        
        if LocationTracker.shared.isCurrentLocationAvailable {
            
        }
        animationReferral()
        
                setupCollectionView()
                setupPageControl()
                setupPageControlBanner()
                startAutoScroll()
                startAutoScrollBanner()
        if ClientModel.currentClientData.enabled_service! == 3{
            if self.objOperator_availablity?.id == 1{
               
                self.lblRide.text = "Ride"
                imgViewRide.image = UIImage(named: "NowRide")
                imgViewSchedule.image = UIImage(named: "calRide")
                self.lblRentals.text = "Rental"
                self.tabBarController?.tabBar.items?[1].title = "Trips"
            }else{
                
                imgViewRide.image = UIImage(named: "NowDel")
                imgViewSchedule.image = UIImage(named: "calDel")
                self.lblRide.text = "Now"
                self.lblRentals.text = "Rental"
                imgOutStation.image = UIImage(named: "outDel")
                imgRentals.image = UIImage(named: "NowDel")
                self.tabBarController?.tabBar.items?[1].title = "Deliveries"
            }
            setHomeVC()
            
        }else if ClientModel.currentClientData.enabled_service! == 2{
            requestRideType = 2
            imgViewRide.image = UIImage(named: "NowDel")
            imgViewSchedule.image = UIImage(named: "calDel")
            self.lblRide.text = "Now"
            self.lblRentals.text = "Rental"
            imgOutStation.image = UIImage(named: "outDel")
            imgRentals.image = UIImage(named: "NowDel")
            self.tabBarController?.tabBar.items?[2].title = "Deliveries"
           
        }else{
            requestRideType = 1
            self.lblRide.text = "Ride"
            self.lblRentals.text = "Rental"

            imgViewRide.image = UIImage(named: "NowRide")
            imgViewSchedule.image = UIImage(named: "calRide")
            self.tabBarController?.tabBar.items?[2].title = "Trips"
           
        }
    }
    
    func animationReferral(){
        
        if messgaeReferal != ""{
            messgaeReferal = ""
            SKToast.show(withMessage: messgaeReferal)
        }
        
        if isReferee == true{
            isReferee = false
            let confettiView = ConfettiView(frame: view.bounds)
            view.addSubview(confettiView)
        }
    }
    private func setupCollectionView() {
          
           if let layout = promotionCollView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .horizontal
               layout.minimumLineSpacing = 0
           }
        promotionCollView.isPagingEnabled = true
        
        if let layout = collectionViewBanner.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        collectionViewBanner.isPagingEnabled = true
        
       }
    private func setupPageControl() {
        pageControl.numberOfPages = bannerPromotion?.count ?? 0
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
    }
    
    private func setupPageControlBanner() {
        bannerPageControl.numberOfPages = banner?.count ?? 0
        bannerPageControl.currentPage = 0
        bannerPageControl.hidesForSinglePage = true
    }
    // MARK: - Auto Scroll
    private func startAutoScroll() {
        if ((bannerPromotion?.count ?? 0) > 1)
        {
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                self?.scrollToNextPage()
            }
        }
      
    }
    
    // MARK: - Auto Scroll Banner
    private func startAutoScrollBanner() {
        if ((banner?.count ?? 0) > 1)
        {
            timerBanner = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                self?.scrollToNextPageBanner()
            }
        }
      
    }
    
    private func scrollToNextPage() {
        guard let banner =  self.bannerPromotion else { return }
        let nextIndex = (currentPage + 1) % (banner.count)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        promotionCollView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentPage = nextIndex
        pageControl.currentPage = currentPage
    }
    
    private func scrollToNextPageBanner() {
        guard let banner =  self.banner else { return }
        let nextIndex = (currentPageBanner + 1) % (banner.count)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionViewBanner.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentPageBanner = nextIndex
        bannerPageControl.currentPage = currentPageBanner
    }
 
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    private func stopAutoScrollBanner() {
        timerBanner?.invalidate()
        timerBanner = nil
    }
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
            if let address = address {
                DispatchQueue.main.async {
                   
                    self.lblCurrentLoc.text = address
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
       
        self.addMarkerToPosition(coordinates)
        viewModel.findnearbyDriver(id: self.objOperator_availablity?.id ?? 0)
    }
    
    @IBAction func btnRentalAct(_ sender: UIButton) {
        
        let rentalVC = RentalVC.create(2)
        rentalVC.didPressSubmit = { utcDate,utcDateEnd in
            print(utcDate)
            
        }
        rentalVC.onConfirm = { (findDriverData,placeId,loc: String,objOperator_availablity,utcStartDate,utcEndDate,scheduleRide) in
            // Need to call distance api here
            if self.pickUpLocation == nil{
                self.pickUpLocation = placeId
            }
            
          //  if self.objOperator_availablity?.id == 1{
                let vc = VCOnGoingRideVC.create()
                vc.dropPlace = self.dropPlace
                vc.drop_date = utcEndDate
                vc.is_for_rental = true
                vc.dropLocation = self.dropLocation
                vc.pickUpPlace = self.pickUpPlace
                vc.pickUpLocation = self.pickUpLocation
                vc.regions = findDriverData.regions
                vc.pickupLoc = loc
                vc.start_date = utcStartDate
                vc.dropoffLoc = self.dropOffLoc
                vc.isSechdule = scheduleRide
                vc.utcDate = self.utcDate
                vc.customerETA = findDriverData.customerETA
                vc.objOperator_availablity = objOperator_availablity
              
                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//
//                let vc = self.storyboard?.instantiateViewController(identifier: "TrackOrderVc") as! TrackOrderVc
//                vc.dropPlace = self.dropPlace
//                vc.dropLocation = self.dropLocation
//                vc.pickUpPlace = self.pickUpPlace
//                vc.pickUpLocation = self.pickUpLocation
//                vc.regions = findDriverData.regions
//                vc.pickupLoc = loc
//                vc.dropoffLoc = self.dropOffLoc
//                vc.isSechdule = self.isSechdule
//                vc.utcDate = self.utcDate
//                vc.customerETA = findDriverData.customerETA
//                vc.objOperator_availablity = objOperator_availablity
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
            
            
            
           
        }
        rentalVC.onPickUpClicked = { (pickup: Int, loc: String,placeId) in
            let vc = VCPickUpDropVC.create(0)
            vc.selectedPlaceDetails = {place, placeLocation in
                // self.pickUpPlace = placeDetail
                self.pickUpLocation = placeLocation
                
                if rentalVC.pickUpPlace?.description == nil{
                    rentalVC.pickUpPlace?.description = ""
                }
                self.pickUpLoc = place
               // scheduleVC.pickUpPlace?.description
               // scheduleVC.pickUpTF.text = loc
                //scheduleVC.pickUpPlace?.description = "\(desc!)"
                rentalVC.setPickUpLocation = place
                rentalVC.pickUpLocation = placeLocation
                
            }
            vc.modalPresentationStyle = .overFullScreen
            rentalVC.setPickUpLocation = loc
            rentalVC.pickUpLocation = placeId
           
            self.navigationController?.present(vc, animated: true)
        }
        rentalVC.objOperator_availablity = self.objOperator_availablity
        rentalVC.onDropClicked = { (drop: Int, loc: String) in
            let vc = VCPickUpDropVC.create(1)
            vc.selectedPlaceDetails = { place,placeLocation in
               // self.dropPlace = placeDetail
                self.dropLocation = placeLocation
                rentalVC.dropPlace?.description = place
                rentalVC.setDropLocation = place
                rentalVC.dropLocation = placeLocation
                self.dropOffLoc = place
            }
            vc.modalPresentationStyle = .overFullScreen
           // scheduleVC.setDropLocation = loc
            self.navigationController?.present(vc, animated: true)
        }
        rentalVC.utcDate = self.utcDate
        rentalVC.view.frame = self.view.bounds
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(rentalVC.view)
        self.addChild(rentalVC)
        rentalVC.didMove(toParent: self)

    }
    

    // TODO: -> Home TabbarItem
    func setHomeVC(){
        self.tabBarController?.tabBar.items?[0].selectedImage = VCImageAsset.back.asset?.withRenderingMode(.alwaysTemplate)
        self.tabBarController?.tabBar.items?[0].title = "Back"
        self.tabBarController?.tabBar.items?[0].imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        
     //   removeSpecificTab()

    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        
       // lblNow.text = "Now"
        if isScheduleViewVisible {
            self.tabBarController?.tabBar.isHidden = true
        } else {
            self.tabBarController?.tabBar.isHidden = false
        }
        viewModel.fetchOngoingRide(completion: {
            if self.viewModel.ongoingTrips.count > 0{
                if self.viewModel.ongoingTrips?[0].status == 0{
                    let cancelReasonVC = VCCancelPopUpVC.create()
                    cancelReasonVC.modalPresentationStyle = .overFullScreen
                    cancelReasonVC.status = 0
                   // cancelReasonVC.rideRequestDetails?.session_id = self.viewModel.ongoingTrips[0].session_id
                    cancelReasonVC.objOngoingTripModel = self.viewModel.ongoingTrips[0]
                    
                    cancelReasonVC.onConfirm = { value in
                        let vc = VCCancelRideVC.create()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.onConfirm = { value in
                            if value == 1  {
                                let cancelReasonVC = VCCancelReasonVC.create()
                                cancelReasonVC.sessionID = self.viewModel.ongoingTrips[0].session_id ?? 0
                                self.navigationController?.pushViewController(cancelReasonVC, animated: true)
                            }
                        }
                        self.navigationController?.present(vc, animated: true)
                    }
                    self.navigationController?.present(cancelReasonVC, animated: true)
                }
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
        //self.viewMap.camera = camera
        self.mapView.animate(to: camera)
    }

    private func callbacks() {
//        viewModel.callBackForOngoingRides = { trips in
//            if self.viewModel.ongoingTrips.count > 0{
//                if self.viewModel.ongoingTrips?[0].status != 0{
//                    if trips.count > 0{
//                        VCRouter.goToOngoingRide(trips)
//                    }
//                }
//            }
//        }

        viewModel.callBackForFetchNearbyDriver = { drivers in
            if let availableDrivers = drivers {
//                printDebug(drivers)
                self.updateNearByDrivers(availableDrivers)
            }
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatedRideStatus(_:)), name: NSNotification.Name.updateRideStatus, object: nil)
    }

    @objc private func updatedRideStatus(_ notification: Notification) {
        viewModel.fetchOngoingRide(completion: {})
    }
    
    @IBAction func btnGetCurrentLocation(_ sender: Any) {
        self.initialSetup()
    }
    
    @IBAction func btnRideAction(_ sender: Any) {
         isSechdule = false
        presentScreen()
      //  layoutPanelForPhone(controller: VCScheduleVC.create(0))
    }
    
    @IBAction func didPressSchedule(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        vc.didPressSubmit = { utcDate in
            print(utcDate)
            self.utcDate = utcDate
            self.isSechdule = true
            self.presentScreen()
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    func layoutPanelForPhone(controller:UIViewController) {
        self.fpc.surfaceView.shadowColor = .clear
        self.fpc.backdropView.shadowColor = .clear
        self.fpc.backdropView.shadowRadius = 0
        self.fpc.trackingScrollView?.shadowRadius = 0
        self.fpc.surfaceView.shadowRadius = 0
        self.fpc.surfaceView.grabberHandle.isHidden = true
        self.fpc.surfaceView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.fpc.surfaceView.layer.shadowRadius = 0
        self.fpc.surfaceView.layer.shadowOpacity = 0
        self.fpc.surfaceView.layer.shadowColor = UIColor.clear.cgColor
        fpc.isRemovalInteractionEnabled = false
        self.fpc.contentMode = .fitToBounds
       // self.Details?.commingfrom = self.commingFrom
//        if let scroll = self.Details?.tableView{
//            fpc.track(scrollView: scroll) // Only track the table view on iPhone
//        }
        self.fpc.set(contentViewController: controller)
        fpc.addPanel(toParent: self, animated: true)
        fpc.setAppearanceForPhone()
    }
    

    @IBAction func scheduleBtn(_ sender: UIButton) {
       // lblNow.text = "Schedule"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        vc.didPressSubmit = { utcDate in
            print(utcDate)
            self.utcDate = utcDate
            self.isSechdule = true
            self.presentScreen()
        }
        self.navigationController?.present(vc, animated: true)
      //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
//        vc.modalPresentationStyle = .overFullScreen
//        vc.openAddAddress = { address in
//            let vc = VCAddressVC.create()
//            vc.modalPresentationStyle = .overFullScreen
//            self.navigationController?.present(vc, animated: true)
//        }
//        vc.onPickUpClicked = { (pickup: Int, loc: String,placeId) in
//            let vc = VCPickUpDropVC.create(0)
//            vc.modalPresentationStyle = .overFullScreen
//            self.navigationController?.present(vc, animated: true)
//        }
//
//        vc.onDropClicked = { (drop: Int, loc: String) in
//            let vc = VCPickUpDropVC.create(1)
//            vc.modalPresentationStyle = .overFullScreen
//            self.navigationController?.present(vc, animated: true)
//        }
      //  self.navigationController?.present(vc, animated: true)
    }

    @IBAction func createRideBtn(_ sender: UIButton) {
        self.isSechdule = false
        presentScreen()
    }
    
    func presentScreen(){
        let scheduleVC = VCScheduleVC.create(0)
        scheduleVC.objOperator_availablity = self.objOperator_availablity
        scheduleVC.cancelScheduleRideAction = { cancelConfirmed in
            self.isScheduleViewVisible = false
        }
        
        scheduleVC.onConfirm =  { (findDriverData,placeId,loc: String,objOperator_availablity) in
            // Need to call distance api here
            if self.pickUpLocation == nil{
                self.pickUpLocation = placeId
            }
            
          //  if self.objOperator_availablity?.id == 1{
                let vc = VCOnGoingRideVC.create()
                vc.dropPlace = self.dropPlace
                vc.dropLocation = self.dropLocation
                vc.pickUpPlace = self.pickUpPlace
                vc.pickUpLocation = self.pickUpLocation
                vc.regions = findDriverData.regions
                vc.pickupLoc = loc
                vc.dropoffLoc = self.dropOffLoc
                vc.isSechdule = self.isSechdule
                vc.utcDate = self.utcDate
                vc.customerETA = findDriverData.customerETA
                vc.objOperator_availablity = objOperator_availablity
              
                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//               
//                let vc = self.storyboard?.instantiateViewController(identifier: "TrackOrderVc") as! TrackOrderVc
//                vc.dropPlace = self.dropPlace
//                vc.dropLocation = self.dropLocation
//                vc.pickUpPlace = self.pickUpPlace
//                vc.pickUpLocation = self.pickUpLocation
//                vc.regions = findDriverData.regions
//                vc.pickupLoc = loc
//                vc.dropoffLoc = self.dropOffLoc
//                vc.isSechdule = self.isSechdule
//                vc.utcDate = self.utcDate
//                vc.customerETA = findDriverData.customerETA
//                vc.objOperator_availablity = objOperator_availablity
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
            
            
            
           
        }
        
        scheduleVC.openAddAddress = { address in
            let vc = VCAddressVC.create()
            vc.addAddressCallBack  = { newText in
                //  self.dismiss(animated: true)
                NotificationCenter.default.post(name: .refresh, object: nil, userInfo: ["newText": newText])
            }
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }
        scheduleVC.onPickUpClicked = { (pickup: Int, loc: String,placeId) in
            let vc = VCPickUpDropVC.create(0)
            vc.selectedPlaceDetails = {place, placeLocation in
                // self.pickUpPlace = placeDetail
                self.pickUpLocation = placeLocation
                
                if scheduleVC.pickUpPlace?.description == nil{
                    scheduleVC.pickUpPlace?.description = ""
                }
                self.pickUpLoc = place
               // scheduleVC.pickUpPlace?.description
               // scheduleVC.pickUpTF.text = loc
                //scheduleVC.pickUpPlace?.description = "\(desc!)"
                scheduleVC.setPickUpLocation = place
                scheduleVC.pickUpLocation = placeLocation
                
            }
            vc.modalPresentationStyle = .overFullScreen
            scheduleVC.setPickUpLocation = loc
            scheduleVC.pickUpLocation = placeId
           
            self.navigationController?.present(vc, animated: true)
        }

        scheduleVC.onDropClicked = { (drop: Int, loc: String) in
            let vc = VCPickUpDropVC.create(1)
            vc.selectedPlaceDetails = { place,placeLocation in
               // self.dropPlace = placeDetail
                self.dropLocation = placeLocation
                scheduleVC.dropPlace?.description = place
                scheduleVC.setDropLocation = place
                scheduleVC.dropLocation = placeLocation
                self.dropOffLoc = place
            }
            vc.modalPresentationStyle = .overFullScreen
           // scheduleVC.setDropLocation = loc
            self.navigationController?.present(vc, animated: true)
        }
        scheduleVC.utcDate = self.utcDate
        scheduleVC.isSechdule = self.isSechdule
        isScheduleViewVisible = true
        scheduleVC.view.frame = self.view.bounds
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(scheduleVC.view)
        self.addChild(scheduleVC)
        scheduleVC.didMove(toParent: self)

//        vc.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(vc, animated: true)
    }
}

extension VCHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewBanner{
            return banner?.count ?? 0
        }
        return bannerPromotion?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollCell", for: indexPath) as! HomeBannerCollCell
        if collectionView == collectionViewBanner{
            cell.imgviewBanner.setImage(withUrl: banner?[indexPath.row].banner_image ?? "") { status, image in}
        }
        else
        {
            cell.imgviewBanner.setImage(withUrl: bannerPromotion?[indexPath.row].banner_image ?? "") { status, image in}

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewBanner{
            return CGSizeMake(collectionViewBanner.frame.width,  collectionViewBanner.frame.width / 2.56)
        }
        return CGSizeMake(promotionCollView.frame.width,  promotionCollView.frame.width / 2.56)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner{
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            currentPageBanner = pageIndex
            bannerPageControl.currentPage = pageIndex
        }
else{
    let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    currentPage = pageIndex
    pageControl.currentPage = pageIndex

}
       }

       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           if scrollView == collectionViewBanner{
               stopAutoScrollBanner()
           }
           else{
               stopAutoScroll() // Stop auto-scroll when user starts dragging
           }
       }

       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if scrollView == collectionViewBanner{
               startAutoScrollBanner() // Restart auto-scroll after user stops dragging
           }
           else{
               startAutoScroll() // Restart auto-scroll after user stops dragging
           }
       }
    
}

// MARK: - Reset Offers Cell
extension VCHomeVC {
//    private func configureCellSize(index : Int) -> CGSize {
//        guard let cell = Bundle.main.loadNibNamed("VCOffersCollectionCell", owner: self, options:nil)?.first as? VCOffersCollectionCell else { return CGSize(width: 0, height: 0) }
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        let width = offersCollectionView.width
//        let height: CGFloat = 0
//        let targetSize = CGSize(width: width, height: height)
//        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
//        return size
//    }
}

// MARK: - Update Nearby Driver using timer
extension VCHomeVC {

    // Function to start the timer
    private func startTimerToRefreshNearbyDrivers() {
        stopTimer()
        delay(withSeconds: 0.5) {
            self.timerToRefreshNearbyDriver = Timer.scheduledTimer(timeInterval: self.timerIntervalToRefersh, target: self, selector: #selector(self.apiCallforRefreshNearbyDriver(_ :)), userInfo: nil, repeats: true)
        }
    }

    private func stopTimer() {
        timerToRefreshNearbyDriver?.invalidate()
        timerToRefreshNearbyDriver = nil
    }

    @objc private func apiCallforRefreshNearbyDriver(_ timer: TimeInterval) {
        if LocationTracker.shared.isCurrentLocationAvailable {
           // viewModel.findnearbyDriver()
        }
    }
}
extension Notification.Name {
    static let refresh = Notification.Name("textDidChange")
}
extension FloatingPanelController {
    func setAppearanceForPhone() {
        let appearance = SurfaceAppearance()
        if #available(iOS 13.0, *) {
            appearance.cornerCurve = .continuous
        }
        appearance.cornerRadius = 25.0
        appearance.backgroundColor = .clear
        surfaceView.appearance = appearance
    }
}
extension VCHomeVC{
    func checkLocationPermission() {
           if CLLocationManager.locationServicesEnabled() {
               if #available(iOS 14.0, *) {
                   switch locationManager.authorizationStatus {
                   case .notDetermined:
                       // Request permission
                       locationManager.requestWhenInUseAuthorization()
                   case .restricted, .denied:
                       // Show alert and guide user to Settings
                       showLocationAccessAlert()
                   case .authorizedWhenInUse, .authorizedAlways:
                       // Permission granted
                       print("Location permission granted.")
                       locationManager.startUpdatingLocation()
                   @unknown default:
                       break
                   }
               } else {
                   // Fallback on earlier versions
               }
           } else {
               // Show alert for disabled location services
               print("Location services are not enabled.")
           }
       }
       
       // Show alert to guide user to app settings
       func showLocationAccessAlert() {
           let alertController = UIAlertController(
               title: "Location Access Needed",
               message: "Location access is required for this feature. Please enable location services in the Settings.",
               preferredStyle: .alert
           )
           
           // Add a "Settings" button to redirect the user to the app's settings
           alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
               if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                   if UIApplication.shared.canOpenURL(appSettings) {
                       UIApplication.shared.open(appSettings)
                   }
               }
           })
           
           // Add a "Cancel" button
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           // Present the alert (Assuming this method is in a view controller)
           if let topController = UIApplication.shared.windows.first?.rootViewController {
               topController.present(alertController, animated: true, completion: nil)
           }
       }
}
extension VCHomeVC{
    
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

