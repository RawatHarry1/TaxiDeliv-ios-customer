//
//  TrackOrderVc.swift
//  E wallet App
//
//  Created by Ayush Verma on 05/11/24.
//

import UIKit
import GoogleMaps
class TrackOrderVc: VCBaseVC {
    
    @IBOutlet weak var lblDropLoc: UILabel!
    
    @IBOutlet weak var lblPickupLoc: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vehcicleCollectionView: UICollectionView!
    @IBOutlet weak var startView: UIView!
    
    var pickUpLocation : GeometryFromPlaceID?
    var dropLocation : GeometryFromPlaceID?
    var objOperator_availablity : operator_availablityy?
    var markerUser : GMSMarker?
    var lat = 0.0
    var long = 0.0
    var vehicle_types :[vechleType]?
    var selectedIndex = 0
    
    var dropPlace : GooglePlacesModel?
    var pickUpPlace : GooglePlacesModel?
    var regions: [Regions]?
    var pickupLoc = ""
    var dropoffLoc = ""
    var isSechdule = false
    var utcDate = ""
    var customerETA : etaData?
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()
    private var viewModelPoly = VCHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicle_types =  UserModel.currentUser.login?.vehicle_types ?? []
        startView.layer.cornerRadius = 7.5
        vehcicleCollectionView.register(UINib.init(nibName: "TrackCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TrackCollectionCell")

        viewModelPoly.polylineCallBack = { polyline in
            self.showPath(polyStr: polyline)
        }
        
        let pickupLocation = CLLocationCoordinate2D(latitude: pickUpLocation?.location?.lat ?? 0.0, longitude: pickUpLocation?.location?.lng ?? 0.0)
        
        let destination = CLLocationCoordinate2D(latitude: dropLocation?.location?.lat ?? 0.0, longitude:  dropLocation?.location?.lng ?? 0.0)
        showMarker(Source: pickupLocation , Destination: destination)
        getLocation()
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
       
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
       // self.addMarkerToPosition(coordinates)
      
    }
    
    
    
    func getLocation(){
       
            self.getDetailedAddressFromLatLon(latitude: self.pickUpLocation?.location?.lat ?? 0.0, longitude: self.pickUpLocation?.location?.lng ?? 0.0) { str in
                if let address = str {
                    DispatchQueue.main.async {
                       
                        self.lblPickupLoc.text = str
                    }
                    print("Detailed Address: \(address)")
                } else {
                    print("Address not found.")
                }
               
            }

            self.getDetailedAddressFromLatLon(latitude: self.dropLocation?.location?.lat ?? 0.0, longitude: self.dropLocation?.location?.lng ?? 0.0) { str in
                if let address = str {
                    DispatchQueue.main.async {
                       
                        self.lblDropLoc.text = str
                    }
                    print("Detailed Address: \(address)")
                } else {
                    print("Address not found.")
                }
            }
        
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
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PackageListVc") as! PackageListVc
        vc.dropPlace = self.dropPlace
        vc.dropLocation = self.dropLocation
        vc.pickUpPlace = self.pickUpPlace
        vc.pickUpLocation = self.pickUpLocation
        vc.regions = self.regions
        vc.pickupLoc = self.pickupLoc
        vc.dropoffLoc = self.dropoffLoc
        vc.isSechdule = self.isSechdule
        vc.utcDate = self.utcDate
        vc.customerETA = self.customerETA
        vc.objOperator_availablity = self.objOperator_availablity
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TrackOrderVc : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicle_types?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionCell", for: indexPath) as! TrackCollectionCell
        cell.sizeImageView.setImage(withUrl: vehicle_types?[indexPath.row].images ?? "") { status, image in}
        cell.smallLabel.text = vehicle_types?[indexPath.row].region_name ?? ""
        
        if selectedIndex == indexPath.row{
            cell.baseView.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
        }else{
            cell.baseView.borderColor = .systemGray2
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.vehcicleCollectionView.reloadData()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 110, height: 110)
//
//        
//    }
    
    
    
}
extension TrackOrderVc{
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
