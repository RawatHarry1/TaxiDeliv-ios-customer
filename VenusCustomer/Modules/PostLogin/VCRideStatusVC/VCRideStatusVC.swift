//
//  VCRideStatusVC.swift
//  VenusCustomer
//
//  Created by Amit on 16/07/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SocketIO

class VCRideStatusVC: VCBaseVC,navigateToEndRideFromChat {
   

    @IBOutlet weak var iconLocation: UIImageView!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var btnSOS: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var awayShadowView: UIView!

    @IBOutlet weak var cancelRideSV: UIStackView!
    
    @IBOutlet weak var descLbl: UILabel!

    @IBOutlet weak var pickLocationLbl: UILabel!
    @IBOutlet weak var pickLocationView: UIView!
    
    @IBOutlet weak var viewArrived: UIView!
    @IBOutlet weak var rideDetailsSV: UIStackView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var canNoBtn: UIButton!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var rideStatusLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var btnETA: UILabel!
    
    var ongoingTrips : [OngoingTripModel]?
    var distanceThresholdValue = 20
    private var viewModel = VCHomeViewModel()
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()

    var completeGmsPath : GMSPath?
    var travelledGmsPath : GMSPath?
    var completePolyline : GMSPolyline?
    var travelledPolyline : GMSPolyline?
    var destinationAddress = ""
//    var infoWindowETA : MarkerInfoView?
    var requestedPathCoordinates : CLLocationCoordinate2D?
    var polyLinePath = ""
    var status = 0
    var isUpdateOnce = true
    var phoneNo = ""
    @IBOutlet weak var viewPackagesLbl: UILabel!
    var arrPathCoordinates = [CLLocationCoordinate2D]()
    var driverImage = ""
    var driverName = ""
    var tripId = ""
    var driverId = ""
    var routeBearings = 0.0
    //  To create ViewModel
    static func create() -> VCRideStatusVC {
        let obj = VCRideStatusVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        getMarkertFirstTime(source: coordinates)
           
    }

    override func initialSetup() {
        
        // Create an NSAttributedString with an underline
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attributedString = NSAttributedString(string: viewPackagesLbl.text!, attributes: attributes)
        // Enable user interaction on the label
        viewPackagesLbl.isUserInteractionEnabled = true

        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))

        // Add the gesture recognizer to the label
        viewPackagesLbl.addGestureRecognizer(tapGesture)
        // Assign the attributed string to the label
        viewPackagesLbl.attributedText = attributedString
        mapView.setMinZoom(5.0, maxZoom: 16.0)
       // viewDot.isHidden = true
       // if SocketManager.status != .connecting {
        VCSocketIOManager.shared.connectSocket()
       // }
        cancelRideSV.isHidden = true
        VCSocketIOManager.shared.connectSocket {
            VCSocketServices.shared.listenForDriverEvents()
            NotificationCenter.default.post(name: .updateLocationListenerOnConnect, object: nil)
        }
        guard let trips = ongoingTrips else { return }
        updateRideStatus(trips)
        callbacks()
        addObservers()
        fetchOngoingApi()
    }
    // Define the action for the tap gesture
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        // Handle the tap event here
        print("Label tapped!")
        let vc = VCPackageDetailVC.create()
        vc.modalPresentationStyle = .overCurrentContext
        vc.deliveryPackages = viewModel.deliveryPackages
        self.present(vc, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewDot.isHidden = true
    }
//    var deliveryPackages : [DeliveryPackages]?
    func fetchOngoingApi(){
        
        viewModel.fetchOngoingRide(completion: {
            self.isUpdateOnce = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageNotify(notification:)), name: .newMessage, object: nil)
            if self.viewModel.ongoingTrips.count > 0{
                let obj = self.viewModel.ongoingTrips[0]
                if obj.status == 0{
                    self.viewPackagesLbl.isHidden = obj.service_type == 1 ? true : false
                    let pickupLocation = CLLocationCoordinate2D(latitude: obj.latitude ?? 0.0, longitude: obj.longitude ?? 0.0)
                    let destinationCoordinates = CLLocationCoordinate2D(latitude: obj.request_drop_latitude ?? 0.0, longitude: obj.request_drop_longitude ?? 0.0)
                    let driverBearing = 0.0//self.calculateBearing(from: pickupLocation, to: destinationCoordinates)
                    self.updateMarkersPositionForRide(driverBearing, pickupLocation , destinationCoordinates, true)
                }else if obj.status == 1{
                    let pickupLocation = CLLocationCoordinate2D(latitude: obj.driver_current_latitude ?? 0.0, longitude: obj.driver_current_longitude ?? 0.0)
                    let destinationCoordinates = CLLocationCoordinate2D(latitude: obj.latitude ?? 0.0, longitude: obj.longitude ?? 0.0)
                    let driverBearing = 0.0//self.calculateBearing(from: pickupLocation, to: destinationCoordinates)
                    self.updateMarkersPositionForRide(driverBearing, pickupLocation , destinationCoordinates, true)
                }else if obj.status == 14{
                    let pickupLocation = CLLocationCoordinate2D(latitude: obj.driver_current_latitude ?? 0.0, longitude: obj.driver_current_longitude ?? 0.0)
                    let destinationCoordinates = CLLocationCoordinate2D(latitude: obj.latitude ?? 0.0, longitude: obj.longitude ?? 0.0)
                    let driverBearing = 0.0 //self.calculateBearing(from: pickupLocation, to: destinationCoordinates)
                    self.updateMarkersPositionForRide(driverBearing, pickupLocation , destinationCoordinates, true)
                }else{
                    let pickupLocation = CLLocationCoordinate2D(latitude: obj.latitude ?? 0.0, longitude: obj.longitude ?? 0.0)
                    let destinationCoordinates = CLLocationCoordinate2D(latitude: obj.request_drop_latitude ?? 0.0, longitude: obj.request_drop_longitude ?? 0.0)
                    let driverBearing = 0.0//self.calculateBearing(from: pickupLocation, to: destinationCoordinates)
                    self.updateMarkersPositionForRide(driverBearing, pickupLocation , destinationCoordinates, true)
                }
            }
        })
    }

    override func viewDidLayoutSubviews() {
        baseView.roundCorner([.topLeft, .topRight], radius: 32)
        awayShadowView.addShadowView(radius: 3)
    }
    
//    func calculateBearing(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D) -> CLLocationDirection {
//        let lat1 = startLocation.latitude.toRadians()
//        let lon1 = startLocation.longitude.toRadians()
//
//        let lat2 = endLocation.latitude.toRadians()
//        let lon2 = endLocation.longitude.toRadians()
//
//        let deltaLongitude = lon2 - lon1
//        let y = sin(deltaLongitude) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude)
//
//        let initialBearing = atan2(y, x).toDegrees()
//        return (initialBearing + 360).truncatingRemainder(dividingBy: 360)
//    }
    
    @objc func newMessageNotify(notification: Notification) {
        self.viewDot.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
        vc.driverID = self.driverId
        vc.name = self.driverName
        vc.profileImg  = driverImage
        vc.tripID = self.tripId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEndRide() {
        guard let trips = ongoingTrips else { return }
        if trips.count > 0 {
            let tripDetails = trips[0]
            let vc = VCFeedbackVC.create() // Assuming you have a create() method to instantiate the VC
            var tripHistory = TripHistoryDetails()
            tripHistory.engagement_id = tripDetails.trip_id
            tripHistory.driver_name = tripDetails.driver_name
            vc.driver_id = tripDetails.driver_id ?? 0
            vc.selectedTrip = tripHistory
            vc.modalPresentationStyle = .overFullScreen
            vc.viewcontrollerType = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    

    @IBAction func btnCall(_ sender: Any) {
        
    }
    
    func startListeningDriverUpdates(_ tripDetail: OngoingTripModel) {
        
        self.driverId = "\(tripDetail.driver_id ?? 0)"
        self.driverName = tripDetail.driver_name ?? ""
        self.tripId = "\(tripDetail.trip_id ?? 0)"
        self.driverImage = tripDetail.driver_image ?? ""
      //  btnETA.text = "\(tripDetail.eta ?? 0) min"
        print("\(tripDetail.eta ?? 0) min")
        var objc = [String:Any]()
        var param: JSONDictionary {
            objc["engagementId"] = tripDetail.trip_id
            if let operatorToken = ClientModel.currentClientData.operator_token {
                objc["operatorToken"] = operatorToken
            }
            if let accessToken = UserModel.currentUser.access_token {
                objc["accessToken"] = accessToken
            }
            return objc
        }
        VCSocketIOManager.shared.emit(with: .customerTracking, param, loader: false)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRideStatus(_:)), name: NSNotification.Name.updateRideStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rideEndedAction(_:)), name: NSNotification.Name.rideEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelRideAction(_:)), name: NSNotification.Name.cancelRide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(driverLocationUpdated(_:)), name: NSNotification.Name.driverLocationListner, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateRideListener(_:)), name: NSNotification.Name.updateLocationListenerOnConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.messageReceiver, object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        self.viewDot.isHidden = false
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
//        vc.driverID = self.driverId
//        vc.name = self.driverName
//        vc.profileImg  = driverImage
//        vc.tripID = self.tripId
//        vc.delegate = self
//        self.viewDot.isHidden = true
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.viewDot.isHidden = false
    }

    @objc func updateRideListener(_ notification: Notification) {
        guard let trips = ongoingTrips else { return }
        if trips.count > 0 {
            startListeningDriverUpdates(trips[0])
        }
    }
    
     func fethOngoing() {
        guard let trips = ongoingTrips else { return }
        if trips.count > 0 {
            startListeningDriverUpdates(trips[0])
        }
    }

    @objc func driverLocationUpdated(_ notification: Notification) {
        if let userdata = notification.userInfo as? [String:Any] {
            guard let trips = ongoingTrips else { return }
            
            if trips.count > 0 {
                if trips[0].status == 1 {
                    
                    let pickupLocation = CLLocationCoordinate2D(latitude: trips[0].latitude ?? 0.0, longitude: trips[0].longitude ?? 0.0)
                    
                    let destinationCoordinates = CLLocationCoordinate2D(latitude: trips[0].latitude ?? 0.0, longitude: trips[0].longitude ?? 0.0)
                    
                    
                    let driverBearing = userdata["bearing"] as! Double//calculateBearing(from: pickupLocation, to: destinationCoordinates) //userdata["bearing"] as! Double
                    self.updateMarkersPositionForRide(driverBearing, userdata["location"] as! CLLocationCoordinate2D, destinationCoordinates, true)
                    
                   // showMarker(Source: userdata["location"] as! CLLocationCoordinate2D , Destination: pickupLocation)
                    
                }
                else if trips[0].status == 2 {
                  
                    let destination =  CLLocationCoordinate2D(latitude: trips[0].request_drop_latitude ?? 0.0, longitude: trips[0].request_drop_longitude ?? 0.0)

                    let userDataa = userdata["location"] as! CLLocationCoordinate2D
                    
//                    let destinationCoordinates = CLLocationCoordinate2D(latitude: trips[0].request_drop_latitude ?? 0.0, longitude: trips[0].request_drop_longitude ?? 0.0)
                    let driverLoc = CLLocationCoordinate2D(latitude: userDataa.latitude, longitude: userDataa.longitude)
                    let driverBearing = userdata["bearing"] as! Double//calculateBearing(from: userDataa, to: destination)//userdata["bearing"] as! Double
                    self.updateMarkersPositionForRide(driverBearing, userdata["location"] as! CLLocationCoordinate2D, destination, true)
                   // showMarker(Source: driverLoc , Destination: destination)
                }else{
                    let destination = CLLocationCoordinate2D(latitude: trips[0].latitude ?? 0.0, longitude: trips[0].longitude ?? 0.0)
                    let driverBearing = userdata["bearing"] as! Double//calculateBearing(from: userdata["location"] as! CLLocationCoordinate2D, to: destination) //userdata["bearing"] as! Double
                    self.updateMarkersPositionForRide(driverBearing, userdata["location"] as! CLLocationCoordinate2D, destination, true)
                   // showMarker(Source: userdata["location"] as! CLLocationCoordinate2D , Destination: destination)
                }
            }
        }
    }

    @objc func refreshRideStatus(_ notification: Notification) {
        self.fetchOngoingApi()
    }
    
    @objc func cancelRideAction(_ notification: Notification) {
        VCRouter.goToSaveUserVC()
        
    }

    @objc func rideEndedAction(_ notification: Notification) {
        guard let trips = ongoingTrips else { return }
        if trips.count > 0 {
            let tripDetails = trips[0]
            let vc = VCFeedbackVC.create()
            var tripHistory = TripHistoryDetails()
            tripHistory.engagement_id = tripDetails.trip_id
            tripHistory.driver_name = tripDetails.driver_name
            vc.selectedTrip = tripHistory
            vc.modalPresentationStyle = .overFullScreen
            vc.viewcontrollerType = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func callbacks() {
        viewModel.callBackForOngoingRides = { trips in
            if trips.count > 0 {
                self.ongoingTrips = trips
                self.updateRideStatus(trips)
            } else {
                VCRouter.goToSaveUserVC()
            }
        }

        viewModel.polylineCallBack = { polyline in
            self.polyLinePath = polyline
            self.drawpolyLineForRide(polyline)
            //self.showPath(polyStr: polyline)
        }
    }
    
  //########################### Gurinder ##############################
    func showMarker(Source: CLLocationCoordinate2D, Destination: CLLocationCoordinate2D) {
        let driverCord = "\(Source.latitude)"  + "," +  "\(Source.longitude)"
        let locCord = "\(Destination.latitude)"  + "," +  "\(Destination.longitude)"
        viewModel.getNewPolyline("\(locCord)", "\(driverCord)")
        
        // Update Driver Marker
        if driverMarker.map == nil {
            driverMarker = GMSMarker(position: Source)
            driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
            driverMarker.isFlat = false
            driverMarker.map = mapView
        } else {
            driverMarker.position = Source
        }
        
        // Update Destination Marker
        if currentMarker.map == nil {
            currentMarker = GMSMarker(position: Destination)
            currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
            currentMarker.isFlat = false
            currentMarker.map = mapView
        } else {
            currentMarker.position = Destination
        }
        
        // Update camera position if necessary
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(driverMarker.position)
        bounds = bounds.includingCoordinate(currentMarker.position)
        
        let currentCameraPosition = self.mapView.camera.target
        if !bounds.contains(currentCameraPosition) {
            let cameraUpdate = GMSCameraUpdate.setTarget(Source) // Or fit(bounds, withPadding: 30)
            self.mapView.moveCamera(cameraUpdate)
        }
        
        // Saving old driver coordinates
        var newDriverCoordinates = [String:Any]()
        newDriverCoordinates["latitude"] = Source.latitude
        newDriverCoordinates["longitude"] = Source.longitude
        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
    }
//    func showMarker(Source : CLLocationCoordinate2D, Destination : CLLocationCoordinate2D){
//
//        let driverCord = "\(Source.latitude)"  + "," +  "\(Source.longitude)"
//        let locCord = "\(Destination.latitude)"  + "," +  "\(Destination.longitude)"
//        viewModel.getNewPolyline("\(locCord)", "\(driverCord)")
//
//        var bounds = GMSCoordinateBounds()
//        driverMarker.map = nil
//        driverMarker = GMSMarker(position: Source)
//        driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
//        driverMarker.isFlat = false
//        driverMarker.position = Source
//        driverMarker.map = mapView
//
//        bounds = bounds.includingCoordinate(driverMarker.position)
//
//        currentMarker.map = nil
//        currentMarker = GMSMarker(position: Destination)
//        currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
//        currentMarker.isFlat = false
//        currentMarker.position = Destination
//        currentMarker.map = mapView
//
//
//        currentMarker.map = self.mapView
//
//        var newDriverCoordinates = [String:Any]()
//        newDriverCoordinates["latitude"] = (Source.latitude )
//        newDriverCoordinates["longitude"] = (Source.longitude )
//        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
//
//    }
    
    func showPath(polyStr: String) {
        DispatchQueue.main.async {
           // self.mapView.clear()
            
            guard let path = GMSMutablePath(fromEncodedPath: polyStr) else { return }
            
            let markerPosition = path.coordinate(at: 0)
            let endPosition = path.coordinate(at: path.count() - 1)
            
            // Update or add markers
            self.addMarker(source: markerPosition, destination: endPosition)
            
            // Draw polyline
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 4.0
            polyline.strokeColor = VCColors.buttonSelectedOrange.color
            polyline.map = self.mapView
            
            // Adjust camera to fit bounds of the polyline
            var bounds = GMSCoordinateBounds()
            for index in 0..<path.count() {
                bounds = bounds.includingCoordinate(path.coordinate(at: index))
            }
            
            // Animate camera to fit polyline bounds, but only if needed
            let currentCameraPosition = self.mapView.camera.target
            if !bounds.contains(currentCameraPosition) {
                let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 75)
                self.mapView.animate(with: cameraUpdate)
            }
        }
    }


//    func showPath(polyStr :String){ //FROM API
//        DispatchQueue.main.async {
//            self.mapView.clear()
//            guard let path = GMSMutablePath(fromEncodedPath: polyStr) else {return }
//            let markerPostion = path.coordinate(at: 0)
//            let endPos = path.coordinate(at: path.count() - 1)
//            self.addMarker(source: markerPostion, destination: endPos)
//            let polyLine = GMSPolyline(path: path)
//            polyLine.strokeWidth = 4.0
//            polyLine.strokeColor = VCColors.buttonSelectedOrange.color
//            polyLine.map = self.mapView
//            var bounds = GMSCoordinateBounds()
//            for index in 1...path.count() {
//                bounds = bounds.includingCoordinate(path.coordinate(at: UInt(index)))
//            }
//           // let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30))
//          //  if self.isUpdateOnce == true{
//            //    self.isUpdateOnce = false
//                self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 75))
//           // }
//        }
//    }
    
   
//    func addMarker(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
//        driverMarker = GMSMarker(position: destination)
//        driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
//
//        driverMarker.position = destination
//        driverMarker.map = mapView
//
//        currentMarker = GMSMarker(position: source)
//        currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
//
//        currentMarker.position = source
//        currentMarker.map = mapView
//    }
    
    func addMarker(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        // Update Driver Marker
        if driverMarker.map == nil {
            driverMarker = GMSMarker(position: destination)
            driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
            driverMarker.map = mapView
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5) // Adjust animation duration as needed
            driverMarker.position = destination
            CATransaction.commit()
        }
        
        // Update Current Marker
        if currentMarker.map == nil {
            currentMarker = GMSMarker(position: source)
            currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
            currentMarker.map = mapView
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5) // Adjust animation duration as needed
            currentMarker.position = source
            CATransaction.commit()
        }
    }
    func getMarkertFirstTime(source: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            var bounds = GMSCoordinateBounds()
            
            // Check if currentMarker exists
            if self.currentMarker.map == nil {
                self.currentMarker = GMSMarker(position: source)
                self.currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
                self.currentMarker.map = self.mapView
            } else {
                self.currentMarker.position = source
            }
            
            // Update bounds to include currentMarker position
            bounds = bounds.includingCoordinate(self.currentMarker.position)
            
            // Animate camera to fit bounds with padding
            let update = GMSCameraUpdate.fit(bounds, withPadding: 75)
            self.mapView.animate(with: update)
        }
    }
//    func getMarkertFirstTime(source:CLLocationCoordinate2D){
//        var bounds = GMSCoordinateBounds()
//        currentMarker = GMSMarker(position: source)
//        currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
//        currentMarker.position = source
//        currentMarker.map = mapView
//        bounds = bounds.includingCoordinate(currentMarker.position)
//
//        let update = GMSCameraUpdate.fit(bounds, withPadding: 75)
//        mapView.animate(with: update)
//    }
    //##############################  END #########################################
    
    func updateRideStatus(_ trips: [OngoingTripModel]) {
        if trips.count > 0 {
            let tripDetails = trips[0]
            startListeningDriverUpdates(tripDetails)
            driverLbl.text = tripDetails.driver_name ?? ""
            ratingLbl.text = ((tripDetails.driver_rating ?? -1) == -1) ? "\(0)" : "\(tripDetails.driver_rating ?? -1)"
            if let urlStr = tripDetails.driver_image {
                self.profileImage.setImage(urlStr)
            }
            if let urlStr = tripDetails.image {
                self.vehicleImage.setImage(urlStr)
            }

            canNoBtn.setTitle(tripDetails.license_plate ?? "" , for: .normal)
            modelLbl.text = tripDetails.model_name ?? ""

            pickLocationLbl.text = tripDetails.pickup_address ?? ""
            destinationAddress = tripDetails.drop_address ?? ""
          //  btnETA.text = "\(tripDetails.dry_eta ?? "0") min"
            distanceLbl.text = tripDetails.estimated_distance ?? ""
            timeLbl.text = "\(tripDetails.dry_eta ?? "0")" + " mins"
            priceLbl.text = tripDetails.estimated_driver_fare ?? ""
           
            phoneNo  = tripDetails.driver_phone_no ?? ""
            print(tripDetails.status) //1 for accept trip
            //2 for start trip
            //14 for arrived at location
           
            
            
//            if tripDetails.status != 1 {
//                rideDetailsSV.isHidden = true
//                pickLocationView.isHidden = true
//            }else
            if tripDetails.status == 1{
                viewArrived.isHidden = true
                rideDetailsSV.isHidden = false
                pickLocationView.isHidden = false
                status = 1
                lblPickup.isHidden = true
//                mapView.clear()
//
//

            }else if tripDetails.status == 2{
                status = 2
                iconLocation.isHidden = true
                lblPickup.isHidden = false
                lblDestination.isHidden = false
                rideDetailsSV.isHidden = true
                pickLocationView.isHidden = false
                viewArrived.isHidden = false
                rideStatusLbl.text = "Volt ride initiated."
                descLbl.text = destinationAddress
            }else if tripDetails.status == 14{
                status = 14
                lblDestination.isHidden = true
                lblPickup.isHidden = true
                rideDetailsSV.isHidden = true
                pickLocationView.isHidden = true
                viewArrived.isHidden = false
                rideStatusLbl.text = "Volt ride initiated."
                descLbl.text = "Your Driver has Arrived. \nPlease begain trip within 5 minutes."
                descLbl.numberOfLines = 2
                descLbl.lineBreakMode = .byWordWrapping
            }else {
                status = 14
                rideDetailsSV.isHidden = true
                pickLocationView.isHidden = true
                rideDetailsSV.isHidden = false
                pickLocationView.isHidden = false
            }

            if tripDetails.status == 2 {
                status = 2
                iconLocation.isHidden = true
                lblPickup.isHidden = false
                lblDestination.isHidden = false
                rideDetailsSV.isHidden = true
                pickLocationView.isHidden = false
                viewArrived.isHidden = false
                rideStatusLbl.text = "Volt ride initiated."
                descLbl.text = destinationAddress
            } else if tripDetails.status == 14 {
                status = 14
            }
        }
    }
    
    
    func SOSApi(){
        print(ongoingTrips?[0].trip_id ?? 0)
        viewModel.SOSAPI(tripID: ongoingTrips?[0].trip_id ?? 0) {
            self.btnSOS.isHidden = true
        }
    }

    @IBAction func cancelRideBtn(_ sender: UIButton) {
            let vc = VCCancelRideVC.create()
            vc.modalPresentationStyle = .overFullScreen
            vc.onConfirm = { value in
                if value == 2 {
                    self.navigationController?.pushViewController(VCCancelReasonVC.create(), animated: true)
                }
            }
            self.navigationController?.present(vc, animated: true)
    }

    @IBAction func chatBtn(_ sender: UIButton) {
        self.viewDot.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
        vc.driverID = self.driverId
        vc.name = self.driverName
        vc.profileImg  = driverImage
        vc.tripID = self.tripId
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func callBtn(_ sender: UIButton) {
        guard let url = URL(string: "telprompt://\(phoneNo)"),
               UIApplication.shared.canOpenURL(url) else {
               return
           }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnSOSAction(_ sender: Any) {
        self.SOSApi()
    }
    
}


extension VCRideStatusVC {

    // TODO: - Pick up flow

    func driverPickUpTracking(_ location: CLLocationCoordinate2D, _ shouldFitCoordinateBounds: Bool = true) {
     //   mapView.clear()

        let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: 80, right: 30)
        mapView.padding = mapInsets
        view.layoutIfNeeded()
           
            currentMarker.map = nil
            currentMarker = GMSMarker(position: location)
            currentMarker.icon = VCImageAsset.locationMarker.asset
            currentMarker.isFlat = false
            currentMarker.position = location
            currentMarker.map = mapView
        
//            if shouldFitCoordinateBounds {
//                    let camera = GMSCameraPosition.init(latitude: location.latitude, longitude: location.longitude, zoom: 18)
//                    self.mapView.camera = camera
//            }
        }


//    func updateDriverMarker(_ location : CLLocationCoordinate2D, _ rotation: Double = 0.0, _ updatedDriverLocation: CLLocationCoordinate2D) {
//
//        driverMarker.map = nil
//        driverMarker = GMSMarker(position: updatedDriverLocation)
//        driverMarker.icon = VCImageAsset.vehicleMarker.asset
//        driverMarker.isFlat = false
//        driverMarker.position = updatedDriverLocation
//        driverMarker.map = mapView
//        driverMarker.rotation = rotation
//
//        let destinationCord = "\(location.latitude)"  + "," +  "\(location.longitude)"
//        let driverCord = "\(updatedDriverLocation.latitude)"  + "," +  "\(updatedDriverLocation.longitude)"
//
//        viewModel.getNewPolyline("\(driverCord)", "\(destinationCord)")
//        if isUpdateOnce == true{
//            isUpdateOnce = false
//            var bounds = GMSCoordinateBounds()
//                let mapCoordinates: [CLLocationCoordinate2D] = [location, updatedDriverLocation]
//                _ = mapCoordinates.map {
//                    bounds = bounds.includingCoordinate($0)
//                }
//                let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 30)
//                self.mapView.moveCamera(cameraUpdate)
//        }
//
//    }

    // TODO: - OnGoing Ride

    func tripStartedAction(driverCurrentLat: Double,currentLong: Double) {
        guard let trips = ongoingTrips else { return }
        if trips.count > 0 {
            var origin = ""
            var driverCoordinates = CLLocationCoordinate2D()
            if driverCurrentLat != 0.0{
                 origin = "\(driverCurrentLat)"  + "," +  "\(currentLong)"
                 driverCoordinates = CLLocationCoordinate2D(latitude: driverCurrentLat, longitude: currentLong)
            }else{
                 origin = "\(trips[0].latitude ?? 0.0)"  + "," +  "\( trips[0].longitude ?? 0.0)"
                 driverCoordinates = CLLocationCoordinate2D(latitude: trips[0].latitude ?? 0.0, longitude: trips[0].longitude ?? 0.0)
            }
        
            if VCUserDefaults.value(forKey: .oldDriverCoordinates) != JSON.null {
                let oldDriverCoordinates = (VCUserDefaults.value(forKey: .oldDriverCoordinates)).object as? [String:Any]
                let tripID = oldDriverCoordinates!["tripID"] as? Int ?? 0
                if tripID == (trips[0].trip_id ?? 0) {
                    let oldDriverLatitude = oldDriverCoordinates!["latitude"] as? Double ?? 0.0
                    let oldDriverLongitude = oldDriverCoordinates!["longitude"] as? Double ?? 0.0
                    origin = "\(oldDriverLatitude)" + "," + "\(oldDriverLongitude)"
                    driverCoordinates = CLLocationCoordinate2D(latitude: oldDriverLatitude, longitude: oldDriverLongitude)
                } else {
                    var newDriverCoordinates = [String:Any]()
                    if driverCurrentLat != 0.0{
                        newDriverCoordinates["latitude"] = (driverCurrentLat)
                        newDriverCoordinates["longitude"] = (currentLong)
                        newDriverCoordinates["tripID"] = trips[0].trip_id
                        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
                    }else{
                        newDriverCoordinates["latitude"] = (trips[0].latitude ?? 0.0)
                        newDriverCoordinates["longitude"] = (trips[0].longitude ?? 0.0)
                        newDriverCoordinates["tripID"] = trips[0].trip_id
                        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
                    }
                   
                   
                }
            } else {
                var newDriverCoordinates = [String:Any]()
                
                if driverCurrentLat != 0.0{
                    newDriverCoordinates["latitude"] = (driverCurrentLat)
                    newDriverCoordinates["longitude"] = (currentLong)
                    newDriverCoordinates["tripID"] = trips[0].trip_id
                    VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
                }else{
                    newDriverCoordinates["latitude"] = (trips[0].latitude ?? 0.0)
                    newDriverCoordinates["longitude"] = (trips[0].longitude ?? 0.0)
                    newDriverCoordinates["tripID"] = trips[0].trip_id
                    VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
                }
                
               
            }
            let destination = "\(trips[0].request_drop_latitude ?? 0.0)"  + "," +  "\(trips[0].request_drop_longitude ?? 0.0)"

            // Need to update in trip model from backend

            let destinationCoordinates = CLLocationCoordinate2D(latitude: trips[0].latitude ?? 0.0, longitude: trips[0].longitude ?? 0.0)
            
            
            let driverBearing = 0.0//calculateBearing(from: driverCoordinates, to: destinationCoordinates)
            if status == 1{
                updateMarkersPositionForRide(driverBearing, driverCoordinates, destinationCoordinates)
               // viewModel.getNewPolyline(origin, destination)
               
            }else{
                updateMarkersPositionForRide(driverBearing, driverCoordinates, destinationCoordinates)
               // viewModel.getNewPolyline(origin, destination)
            }
        }
    }


    func updateMarkersPositionForRide(_ driverBearing: Double, _ driverCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, _ isNewCoordinates: Bool = false) {
        if status == 0{
            if driverMarker.map == nil {
                    driverMarker = GMSMarker(position: driverCoordinates)
                    driverMarker.icon = VCImageAsset.vehicleMarker.asset
                    driverMarker.isFlat = false
                    driverMarker.map = mapView
            }else{
                driverMarker.position = driverCoordinates
            }

                // Initialize currentMarker if it's nil
                if currentMarker.map == nil {
                    currentMarker = GMSMarker(position: destinationCoordinates)
                    currentMarker.icon = VCImageAsset.locationMarker.asset
                    currentMarker.isFlat = false
                    currentMarker.map = mapView
                } else {
                    // Update currentMarker properties
                    currentMarker.position = destinationCoordinates
                }
//            driverMarker.map = nil
//            driverMarker = GMSMarker(position: driverCoordinates)
//            driverMarker.icon = VCImageAsset.vehicleMarker.asset
//            driverMarker.isFlat = false
//            driverMarker.map = mapView
//
//            currentMarker.map = nil
//            currentMarker = GMSMarker(position: destinationCoordinates)
//            currentMarker.icon = VCImageAsset.locationMarker.asset
//            currentMarker.isFlat = false
//            currentMarker.position = destinationCoordinates
//            currentMarker.map = mapView
            
            if isNewCoordinates {
                let destinationCord = "\(destinationCoordinates.latitude)"  + "," +  "\(destinationCoordinates.longitude)"
                let driverCord = "\(driverCoordinates.latitude)"  + "," +  "\(driverCoordinates.longitude)"
                
                updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
                
                self.getPolylineRoute(from: "\(driverCoordinates.latitude),\(driverCoordinates.longitude)", to: destinationCord) { (status, polyline,time,timeValue,distance,distanceValue,pointsArr) in
                    if(status){
                        self.polyLinePath = polyline
                        self.drawpolyLineForRide(polyline)
                        self.btnETA.text = timeValue
                        
                        //          self.dista.text = distance
                        //  self.showPath1(polyStr: polyline)
                        //          let param: [String:Any] = ["id":self.bookingsData._id ?? "","eta":distanceValue,"distance":time]
                        //          SocketIoManager.emitToUpdateEta(dict: param)
                    }
                }
            }
        }else if status == 1{
           // self.mapView.clear()
//            driverMarker.map = nil
//            driverMarker = GMSMarker(position: driverCoordinates)
//            driverMarker.icon = VCImageAsset.vehicleMarker.asset
//            driverMarker.isFlat = false
//            driverMarker.position = driverCoordinates
//            driverMarker.map = mapView
//          //  driverMarker.rotation = driverBearing
//
//            currentMarker.map = nil
//            currentMarker = GMSMarker(position: destinationCoordinates)
//            currentMarker.icon = VCImageAsset.locationMarker.asset
//            currentMarker.isFlat = false
//           currentMarker.position = destinationCoordinates
//            currentMarker.map = mapView
            
            if driverMarker.map == nil {
                    driverMarker = GMSMarker(position: driverCoordinates)
                    driverMarker.icon = VCImageAsset.vehicleMarker.asset
                    driverMarker.isFlat = false
                    driverMarker.map = mapView
            }else{
                driverMarker.position = driverCoordinates
            }

                // Initialize currentMarker if it's nil
                if currentMarker.map == nil {
                    currentMarker = GMSMarker(position: destinationCoordinates)
                    currentMarker.icon = VCImageAsset.locationMarker.asset
                    currentMarker.isFlat = false
                    currentMarker.map = mapView
                } else {
                    // Update currentMarker properties
                    currentMarker.position = destinationCoordinates
                }
            
            if isNewCoordinates {
                let destinationCord = "\(destinationCoordinates.latitude)"  + "," +  "\(destinationCoordinates.longitude)"
                let driverCord = "\(driverCoordinates.latitude)"  + "," +  "\(driverCoordinates.longitude)"
                
                updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
                
                self.getPolylineRoute(from: "\(driverCoordinates.latitude),\(driverCoordinates.longitude)", to: destinationCord) { (status, polyline,time,timeValue,distance,distanceValue,pointsArr) in
                    if(status){
                        self.polyLinePath = polyline
                        self.drawpolyLineForRide(polyline)
                        //          self.dista.text = distance
                      //  self.showPath1(polyStr: polyline)
                        //          let param: [String:Any] = ["id":self.bookingsData._id ?? "","eta":distanceValue,"distance":time]
                        //          SocketIoManager.emitToUpdateEta(dict: param)
                    }
                }
            }
        }else if status == 14{
            // self.mapView.clear()
//             driverMarker.map = nil
//             driverMarker = GMSMarker(position: driverCoordinates)
//             driverMarker.icon = VCImageAsset.vehicleMarker.asset
//             driverMarker.isFlat = false
//          //  driverMarker.position = driverCoordinates
//             driverMarker.map = mapView
//           //  driverMarker.rotation = driverBearing
//
//             currentMarker.map = nil
//             currentMarker = GMSMarker(position: destinationCoordinates)
//             currentMarker.icon = VCImageAsset.locationMarker.asset
//             currentMarker.isFlat = false
//             currentMarker.position = destinationCoordinates
//             currentMarker.map = mapView
            
            if driverMarker.map == nil {
                    driverMarker = GMSMarker(position: driverCoordinates)
                    driverMarker.icon = VCImageAsset.vehicleMarker.asset
                    driverMarker.isFlat = false
                    driverMarker.map = mapView
            }else{
                driverMarker.position = driverCoordinates
            }

                // Initialize currentMarker if it's nil
                if currentMarker.map == nil {
                    currentMarker = GMSMarker(position: destinationCoordinates)
                    currentMarker.icon = VCImageAsset.locationMarker.asset
                    currentMarker.isFlat = false
                    currentMarker.map = mapView
                } else {
                    // Update currentMarker properties
                    currentMarker.position = destinationCoordinates
                }
             
             if isNewCoordinates {
                 let destinationCord = "\(destinationCoordinates.latitude)"  + "," +  "\(destinationCoordinates.longitude)"
                 let driverCord = "\(driverCoordinates.latitude)"  + "," +  "\(driverCoordinates.longitude)"
                 
                 updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
                 
                 self.getPolylineRoute(from: "\(driverCoordinates.latitude),\(driverCoordinates.longitude)", to: destinationCord) { (status, polyline,time,timeValue,distance,distanceValue,pointsArr) in
                     if(status){
                         self.polyLinePath = polyline
                         self.drawpolyLineForRide(polyline)
                         //          self.dista.text = distance
                       //  self.showPath1(polyStr: polyline)
                         //          let param: [String:Any] = ["id":self.bookingsData._id ?? "","eta":distanceValue,"distance":time]
                         //          SocketIoManager.emitToUpdateEta(dict: param)
                     }
                 }
             }
         }else{
           // self.mapView.clear()
            let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: 80, right: 30)
            mapView.padding = mapInsets
            view.layoutIfNeeded()
            
             if driverMarker.map == nil {
                     driverMarker = GMSMarker(position: driverCoordinates)
                     driverMarker.icon = VCImageAsset.vehicleMarker.asset
                     driverMarker.isFlat = false
                     driverMarker.map = mapView
             }else{
                 driverMarker.position = driverCoordinates
             }

                 // Initialize currentMarker if it's nil
                 if currentMarker.map == nil {
                     currentMarker = GMSMarker(position: destinationCoordinates)
                     currentMarker.icon = VCImageAsset.locationMarker.asset
                     currentMarker.isFlat = false
                     currentMarker.map = mapView
                 } else {
                     // Update currentMarker properties
                     currentMarker.position = destinationCoordinates
                 }
            // Driver Marker
//            driverMarker.map = nil
//            driverMarker = GMSMarker(position: driverCoordinates)
//            driverMarker.icon = VCImageAsset.vehicleMarker.asset
//            driverMarker.isFlat = false
//         //   driverMarker.position = driverCoordinates
//            driverMarker.map = mapView
//          //  driverMarker.rotation = driverBearing
//            // Destination Marker
//            currentMarker.map = nil
//            currentMarker = GMSMarker(position: destinationCoordinates)
//            currentMarker.icon = VCImageAsset.locationMarker.asset
//            currentMarker.isFlat = false
//            currentMarker.position = destinationCoordinates
//            currentMarker.map = mapView
           // self.drawpolyLineForRide(self.polyLinePath)
            var bounds = GMSCoordinateBounds()
            let mapCoordinates: [CLLocationCoordinate2D] = [driverCoordinates, destinationCoordinates]
            _ = mapCoordinates.map {
                bounds = bounds.includingCoordinate($0)
            }
//            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 30)
//            self.mapView.moveCamera(cameraUpdate)
            
            if isNewCoordinates {
                let destinationCord = "\(destinationCoordinates.latitude)"  + "," +  "\(destinationCoordinates.longitude)"
                let driverCord = "\(driverCoordinates.latitude)"  + "," +  "\(driverCoordinates.longitude)"
                
                updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
                 viewModel.getNewPolyline("\(destinationCord)", "\(driverCoordinates)")
                
                self.getPolylineRoute(from: "\(driverCoordinates.latitude),\(driverCoordinates.longitude)", to: destinationCord) { (status, polyline,time,timeValue,distance,distanceValue,pointsArr) in
                    if(status){
                        self.polyLinePath = polyline
                        self.drawpolyLineForRide(polyline)
                        
                  
                        //          self.dista.text = distance
                      //  self.showPath1(polyStr: polyline)
                        //          let param: [String:Any] = ["id":self.bookingsData._id ?? "","eta":distanceValue,"distance":time]
                        //          SocketIoManager.emitToUpdateEta(dict: param)
                    }
                }
            }
        }
    }

    func drawpolyLineForRide(_ polyLinePoints: String) {
        DispatchQueue.main.async {
            guard let gmsPath = GMSPath(fromEncodedPath: polyLinePoints), gmsPath.count() > 0 else { return }
            
         
           
            self.arrPathCoordinates.removeAll()
                // Iterate over the path to get coordinates
                for index in 0..<gmsPath.count() {
                    let coordinate = gmsPath.coordinate(at: index)
                    self.arrPathCoordinates.append(coordinate)
                }
            
            // Create or update polyline
            if self.completePolyline == nil {
                self.completePolyline = GMSPolyline(path: gmsPath)
                self.completePolyline?.strokeColor = VCColors.buttonSelectedOrange.color
                self.completePolyline?.strokeWidth = 4.0
            } else {
                self.completePolyline?.path = gmsPath
            }
            
            // Set polyline on the map
            if self.travelledPolyline == nil {
                self.travelledPolyline = self.completePolyline
                self.travelledPolyline?.map = self.mapView
            }
            
            // Update bounds and animate camera
            var bounds = GMSCoordinateBounds()
            for index in 0..<gmsPath.count() {
                bounds = bounds.includingCoordinate(gmsPath.coordinate(at: index))
            }
            
            if self.isUpdateOnce {
                self.isUpdateOnce = false
                let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 24)
                self.mapView.animate(with: cameraUpdate)
            }
        }
    }

//    func updateCarMovement(_ destinationCoordinates: CLLocationCoordinate2D, _ driverCoordinates: CLLocationCoordinate2D, _ driverBearing: Double) {
//
//        let zoomLevel: Float = 16
//        let animationDuration: Float = 2.0
//        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
//
//        // Retrieve old coordinates
//        let oldCoordinates = VCUserDefaults.value(forKey: .oldDriverCoordinates)
//        var oldCoordinateLocation: CLLocationCoordinate2D?
//
//        if oldCoordinates != .null {
//            if let oldDriverCoordinates = VCUserDefaults.value(forKey: .oldDriverCoordinates).object as? [String: Any] {
//                oldCoordinateLocation = CLLocationCoordinate2D(latitude: oldDriverCoordinates["latitude"] as? Double ?? 0.0,
//                                                               longitude: oldDriverCoordinates["longitude"] as? Double ?? 0.0)
//            }
//        }
//
//        // Throttle updates: Only update if the position or bearing has changed significantly
//        if let oldLocation = oldCoordinateLocation {
//            let distanceThreshold: CLLocationDistance = 5.0 // e.g. only update if the distance moved is more than 5 meters
//            let bearingThreshold: Double = 5.0 // e.g. only update if the bearing change is more than 5 degrees
//
//            let oldLocation = CLLocation(latitude: oldLocation.latitude, longitude: oldLocation.longitude)
//            let newLocation = CLLocation(latitude: driverCoordinates.latitude, longitude: driverCoordinates.longitude)
//            let distanceMoved = oldLocation.distance(from: newLocation)
//
//            if distanceMoved < distanceThreshold && abs(driverBearing - driverMarker.rotation) < bearingThreshold {
//                return // Skip the update if movement or rotation is insignificant
//            }
//        }
//
//        // Animate marker rotation and position update
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(CFTimeInterval(animationDuration))
//
//        driverMarker.rotation = driverBearing
//        driverMarker.position = driverCoordinates
//
//        CATransaction.commit()
//
//        // Save new coordinates to avoid redundant updates
//        var newDriverCoordinates = [String: Any]()
//        newDriverCoordinates["latitude"] = driverCoordinates.latitude
//        newDriverCoordinates["longitude"] = driverCoordinates.longitude
//        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
//
//        // Update the travelled path
//        updateTravelledPath(currentLoc: driverCoordinates)
//    }

    
    
    //MARK: code commented on 23 aug 2024
    func updateCarMovement(_ destinationCoordinates: CLLocationCoordinate2D, _ driverCoordinates: CLLocationCoordinate2D, _ driverBearing: Double) {
        
        let zoomLevel : Float = 16
        let duration: Float = 2.0
        var polyline: [CLLocationCoordinate2D] = []
        
        polyline.removeAll()
        polyline.append(driverCoordinates)
        polyline.append(destinationCoordinates)
        
        
        
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        driverMarker.isFlat = true
        let oldCoordinates = VCUserDefaults.value(forKey: .oldDriverCoordinates)
        var oldCoodinateLocation : CLLocationCoordinate2D?
        
        
        if oldCoordinates != .null {
            let oldDriverCoordinates = (VCUserDefaults.value(forKey: .oldDriverCoordinates)).object as? [String:Any]
            oldCoodinateLocation = CLLocationCoordinate2D(latitude: oldDriverCoordinates!["latitude"] as? Double ?? 0.0, longitude: oldDriverCoordinates!["longitude"] as? Double ?? 0.0)
            
        }
        
        if driverMarker.map == nil {
                driverMarker = GMSMarker(position: driverCoordinates)
                driverMarker.icon = VCImageAsset.vehicleMarker.asset
                driverMarker.isFlat = true
                driverMarker.map = mapView
        } else {

            
            if let bearing = getBearingFromPolyline(polyline: self.arrPathCoordinates, at: 0) {
                print("Bearing from first to second coordinate: \(bearing) degrees")
                CATransaction.begin()
                CATransaction.setAnimationDuration(2.0) // Adjust this duration
                driverMarker.position = driverCoordinates
                driverMarker.rotation = bearing
                CATransaction.commit()
            }
        }
            
  

        var newDriverCoordinates = [String:Any]()
        newDriverCoordinates["latitude"] = (driverCoordinates.latitude )
        newDriverCoordinates["longitude"] = (driverCoordinates.longitude )
        VCUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
        updateTravelledPath(currentLoc: driverCoordinates)
    }
    
    
   
    
    func closestPointOnPolyline(to coordinate: CLLocationCoordinate2D, from path: GMSPath) -> CLLocationCoordinate2D {
        var closestCoordinate = path.coordinate(at: 0)
        var smallestDistance = CLLocationDistance(Double.greatestFiniteMagnitude)

        for index in 0..<path.count() {
            let pointCoordinate = path.coordinate(at: index)
            let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: pointCoordinate.latitude, longitude: pointCoordinate.longitude))

            if distance < smallestDistance {
                smallestDistance = distance
                closestCoordinate = pointCoordinate
            }
        }
        
        return closestCoordinate
    }


    // MARK: - Update Travelled Path
    private func updateTravelledPath(currentLoc: CLLocationCoordinate2D) {
        guard let path = travelledGmsPath else { return }
        let isCurrentLocationExistInsidePath = GMSGeometryIsLocationOnPathTolerance(currentLoc, path, true, CLLocationDistance(viewModel.distanceThresholdValue))
        if isCurrentLocationExistInsidePath { // Driver is On path
            requestedPathCoordinates = nil
            var indexToBeRemoved : Int?
            var arrDistances : [Int] = [Int]()
            var arrPathCoordinates : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
           
            for index in 0..<path.count() {
                let pathCoordinates : CLLocationCoordinate2D = path.coordinate(at: index)
                arrPathCoordinates.append(path.coordinate(at: index))
                let calculatedDistance : Int = Int(GMSGeometryDistance(currentLoc , pathCoordinates))
                arrDistances.append(calculatedDistance)
            }
            self.arrPathCoordinates = arrPathCoordinates
            if let smallestDistance = arrDistances.min(), let smallestDistanceIndex =  arrDistances.firstIndex(where: { $0 == smallestDistance }) {
                indexToBeRemoved = Int(smallestDistanceIndex)
                let newPath = GMSMutablePath()
                if let indexToBeRemoved = indexToBeRemoved { // PolyLine Exist
                    for index in indexToBeRemoved..<Int(path.count()) {
                        newPath.add(path.coordinate(at: UInt(index)))
                    }
                    
                    travelledGmsPath = newPath
                    travelledPolyline?.map = nil
                    travelledPolyline = GMSPolyline(path: newPath)
                    travelledPolyline?.strokeColor = VCColors.buttonSelectedOrange.color
                    travelledPolyline?.strokeWidth = 4.0
                    travelledPolyline?.map = mapView
//                    updateETAForTravelledPath()
                } else {
                    printDebug("Travelled coordinats not found")
                }
            }
        } else { // Request new path reuqest
            tripStartedAction(driverCurrentLat: currentLoc.latitude, currentLong: currentLoc.longitude)
            
        }
    }

    // MARK: - Calculate Car Direction Angle
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        let angle = (degree >= 0) ? degree : (360 + degree)
        return angle
    }
}


// MARK: - Floating Point
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension VCRideStatusVC{
    
    func getPolylineRoute(from source: String, to destination: String,completion:@escaping (Bool,String,Int,String,String,Int,[Any])->()){
        let googleKey = ClientModel.currentClientData.google_map_keys
        getData(url: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&sensor=false&mode=driving&key=\(googleKey!)", parameter: nil, header: nil, isLoader: true, msg: "") { (response,status) in
            if let responseDict = response as? [String:Any]{
                if let routes = responseDict["routes"] as? [Any],
                   let overPolyline = routes.first as? [String:Any],
                   let dictPolyline = overPolyline["overview_polyline"] as? [String:Any],
                   let points = dictPolyline["points"] as? String,
                   let legsArr = overPolyline["legs"] as? [Any],
                   let legfirstDict = legsArr.first as? [String:Any],
                   let duration = legfirstDict["duration"]as?[String:Any],
                   let time = duration["value"]as?Int,let timeValue = duration["text"]as?String,
                   let distanceDict = legfirstDict["distance"]as?[String:Any],let distance = distanceDict["text"]as?String,
                   
                    let distanceValue = distanceDict["value"]as?Int {
                    var arr = [[String : Any]]()
                    //self.ETA = timeValue
                    DispatchQueue.main.async {
                        self.btnETA.text = timeValue
                    }
                    
                    if let arrSteps = legfirstDict["steps"] as? [[String : Any]] {
                        arrSteps.forEach({ (dict) in
                            let dict = dict["start_location"] as? [String : Any]
                            arr.append(dict ?? [:])
                        })
                    }
                    completion(true,points,time,timeValue,distance,distanceValue,arr)
                }
                else{
                    completion(false,"",0,"","",0,[])
                }
            }
            else{
                completion(false,"",0,"","",0,[])
            }
        }
    }
    func getData(url: String, parameter: [String: String]?, header: [String: String]?, isLoader: Bool, msg: String, completion: @escaping (NSDictionary?, Int) -> ()) {
        // Placeholder for the network request (e.g., using URLSession)
        // Make sure you replace this with your actual networking code
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, 0)
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    completion(jsonObject, 200)
                } else {
                    completion(nil, 0)
                }
            } catch {
                completion(nil, 0)
            }
        }.resume()
    }
    
    func closestPolylinePointIndex(to currentPosition: CLLocationCoordinate2D, on polyline: [CLLocationCoordinate2D]) -> Int {
        var closestIndex = 0
           var smallestDistance = Double.greatestFiniteMagnitude

           for (index, point) in polyline.enumerated() {
               let distance = GMSGeometryDistance(currentPosition, point)
               if distance < smallestDistance {
                   smallestDistance = distance
                   closestIndex = index
               }
           }

           // Ensure we return the next point in the polyline
           return min(closestIndex + 1, polyline.count - 1)
    }
    


    func calculateBearing(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = start.latitude.degreesToRadians
        let lon1 = start.longitude.degreesToRadians
        let lat2 = end.latitude.degreesToRadians
        let lon2 = end.longitude.degreesToRadians
        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        // Convert bearing from radians to degrees and normalize to 0-360 range
        let bearing = radiansBearing.radiansToDegrees
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }

    func getNextPolylineCoordinate(currentCoordinates: CLLocationCoordinate2D, polylineCoordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        // Find the next coordinate in the polyline relative to the current coordinates.
        // Implement a more sophisticated approach if needed.
        let closestPoint = polylineCoordinates.min {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: CLLocation(latitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude)) <
            CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: CLLocation(latitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude))
        }
        return closestPoint
    }

    func updateCarMovementAlongPolyline(currentCoordinates: CLLocationCoordinate2D, polylineCoordinates: [CLLocationCoordinate2D], driverMarker: GMSMarker) {
        guard let nextCoordinate = getNextPolylineCoordinate(currentCoordinates: currentCoordinates, polylineCoordinates: polylineCoordinates) else {
            return
        }

        let bearing = calculateBearing(from: currentCoordinates, to: nextCoordinate)

        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        driverMarker.rotation = bearing
        driverMarker.position = currentCoordinates
        CATransaction.commit()
    }
    
    func bearingsAlongPolyline(polyline: [CLLocationCoordinate2D]) -> [CLLocationDirection] {
        var bearings: [CLLocationDirection] = []

        for i in 0..<polyline.count-1 {
            let start = polyline[i]
            let end = polyline[i + 1]
            let bearing = calculateBearing(from: start, to: end)
            bearings.append(bearing)
        }

        return bearings
    }
    
}
extension CLLocationDegrees {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
   
}
extension Double {
    var degreesToRadians: Double { return self * .pi / 180.0 }
    var radiansToDegrees: Double { return self * 180.0 / .pi }
}
extension VCRideStatusVC{
    func getBearingFromPolyline(polyline: [CLLocationCoordinate2D], at index: Int) -> Double? {
        guard polyline.count > index + 1 else {
            print("Not enough points in polyline to calculate bearing.")
            return nil
        }
        
        let startPoint = polyline[index]
        let endPoint = polyline[index + 1]
        
        return calculateBearing(from: startPoint, to: endPoint)
    }
    
    func bearingsFromPolyline(encodedPath: String) -> [Double] {
        // Decode the encoded polyline string into a GMSPath
        guard let path = GMSPath(fromEncodedPath: encodedPath) else {
            print("Error: Could not decode polyline.")
            return []
        }
        
        // Array to store bearings
        var bearings: [Double] = []
        
        // Iterate over the path to calculate bearings between consecutive coordinates
        for index in 0..<path.count() - 1 {
            let startCoordinate = path.coordinate(at: index)
            let endCoordinate = path.coordinate(at: index + 1)
            
            let bearing = calculateBearing(from: startCoordinate, to: endCoordinate)
            bearings.append(bearing)
        }
        
        return bearings
    }
}
