//
//  DeliveryHomeVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 16/10/24.
//

import UIKit
import GoogleMaps
import CoreLocation
import FloatingPanel
class DeliveryHomeVC: VCBaseVC {
    
    @IBOutlet weak var imgViewGif: UIImageView!
    // MARK: -> Outlets
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var mapBaseView: UIView!
    @IBOutlet weak var createRideView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
   // @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtFldLoc: UITextField!
    
    @IBOutlet weak var lblRide: UILabel!
   // @IBOutlet weak var lblNow: UILabel!
  //  @IBOutlet weak var btnNow: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewRide: UIImageView!
    
    @IBOutlet weak var lblCurrentLoc: UILabel!
    @IBOutlet weak var imgViewSchedule: UIImageView!
    
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
    
    // TODO: - DEINIT METHOD
    deinit {
        stopTimer()
    }

    //  To create ViewModel
    private var viewModel = VCHomeViewModel()
    var commingFrom = 1
    
    static func create() -> DeliveryHomeVC {
        let obj = DeliveryHomeVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

    override func initialSetup() {
        //DispatchQueue.main.async {
          //  self.imgViewGif.image = UIImage.gif(name: "gifHome")
       // }
        checkLocationPermission()
        if self.objOperator_availablity?.id == 1{
            self.lblRide.text = "Ride"
           // imgViewRide.image = UIImage(named: "car-ride")
           // imgViewSchedule.image = UIImage(named: "car-schedule")
        }else{
           // imgViewRide.image = UIImage(named: "fast")
          //  imgViewSchedule.image = UIImage(named: "schedule2")
            self.lblRide.text = "Now"
        }
        
        setHomeVC()
        if isNotificationReceivedForMessage == true{
            NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: nil)
        }
       // mapBaseView.addShadowView()
        createRideView.addShadowView()
     //   offersCollectionView.delegate = self
     //   offersCollectionView.dataSource = self
    //    self.offersCollectionView.register(UINib(nibName: "VCOffersCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VCOffersCollectionCell")
        callbacks()
        addObservers()
        self.startTimerToRefreshNearbyDrivers()
        self.resetMapToDefaultState()

        if LocationTracker.shared.isCurrentLocationAvailable {
           
        }
        animationReferral()
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
    
  

    // TODO: -> Home TabbarItem
    func setHomeVC(){
        self.tabBarController?.tabBar.items?[0].selectedImage = VCImageAsset.back.asset?.withRenderingMode(.alwaysTemplate)
        self.tabBarController?.tabBar.items?[0].title = "Back"
        self.tabBarController?.tabBar.items?[0].imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

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
        viewModel.callBackForOngoingRides = { trips in
            if self.viewModel.ongoingTrips.count > 0{
                if self.viewModel.ongoingTrips?[0].status != 0{
                    if trips.count > 0{
                        VCRouter.goToOngoingRide(trips)
                    }
                }
            }
        }

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

extension DeliveryHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollCell", for: indexPath) as! HomeBannerCollCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewBanner.frame.width, height: collectionViewBanner.frame.height)
    }
    
}

// MARK: - Reset Offers Cell
extension DeliveryHomeVC {
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
extension DeliveryHomeVC {

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
//extension Notification.Name {
//   // static let refresh = Notification.Name("textDidChange")
//}
//extension FloatingPanelController {
//    func setAppearanceForPhone() {
//        let appearance = SurfaceAppearance()
//        if #available(iOS 13.0, *) {
//            appearance.cornerCurve = .continuous
//        }
//        appearance.cornerRadius = 25.0
//        appearance.backgroundColor = .clear
//        surfaceView.appearance = appearance
//    }
//}
extension DeliveryHomeVC{
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
extension DeliveryHomeVC{
    
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
