//
//  VCAddressVC.swift
//  VenusCustomer
//
//  Created by Amit on 14/07/23.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces


class VCAddressVC: VCBaseVC, UITextFieldDelegate,addressAdded {
    
    

    // MARK: -> Outlets
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationsTableView: UITableView!
    var markerUser : GMSMarker?
    let placesClient = GMSPlacesClient.shared()
    var googleMapsViewModel = GoogleMapsViewModel()
    var selectedSearchedPlace: GooglePlacesModel?
    var selectedLocationFromPlaceID : GeometryFromPlaceID?
    var selectedPlaceDetails: ((String, GeometryFromPlaceID) -> ())?
    var addAddressCallBack: ((String) -> Void)?
    
    var lat = 0.0
    var long = 0.0
    var placeId = ""
    var address = ""
    var nickName = ""
    var isAddressFetchingInProgress = false
    
    static func create() -> VCAddressVC {
        let obj = VCAddressVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            //getAddressFromLatLon(pdblLatitude: "\(lat)", withLongitude: "\(long)")
        
        getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
            if let address = address {
                DispatchQueue.main.async {
                    self.tfAddress.text = address
                    self.fetchPlaceID(for: address)
                    self.lat = Double(lat)
                    self.long = Double(long)
                    self.address = address
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }

            self.addMarkerToPosition(coordinates)
    }

    override func initialSetup() {
        viewMap.delegate = self
        setUpCallBacks()
        setupUIElements()
        
       
    }

    override func viewDidLayoutSubviews() {
        addressView.addShadowView()
    }
    
    func setupUIElements() {
        locationsTableView.register(UINib(nibName: "VCLocationCell", bundle: nil), forCellReuseIdentifier: "VCLocationCell")
        
//        if screenType == 1 {
//            titleLbl.text = "DROP OFF"
//            tfPickUp.placeholder = "Where to?"
//        } else {
//            dotView.backgroundColor = VCColors.buttonSelectedOrange.color
//        }
        tfAddress.delegate = self
        tfAddress.addTarget(self, action: #selector(valueDidChange(_:)), for: .editingChanged)
    }
    
    func dismiss() {
        self.dismiss(animated: true,completion: {
            self.addAddressCallBack?("Success")
        })
       
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func btnConfrim(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        vc.address = tfAddress.text ?? ""
        vc.nickName = self.nickName
        vc.lat = self.lat
        vc.long = self.long
        vc.placeId = self.placeId
        vc.delegate = self
        self.present(vc, animated: true)
       // self.addAddressApi()
       // self.dismiss(animated: true)
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        tfAddress.text = ""
    }
    

}


// MARK: - TableView Delegates, TableViewDataSources
extension VCAddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchedPlaces = googleMapsViewModel.searchedPlaces else { return 0}
        return searchedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCLocationCell", for: indexPath) as! VCLocationCell
        cell.setUpTitle(googleMapsViewModel.searchedPlaces[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objc = googleMapsViewModel.searchedPlaces[indexPath.row]
        selectedSearchedPlace = objc
        self.placeId = objc.place_id ?? ""
        googleMapsViewModel.getGooglePlacesDetailsFromApi(placeID: objc.place_id ?? "")
    }
}

extension VCAddressVC{
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
            self.tfAddress.text = selectedPlace.description ?? ""
            self.address = selectedPlace.description ?? ""
            // Move map from here
            if let lat = location.location?.lat , let lng = location.location?.lng {
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.lat = location.location?.lat ?? 0.0
                self.long = location.location?.lng ?? 0.0
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

}

extension VCAddressVC:GMSMapViewDelegate{
    
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        let position = marker.position
//        print("Marker dragged to position: \(position.latitude), \(position.longitude)")
//
//        getAddressFromLatLon(pdblLatitude: "\(position.latitude)", withLongitude: "\(position.longitude)")
//    }
   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isAddressFetchingInProgress == false{
            isAddressFetchingInProgress = true
            return
        }
        
        let center = mapView.projection.coordinate(for: mapView.center)
        print("Center coordinate: \(position.target.latitude), \(position.target.longitude)")
      //  self.screenType = 10
       // self.lblNotFound.isHidden = true
      //  self.getAddressFromLatLon(pdblLatitude: "\(position.target.latitude)", withLongitude: "\(position.target.longitude)")
        getDetailedAddressFromLatLon(latitude: lat, longitude: long) { address in
            if let address = address {
                DispatchQueue.main.async {
                    self.tfAddress.text = address
                    self.fetchPlaceID(for: address)
                    self.lat = Double(position.target.latitude)
                    self.long = Double(position.target.longitude)
                    self.address = address
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
        
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
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
       
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
       
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
       
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil){
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks
            guard let placemark = placemarks?.first else {
                   print("No placemark found")
                   return
               }
               
         
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
                    self.nickName = pm.subLocality!
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
                
                //let location: LocationFromPlaceID? = LocationFromPlaceID(lng: Double(pdblLongitude), lat: Double(pdblLatitude))
//                let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
//                self.selectedLocationFromPlaceID = placeId
//                self.locationsTableView.reloadData()
                
                self.tfAddress.text = addressString.description
                self.fetchPlaceID(for: addressString.description)
                self.lat = Double(pdblLatitude) ?? 0.0
                self.long = Double(pdblLongitude) ?? 0.0
                self.address = addressString.description
              //  self.pickUpTF.text = addressString
                print(addressString)
            }
        })
    }
    // Function to fetch Place ID for the given address
    func fetchPlaceID(for address: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .address

        placesClient.findAutocompletePredictions(fromQuery: address, filter: filter, sessionToken: nil) { (predictions, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let firstPrediction = predictions?.first {
                self.placeId = firstPrediction.placeID
                print("Place ID: \(firstPrediction.placeID)")
            } else {
                print("No place ID found")
            }
        }
    }
}

extension VCAddressVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tfAddress.endEditing(true)
        self.view.endEditing(true)
        return true
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
