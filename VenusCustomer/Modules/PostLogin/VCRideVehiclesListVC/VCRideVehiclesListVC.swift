//
//  VCRideVehiclesListVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit
import GoogleMaps
class VCRideVehiclesListVC: VCBaseVC {

    // MARK: -> Variables
    @IBOutlet weak var rideTableView: UITableView!
    @IBOutlet weak var baseView: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var rideIconView: UIView!
    @IBOutlet weak var rideiconBtn: UIButton!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    // MARK: -> Variables
    var initialPosition: CGPoint = .zero
    var onConfirm:((Int,Regions,etaData,operator_availablityy, String) -> Void)?
    var regions: [Regions]?
    var selectedRegions: Regions?
    var pickUpPlace : GooglePlacesModel?
    var pickUpLocation : GeometryFromPlaceID?
    var dropPlace : GooglePlacesModel?
    var dropLocation : GeometryFromPlaceID?
    var customerETA : etaData?
    var apiTimer: Timer?
    var isSechdule = false
    var objOperator_availablity : operator_availablityy?
   // var loadedPackageDetails: [PackageDetail]?
    private var viewModel = VCRideVehiclesListViewModel()
    private var viewModelPoly = VCHomeViewModel()
    private var viewModelFind = VCScheduleViewModel()
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()
    private var popupOffset = CGFloat()
    var is_for_rental = false
    //  To create ViewModel
    static func create() -> VCRideVehiclesListVC {
        let obj = VCRideVehiclesListVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

    override func initialSetup() {
       
        setUpUI()
        if promoTitle != ""{
            let confettiView = ConfettiView(frame: view.bounds)
            view.addSubview(confettiView)
        }
      
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.baseView.addGestureRecognizer(panGesture)
        
        viewModelPoly.polylineCallBack = { polyline in
            self.showPath(polyStr: polyline)
        }
        
        lblTitle.text = promoTitle
      
       
    }

    override func viewDidLayoutSubviews() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        baseView.roundCorner([.topLeft, .topRight], radius: 32)
        baseView.addShadowView()
        rideIconView.addShadowView(radius: 3.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAPITimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Stop the timer when the view disappears
           stopAPITimer()
       }
    
    func startAPITimer() {
           // Make sure to stop any previous timer before starting a new one
           stopAPITimer()

           // Schedule the timer to hit the API every 10 seconds
           apiTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(hitAPI), userInfo: nil, repeats: true)
        
        print(apiTimer as Any)
       }
    
    func stopAPITimer() {
            // Invalidate and nullify the timer
            apiTimer?.invalidate()
            apiTimer = nil
        }
    @objc func hitAPI() {
        self.viewModelFind.findDriver(self.pickUpLocation, self.dropLocation, typeID: objOperator_availablity?.id ?? 0)
    }
    
    deinit {
            // Ensure the timer is invalidated when the view controller is deallocated
            stopAPITimer()
        }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        switch gesture.state {
        case .began:

            guard let region = regions else {return}
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlUp, animations: {
                self.rideTableView.isScrollEnabled = true
                self.heightTableView.constant = CGFloat(110 * (region.count > 4 ? 4 : region.count))
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.viewDidLayoutSubviews()
            }, completion: nil)
            
        case .changed:
            
            if translation.y > 0 {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlDown, animations: {
                    self.rideTableView.isScrollEnabled = false
                    self.heightTableView.constant = CGFloat(110 * (1 > 4 ? 4 : 1))
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        case .ended, .cancelled:
            // gesture.setTranslation(.zero, in: self.baseView)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    

    
    func setUpUI() {
        rideTableView.delegate = self
        rideTableView.dataSource = self
        rideTableView.register(UINib(nibName: "VCRideVehicleCell", bundle: nil), forCellReuseIdentifier: "VCRideVehicleCell")
        guard let region = regions else {return}
        heightTableView.constant = CGFloat(110 * (region.count > 4 ? 4 : region.count))
        
        let pickupLocation = CLLocationCoordinate2D(latitude: pickUpLocation?.location?.lat ?? 0.0, longitude: pickUpLocation?.location?.lng ?? 0.0)
        
        let destination = CLLocationCoordinate2D(latitude: dropLocation?.location?.lat ?? 0.0, longitude:  dropLocation?.location?.lng ?? 0.0)
        
        showMarker(Source: pickupLocation , Destination: destination)
        
    }
    
    


    @IBAction func backBtn(_ sender: UIButton) {
        stopAPITimer()
        self.navigationController?.popViewController(animated: true)
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

    @IBAction func btnSelectionType(_ sender: UIButton) {

        if selectedRegions == nil {
            SKToast.show(withMessage: "Please select vehicle type.")
        } else {
            stopAPITimer()
            self.dismiss(animated: true) {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlDown, animations: {
                    self.rideTableView.isScrollEnabled = false
                    self.heightTableView.constant = CGFloat(110 * (1 > 4 ? 4 : 1))
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                self.onConfirm?(1, self.selectedRegions!, self.customerETA!, self.objOperator_availablity!,"")
            }
//            self.requestRide()
        }
//
//        let vc = VCCancelPopUpVC.create()
//        vc.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(vc, animated: true)
    }

    func removeFromParentVC() {
//        self.tabBarController?.tabBar.isHidden = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension VCRideVehiclesListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let regionsArr = regions else { return 0 }
//        if regionsArr.count > 0 {
//            return 1
//        }
        return regionsArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCRideVehicleCell", for: indexPath) as! VCRideVehicleCell
        cell.customerETA = self.customerETA
        if let regionarr = regions {
            cell.objOperator_availablity = self.objOperator_availablity
            cell.setUpVehicleUI(regionarr[indexPath.row], (regionarr[indexPath.row].region_id  == self.selectedRegions?.region_id ?? -1),isSchedule: self.isSechdule)
        }
      
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let region = self.regions else { return }
        if let _ = regions?[indexPath.row].eta {
            selectedRegions = region[indexPath.row]
            self.rideTableView.reloadData()
        } else {
           if self.isSechdule == true
            {
               selectedRegions = region[indexPath.row]
               self.rideTableView.reloadData()

}
        }
        
    }
}
