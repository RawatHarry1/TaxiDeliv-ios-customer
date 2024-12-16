//
//  VCScheduleVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit
import GoogleMaps
import FloatingPanel
class VCScheduleVC: VCBaseVC {

    // MARK: -> Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewAddressTblView: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet var viewcontent: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var rideDetailView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var pickUpTF: UITextField!
    @IBOutlet weak var dropTF: UITextField!
    @IBOutlet weak var tblViewAddress: UITableView!
    
    // MARK: -> Variables
    private var viewModel = VCScheduleViewModel()
    private var screenType = 0
    var selectedLocationFromPlaceID : GeometryFromPlaceID?
    var onConfirm:((FindDriverData,GeometryFromPlaceID,String,operator_availablityy) -> Void)?
    var onPickUpClicked:((Int, String,GeometryFromPlaceID) -> Void)?
    var onDropClicked:((Int, String) -> Void)?
    var openAddAddress:((Int) -> Void)?
    var cancelScheduleRideAction:((Bool) -> Void)?

    var pickUpPlace : GooglePlacesModel?
    var pickUpLocation : GeometryFromPlaceID?
    var dropLocation : GeometryFromPlaceID?
    var objAddressViewModel: AddressViewModal = AddressViewModal()
    var dropPlace : GooglePlacesModel?
   
    var lat = 0.0
    var long = 0.0
    var objGetdata : GetAddData?
    var utcDate = ""
    var isSechdule = false
    var objOperator_availablity : operator_availablityy?
    
    var setPickUpLocation: String = "" {
        didSet {
            self.pickUpTF.text = setPickUpLocation
        }
    }

    var setDropLocation: String = "" {
        didSet {
            self.dropTF.text = setDropLocation
        }
    }

    //  To create ViewModel
    static func create(_ type: Int) -> VCScheduleVC {
        let obj = VCScheduleVC.instantiate(fromAppStoryboard: .ride)
        obj.screenType = type
        return obj
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange(notification:)), name: .refresh, object: nil)
       
    }
    
    @objc func handleTextDidChange(notification: Notification) {
        
        getAddressApi()
        
    }
    override func initialSetup() {
        getAddressApi()
        objAddressViewModel.callBackForGetAddress = { obj in
            self.objGetdata = obj
            self.tblViewAddress.reloadData()
        }
        
        setUpUI()
        callBacks()
        tblViewAddress.rowHeight = 90
        tblViewAddress.delegate = self
        tblViewAddress.dataSource = self
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
        if lat != 0{
            
            //   self.getAddressFromLatLon(pdblLatitude: "\(lat)", withLongitude: "\(long)")
            getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
                if let address = address {
                    DispatchQueue.main.async {
                        self.lat = Double(lat)
                        self.long = Double(long)
                        let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(long), lat: Double(lat))
                        let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
                        self.selectedLocationFromPlaceID = placeId
                        self.pickUpLocation = placeId
                        self.pickUpTF.text = address
                    }
                    print("Detailed Address: \(address)")
                } else {
                    print("Address not found.")
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        baseView.addShadowView()
        scheduleView.addShadowView()
        baseView.roundCorner([.topLeft, .topRight], radius: 32)
        dashedView.addDashedSmallBorder()
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.addButton.isUserInteractionEnabled = true
    }
    
 
    func getAddressApi(){
        var attribute = [String : Any]()
        attribute = [:]
       
        objAddressViewModel.getAddressApi(attribute, true)
    }
    
    func setUpUI() {
        if screenType == 0 {
            titleLabel.isHidden = true
            scheduleView.isHidden = true
            addButton.setTitle("Confirm", for: .normal)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelScheduleRide(_:)))
        tapGesture.numberOfTapsRequired = 1
        viewcontent.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.baseView.addGestureRecognizer(panGesture)
    }
    
    func callBacks() {
        self.viewModel.findDriverSuccessCallBack = { object in
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: self.long, lat: self.lat)
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.onConfirm?(object,placeId!,self.pickUpTF.text ?? "",self.objOperator_availablity!)
//            self.removeFromParentVC()
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.cancelScheduleRideAction?(true)
            self.removeFromParentVC()
        })
       // let translation = gesture.translation(in: self.view)
        
//        switch gesture.state {
//        case .began:
//
//
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlUp, animations: {
//                self.scrollView.isScrollEnabled = true
//                if self.objGetdata?.saved_addresses?.count ?? 0 == 0 {
//                    self.viewAddressTblView.isHidden = true
//                    self.viewHeightConstant.constant = 450
//                    self.baseView.setNeedsDisplay()
//                    self.baseView.layoutIfNeeded()
//                }else{
//                    self.setUpUI()
//                    self.tblViewAddress.rowHeight = 90
//                    self.viewAddressTblView.isHidden = false
//                    print(self.viewHeightConstant.constant)
//                    self.viewHeightConstant.constant = 650
//                    self.baseView.setNeedsDisplay()
//                    self.baseView.layoutIfNeeded()
//                }
//            }, completion: nil)
//
//        case .changed:
//
//            if translation.y > 0 {
//
//                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlDown, animations: {
//                    self.scrollView.isScrollEnabled = false
//                    self.viewHeightConstant.constant = 260
//
//
//                    gesture.setTranslation(CGPoint.zero, in: self.view)
//                    self.baseView.setNeedsDisplay()
//                    self.baseView.layoutIfNeeded()
//                }, completion: nil)
//            }
//        case .ended, .cancelled:
//            // gesture.setTranslation(.zero, in: self.baseView)
//            UIView.animate(withDuration: 0.3, animations: {
//
//                self.view.layoutIfNeeded()
//            })
//        default:
//            break
//        }
    }
    
    func removeFromParentVC() {
        self.tabBarController?.tabBar.isHidden = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @objc func cancelScheduleRide(_ button: UIButton) {

    }
    
    func removeAddressApi(id: String){
        viewModel.removeAddress(addressID: id) {
            self.getAddressApi()
        }
    }

    @IBAction func addBtn(_ sender: UIButton) {
        self.addButton.isUserInteractionEnabled = false
        if (pickUpTF.text ?? "") == "" {
            SKToast.show(withMessage: "Please enter pickup location.")
            return
        } else if (dropTF.text ?? "") == "" {
            SKToast.show(withMessage: "Please enter drop location.")
            return
        }
        
       // if self.objOperator_availablity?.id == 1{
            self.viewModel.findDriver(self.pickUpLocation, self.dropLocation, typeID: self.objOperator_availablity?.id ?? 0)
       // }else{
           
       // }
        
       
       //
//        self.dismiss(animated: true) {
//            self.onConfirm?(self.screenType)
//        }
    }

    @IBAction func addAddressBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            self.openAddAddress?(self.screenType)
        }
    }

    @IBAction func pickupBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: self.long, lat: self.lat)
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.onPickUpClicked?(self.screenType, "\(self.pickUpTF.text ?? "")", placeId!)
        }
    }

    @IBAction func dropBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onDropClicked?(self.screenType, "\(self.pickUpTF.text ?? "")")
        }
    }

    @IBAction func hideViewBtn(_ sender: UIButton) {
        cancelScheduleRideAction?(true)
        removeFromParentVC()
    }
}

extension VCScheduleVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if objGetdata?.saved_addresses?.count ?? 0 == 0 {
            viewAddressTblView.isHidden = true
            viewHeightConstant.constant = 450
        }else{
            setUpUI()
            tblViewAddress.rowHeight = 90
            viewAddressTblView.isHidden = false
            print(viewHeightConstant.constant)
            viewHeightConstant.constant = 650
            baseView.setNeedsDisplay()
            baseView.layoutIfNeeded()
        }
        return objGetdata?.saved_addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTblCell", for: indexPath) as! AddressTblCell
        let obj = objGetdata?.saved_addresses?[indexPath.row]
        cell.lblTitle.text = obj?.type ?? ""
        cell.lblAddress.text = "\(obj?.addr ?? ""), \(obj?.nick_name ?? "")"
        
        cell.didPressCell = {
            
            self.lat = Double(obj?.lat ?? 0.0)
            self.long = Double(obj?.lng ?? 0.0)
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(obj?.lng ?? 0.0), lat: Double(obj?.lat ?? 0.0))
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.pickUpLocation = placeId
            self.pickUpTF.text = obj?.addr ?? ""
            print(obj?.addr ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //            let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
        //                self.editItem(at: indexPath)
        //                completionHandler(true)
        //            }
        //            editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteItem(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func editItem(at indexPath: IndexPath) {
        // Add your edit item logic here
        print("Editing item at \(indexPath.row)")
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let obj = objGetdata?.saved_addresses?[indexPath.row]
        removeAddressApi(id: "\(obj?.id ?? 0)")
        //tblViewAddress.deleteRows(at: [indexPath], with: .automatic)
        
    }
}

extension VCScheduleVC{
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
       
       
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
       
        
           // someGeometryFromPlaceIDVariable = geometry
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil){
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks
            
            if pm?.count ?? 0 > 0 {
                let pm = placemarks![0]
                
                print(pm.country ?? "")
                print(pm.locality ?? "")
                print(pm.subLocality ?? "")
                print(pm.thoroughfare ?? "")
                print(pm.postalCode ?? "")
                print(pm.subThoroughfare ?? "")
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.lat = Double(pdblLatitude) ?? 0
                self.long = Double(pdblLongitude) ?? 0
                let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(pdblLongitude), lat: Double(pdblLatitude))
                let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
                self.selectedLocationFromPlaceID = placeId
                self.pickUpLocation = placeId
                self.pickUpTF.text = addressString
                print(addressString)
            }
        })
    }
    
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
