//
//  VCCancelPopUpVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit
import GoogleMaps
class VCCancelPopUpVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var baseVC: UIView!
    @IBOutlet weak var btnCancel: VDButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet  var progressView: UIProgressView!
    
    private var viewModelPoly = VCHomeViewModel()
    var onConfirm:((Int) -> Void)?
    var rideRequestDetails: RequestRideData?
    var viewModel = VCHomeViewModel()
    var progress: Float = 0.0
    var timer: Timer?
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()
    var status : Int?
    var objOngoingTripModel : OngoingTripModel?
    var drop_location_address = ""
    //  To create ViewModel
    static func create() -> VCCancelPopUpVC {
        let obj = VCCancelPopUpVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

    override func initialSetup() {
        startProgressTimer()
        addObservers()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let slideGesture = UISwipeGestureRecognizer(target: self, action: #selector(slideToCancel(_:)))
        btnCancel.addGestureRecognizer(slideGesture)

        viewModel.callBackForOngoingRides = { trips in
            if trips.count > 0 {
                VCRouter.goToOngoingRide(trips)
            } else {
                VCRouter.goToSaveUserVC()
            }
        }
        viewModelPoly.polylineCallBack = { polyline in
            self.showPath(polyStr: polyline)
        }
        
        if status == 0{
            mapView.isHidden = false
            let source = CLLocationCoordinate2D(latitude: objOngoingTripModel?.request_drop_latitude ?? 0.0, longitude: objOngoingTripModel?.request_drop_longitude ?? 0.0)
            let destination = CLLocationCoordinate2D(latitude: objOngoingTripModel?.latitude ?? 0.0, longitude: objOngoingTripModel?.longitude ?? 0.0)
            showMarker(Source: source, Destination: destination)
            
        }else{
            mapView.isHidden = true
        }
       
       //showMarker(Source: rideRequestDetails?.pickup_location_address, Destination: rideRequestDetails?.drop_location_address ?? "")

       
    }
    
    private func startProgressTimer() {
           // Invalidate any existing timer
           timer?.invalidate()

           // Create a new timer that fires every 1 second
           timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
       }
    
    @objc private func updateProgress() {
           // Increment progress
        progress += 0.1
        progressView.progress = progress
           // Ensure progress does not exceed 1.0
           if progress > 1.0 {
               progress = 1.0
               progress = 0.0
                progressView.progress = progress
           }

           // Update the progress view
           progressView.setProgress(progress, animated: true)
       }

    override func viewDidLayoutSubviews() {
        baseVC.roundCorner([.topLeft, .topRight], radius: 32)
    }

    @objc func slideToCancel(_ gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true) {
            self.onConfirm?(1)
        }
    }

    @IBAction func btnCancel(_ sender: UIButton) {

    }

    @IBAction func refreshBtn(_ sender: VDButton) {
        viewModel.fetchOngoingRide(completion: {
            if self.viewModel.ongoingTrips.count > 0 {
                VCRouter.goToOngoingRide(self.viewModel.ongoingTrips)
            } else {
                VCRouter.goToSaveUserVC()
            }
        })
    }
    
}

extension VCCancelPopUpVC {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRideStatus(_:)), name: .updateRideStatus, object: nil)
    }

    @objc func refreshRideStatus(_ notification: Notification) {
        viewModel.fetchOngoingRide(completion: {})
    }
}
extension VCCancelPopUpVC{
    
    func convertStringToCoordinate(_ coordinateString: String) -> CLLocationCoordinate2D? {
        let components = coordinateString.split(separator: ",")
        if components.count == 2 {
            if let latitude = CLLocationDegrees(components[0].trimmingCharacters(in: .whitespaces)),
               let longitude = CLLocationDegrees(components[1].trimmingCharacters(in: .whitespaces)) {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }

    
    func showMarker(Source : CLLocationCoordinate2D, Destination : CLLocationCoordinate2D){
        
        let driverCord = "\(Source.latitude)"  + "," +  "\(Source.longitude)"
        let locCord = "\(Destination.latitude)"  + "," +  "\(Destination.longitude)"
        viewModelPoly.getNewPolyline("\(locCord)", "\(driverCord)")
        
        var bounds = GMSCoordinateBounds()
        driverMarker.map = nil
        driverMarker = GMSMarker(position: Source)
        driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
        driverMarker.isFlat = false
        driverMarker.position = Source
        driverMarker.map = mapView
        
        bounds = bounds.includingCoordinate(driverMarker.position)
        
        currentMarker.map = nil
        currentMarker = GMSMarker(position: Destination)
        currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
        currentMarker.isFlat = false
        currentMarker.position = Destination
        currentMarker.map = mapView
        
        
        currentMarker.map = self.mapView
        
        //var bounds = GMSCoordinateBounds()
        let mapCoordinates: [CLLocationCoordinate2D] = [Source, Destination]
        _ = mapCoordinates.map {
            bounds = bounds.includingCoordinate($0)
        }
        let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 50)
        self.mapView.moveCamera(cameraUpdate)
        
    }
    
    func showPath(polyStr :String){ //FROM API
        self.mapView.clear()
        guard let path = GMSMutablePath(fromEncodedPath: polyStr) else {return }
        let markerPostion = path.coordinate(at: 0)
        let endPos = path.coordinate(at: path.count() - 1)
        self.addMarker(source: markerPostion, destination: endPos)
      
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 4.0
        polyLine.strokeColor = VCColors.buttonSelectedOrange.color
        polyLine.map = self.mapView
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: UInt(index)))
        }
       // let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30))
        //if isUpdateOnce == true{
          //  isUpdateOnce = false
            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 75))
       // }
    }
    
    func addMarker(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
        driverMarker = GMSMarker(position: destination)
        driverMarker.icon = VCImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)

        driverMarker.position = destination
        driverMarker.map = mapView
    
        currentMarker = GMSMarker(position: source)
        currentMarker.icon = VCImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)

        currentMarker.position = source
        currentMarker.map = mapView
    }

}
