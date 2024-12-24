//
//  VCPickUpDropVC.swift
//  VenusCustomer
//
//  Created by Amit on 14/07/23.
//

import UIKit
import GooglePlaces
import GoogleMaps

class VCPickUpDropVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tfPickUp: UITextField!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMap: GMSMapView!

    @IBOutlet weak var lblNotFound: UILabel!
    var markerUser : GMSMarker?
    var centerMapCoordinate:CLLocationCoordinate2D!
    var screenType = 0
    var googleMapsViewModel = GoogleMapsViewModel()
    var selectedSearchedPlace: GooglePlacesModel?
    var selectedLocationFromPlaceID : GeometryFromPlaceID?
    var updateOnce = false
    var selectedPlaceDetails: ((String, GeometryFromPlaceID) -> ())?
    var isAddressFetchingInProgress = false
    //  To create ViewModel
    static func create(_ type: Int) -> VCPickUpDropVC {
        let obj = VCPickUpDropVC.instantiate(fromAppStoryboard: .ride)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        setupUIElements()
        setUpCallBacks()
        viewMap.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        viewMap.addGestureRecognizer(tap)
    }
    
    @IBAction func btnCross(_ sender: Any) {
        tfPickUp.text = ""
    }
    
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
        if tfPickUp.text == ""{
           // if screenType != 1 {
                if lat != 0{
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                  //  getAddressFromLatLon(pdblLatitude: "\(lat)", withLongitude: "\(long)")
                    
                    getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
                        if let address = address {
                            DispatchQueue.main.async {
                                let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(long), lat: Double(lat))
                                let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
                                self.selectedLocationFromPlaceID = placeId
                                self.locationsTableView.reloadData()
                                if self.screenType != 1{
                                    self.tfPickUp.text = address
                                }
                            }
                                print("Detailed Address: \(address)")
                            } else {
                                print("Address not found.")
                            }
                        
                    }
                    self.addMarkerToPosition(coordinates)
              //  }
            }else{
               
                   
                    screenType = 1
                    locationManager = CLLocationManager()
                    locationManager.delegate = self;
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    locationManager.startUpdatingLocation()
                
            }
        }
        if screenType == 100{
            if lat != 0{
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
                    if let address = address {
                        DispatchQueue.main.async {
                            print("Detailed Address: \(address)")
                            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(long), lat: Double(lat))
                            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
                            self.selectedLocationFromPlaceID = placeId
                            self.locationsTableView.reloadData()
                            if self.screenType != 1{
                                self.tfPickUp.text = address
                            }
                        }
                    } else {
                        print("Address not found.")
                    }
                }
               // getAddressFromLatLon(pdblLatitude: "\(lat)", withLongitude: "\(long)")
                self.addMarkerToPosition(coordinates)
            }
        }

      
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
 
    
    func setupUIElements() {
        locationsTableView.register(UINib(nibName: "VCLocationCell", bundle: nil), forCellReuseIdentifier: "VCLocationCell")
        
        if screenType == 1 {
            titleLbl.text = "DROP OFF"
            tfPickUp.placeholder = "Where to?"
        } else {
            dotView.backgroundColor = VCColors.buttonSelectedOrange.color
        }
        tfPickUp.delegate = self
        tfPickUp.addTarget(self, action: #selector(valueDidChange(_:)), for: .editingChanged)
    }
    
    func setUpCallBacks() {
        googleMapsViewModel.callBackForGooglePlaceSearch = {
            self.tableViewHeight.constant = CGFloat((self.googleMapsViewModel.searchedPlaces.count) * 60)
            self.locationsTableView.reloadData()
        }

        googleMapsViewModel.callBackForGeometryFromPlaceID = { location in
            self.selectedLocationFromPlaceID = location
            self.googleMapsViewModel.removeSearchedLocations()
            self.locationsTableView.reloadData()
            guard let selectedPlace = self.selectedSearchedPlace else {return}
            self.tfPickUp.text = selectedPlace.description ?? ""

            // Move map from here
            if let lat = location.location?.lat , let lng = location.location?.lng {
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.addMarkerToPosition(coordinates)
            }
        }
    }
    
    @objc func valueDidChange(_ textField: UITextField) {
        var value = textField.text ?? ""
        if value.count < 2 {
            value = ""
        }
        googleMapsViewModel.getGooglePlacesFromApi(value: value)
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnGetCurrentLoc(_ sender: Any) {
        self.view.endEditing(true)
        screenType = 100
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    

    @IBAction func btnConfrim(_ sender: Any) {
        guard let selectedLocation = self.selectedLocationFromPlaceID else {
            SKToast.show(withMessage: "Please select location to proceed.")
            return
        }
        self.dismiss(animated: true) {
            self.selectedPlaceDetails?(self.tfPickUp.text ?? "",selectedLocation)
        }
    }
}

// MARK: - TableView Delegates, TableViewDataSources
extension VCPickUpDropVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchedPlaces = googleMapsViewModel.searchedPlaces else { return 0}
        
        return searchedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCLocationCell", for: indexPath) as! VCLocationCell
        cell.setUpTitle(googleMapsViewModel.searchedPlaces[indexPath.row])
       //isAddressFetchingInProgress = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objc = googleMapsViewModel.searchedPlaces[indexPath.row]
        selectedSearchedPlace = objc
        googleMapsViewModel.getGooglePlacesDetailsFromApi(placeID: objc.place_id ?? "")
    }
}

extension VCPickUpDropVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tfPickUp.endEditing(true)
        self.view.endEditing(true)
        return true
    }
}


extension VCPickUpDropVC:GMSMapViewDelegate {
    
    func initializeMap() {
        viewMap.clear()
    }
    
    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
        viewMap.clear()
//        markerUser?.map = nil
//
//        markerUser = GMSMarker(position: coordinates)
//        markerUser?.icon = VCImageAsset.locationMarker.asset
//      //  markerUser?.isFlat = false
//        markerUser?.position = coordinates
//        markerUser?.isDraggable = true
//        markerUser?.map = viewMap
        let camera = GMSCameraPosition.init(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
       
//        self.viewMap.camera = camera
        self.viewMap.animate(to: camera)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isAddressFetchingInProgress == false{
            isAddressFetchingInProgress = true
            return
        }
        
        let center = mapView.projection.coordinate(for: mapView.center)
        print("Center coordinate: \(position.target.latitude), \(position.target.longitude)")
        self.screenType = 10
        self.lblNotFound.isHidden = true
       // self.getAddressFromLatLon(pdblLatitude: "\(position.target.latitude)", withLongitude: "\(position.target.longitude)")
        getDetailedAddressFromLatLon(latitude: position.target.latitude, longitude: position.target.longitude) { address in
            if let address = address {
                DispatchQueue.main.async {
                    let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(position.target.longitude), lat: Double(position.target.latitude))
                    let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
                    self.selectedLocationFromPlaceID = placeId
                    self.locationsTableView.reloadData()
                    if self.screenType != 1{
                        self.tfPickUp.text = address
                    }
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
        
    }
    

    

    
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        let position = marker.position
//        print("Marker dragged to position: \(position.latitude), \(position.longitude)")
//       // getCurrentLocation(lat: position.latitude, long: position.longitude)
//        self.screenType = 10
//        lblNotFound.isHidden = true
//        getAddressFromLatLon(pdblLatitude: "\(position.latitude)", withLongitude: "\(position.longitude)")
//
//    }
}
extension VCPickUpDropVC{
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
               // completion(nil)
                return
            }

            guard let placemark = placemarks?.first else {
                print("No placemark found")
               // completion(nil)
                return
            }

            var addressString = ""

            // Attempt to get building name or landmark
            if let name = placemark.name {
                addressString += name + ", "
            }

            // Attempt to get detailed address components
            if let subThoroughfare = placemark.subThoroughfare {
                addressString += subThoroughfare + " "
            }
            if let thoroughfare = placemark.thoroughfare {
                addressString += thoroughfare + ", "
            }
            if let subLocality = placemark.subLocality {
                addressString += subLocality + ", "
            }
            if let locality = placemark.locality {
                addressString += locality + ", "
            }
            if let administrativeArea = placemark.administrativeArea {
                addressString += administrativeArea + ", "
            }
            if let postalCode = placemark.postalCode {
                addressString += postalCode + ", "
            }
            if let country = placemark.country {
                addressString += country
            }

            // Remove the trailing comma and space if they exist
            addressString = addressString.trimmingCharacters(in: .whitespacesAndNewlines)
            if addressString.hasSuffix(",") {
                addressString.removeLast()
            }
            
            // Do something with the formatted address
            print("Formatted Address: \(addressString)")
            
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(pdblLongitude), lat: Double(pdblLatitude))
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.locationsTableView.reloadData()
            if self.screenType != 1{
                self.tfPickUp.text = addressString.description
            }
            
            
            //  self.pickUpTF.text = addressString
            print(addressString)
        }
    }
    
   

    func getDetailedAddressFromLatLon(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let apiKey = googleAPIKey
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
