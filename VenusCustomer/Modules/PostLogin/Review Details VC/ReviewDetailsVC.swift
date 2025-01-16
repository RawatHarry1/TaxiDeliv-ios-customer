//
//  ReviewDetailsVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/11/24.
//

import UIKit

class ReviewDetailsVC: UIViewController, MTSlideToOpenDelegate {
    
    
    @IBOutlet weak var lblDeliveryDetails: UILabel!
    
    @IBOutlet weak var lblVechecle: UILabel!
    @IBOutlet weak var slideView: MTSlideToOpenView!
    @IBOutlet weak var txtFldPromocode: UITextField!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var lblOriginalFare: UILabel!
    
    @IBOutlet weak var viewPayByCard: UIView!
    
    @IBOutlet weak var viewPromoCode: UIView!
    @IBOutlet weak var viewPayByCash: UIView!
    @IBOutlet weak var viewDeliveryDetail: UIView!
    @IBOutlet weak var seatsLbl: UILabel!
    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var etaLbl: UILabel!
  
    @IBOutlet weak var imgViewKgIcon: UIImageView!
    @IBOutlet weak var viewPackageDetail: UIStackView!
    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var notesTF: IQTextView!
    @IBOutlet weak var txtFldMobileNumber: UITextField!
    @IBOutlet weak var txtFldReceiverName: UITextField!
    @IBOutlet weak var imgViewArrowPackage: UIImageView!
    @IBOutlet weak var imgViewArrowDelivery: UIImageView!
    @IBOutlet weak var btnPackage: UIButton!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnRadioPayByCard: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblCardDetails: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    
    var loadedPackageDetails: [PackageDetail]?
    var pickUpLocation : GeometryFromPlaceID?
    var dropLocation : GeometryFromPlaceID?
    var objOperator_availablity : operator_availablityy?
    var lat = 0.0
    var long = 0.0
    var isDeliveryHidden = false
    var isPackageHidden = false
    var selectedLocationFromPlaceID : GeometryFromPlaceID?
   // var onConfirm:((FindDriverData,GeometryFromPlaceID,String,operator_availablityy) -> Void)?
    var dismissController:(()->Void)?
    var dropPlace : GooglePlacesModel?
    var pickUpPlace : GooglePlacesModel?
    var regions: [Regions]?
    var pickupLoc = ""
    var dropoffLoc = ""
    var isSechdule = false
    var utcDate = ""
    var customerETA : etaData?
    var selectedRegions: Regions?
    var objSelecrCard : GetCardData?
    var onConfirm:((Int , RequestRideData) -> Void)?
    var promoApply = false
    
    private var viewModell = VCRideVehiclesListViewModel()
    private var viewModel = VCRideVehiclesListViewModel()
   
    static func create() -> ReviewDetailsVC {
        let obj = ReviewDetailsVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if codeTitle == ""{
            btnApply.setTitle("APPLY", for: .normal)
            btnApply.setTitleColor(UIColor(named: "buttonSelectedOrange"), for: .normal)
            promoApply = false
        }else{
            btnApply.setTitle("REMOVE", for: .normal)
            btnApply.setTitleColor(.systemRed, for: .normal)
            promoApply = true
        }
        
        if selectedRegions?.region_fare?.discount ?? 0 > 0{
            lblOriginalFare.text = "\(selectedRegions?.region_fare?.currency ?? "") \(selectedRegions?.region_fare?.original_fare ?? 0)"
            lblLine.isHidden = false
            lblOriginalFare.isHidden = false
        }else{
            lblLine.isHidden = true
            lblOriginalFare.isHidden = true
        }
        
        amountLbl.text = "\(selectedRegions?.region_fare?.currency ?? "") \(selectedRegions?.region_fare?.fare ?? 0.0)"
        self.lblCardDetails.isHidden = true
        self.btnChange.isHidden = true
        self.btnRadio.setImage(UIImage(named: "radioSelected"), for: .normal)
        
        viewDelivery.addShadowView()
        viewNotes.addShadowView()
        viewPayByCard.addShadowView()
        viewPayByCash.addShadowView()
        viewPromoCode.addShadowView()
        if let urlStr = selectedRegions?.images?.ride_now_normal_2x {
            self.vehicleImg.setImage(urlStr, showIndicator: true)
        }
       if self.objOperator_availablity?.id == 1{
            self.viewDelivery.isHidden = true
            self.viewNotes.isHidden = false
           viewPackageDetail.isHidden = true
           seatsLbl.text = "\(selectedRegions?.max_people ?? 0) seats"
           etaLbl.text = "\(selectedRegions?.eta ?? 0) min away"
           lblVechecle.text = selectedRegions?.region_name ?? ""
           imgViewKgIcon.image = UIImage(named: "userPlaceHolder")
           lblDeliveryDetails.text = "Ride Details"
          
        }else{
            viewDelivery.isHidden = false
            viewNotes.isHidden = true
            viewPackageDetail.isHidden = false
            seatsLbl.text = "\(selectedRegions?.max_people ?? 0) "
            imgViewKgIcon.image = UIImage(named: "kg")
            etaLbl.text = "\(selectedRegions?.eta ?? 0) min away"
            lblVechecle.text = selectedRegions?.region_name ?? ""
            lblDeliveryDetails.text = "Delivery Details"
        }
        callBack()
        getLocation()
        tblView.rowHeight = 200
        getLocation()
        slideViewfunc()
        
        if let loadedPackageDetails = retrievePackageDetails() {
            // Access data from the loaded array
            self.loadedPackageDetails = loadedPackageDetails
        } else {
            print("No package details found in UserDefaults.")
        }
    }
    
    func slideViewfunc(){
        slideView.sliderViewTopDistance = 0
        slideView.sliderCornerRadius = 30
        slideView.isEnabled = true
        slideView.thumnailImageView.backgroundColor  = .white
        slideView.draggedView.backgroundColor =  UIColor(named: "buttonSelectedOrange")
        slideView.backgroundColor = UIColor(named: "buttonSelectedOrange")
        slideView.delegate = self
        slideView.thumbnailViewStartingDistance = 0
        slideView.labelText = "Confirm Booking"
       // slideView.thumbnailViewTopDistance
        slideView.thumnailImageView.image = #imageLiteral(resourceName: "right-arrow").imageFlippedForRightToLeftLayoutDirection()
        slideView.thumnailImageView.tintColor =  UIColor(named: "buttonSelectedOrange")
        slideView.thumnailImageView.size = CGSize(width: 40, height: 40)
        slideView.thumbnailViewStartingDistance = 10
        slideView.thumbnailViewTopDistance = 5
      
      //  slideView.resetStateWithAnimation(true)

    }
 

    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        sender.resetStateWithAnimation(false)
        self.swipeAction()
    }
    
    func promoApi(){
        var parmas = [String: Any]()
        parmas["code"] = txtFldPromocode.text ?? ""
        viewModell.promoCodeApi(parms: parmas) {
            codeID = self.viewModel.objPromoModal?.data?.codeId ?? 0
            codeTitle = self.viewModel.objPromoModal?.data?.promo_code ?? ""
            self.btnApply.setTitle("Remove", for: .normal)
            self.btnApply.setTitleColor(.systemRed, for: .normal)
            self.promoApply = true
                Proxy.shared.displayStatusCodeAlert(self.viewModel.objPromoModal?.data?.codeMessage ?? "", title: "Promo Code")
        }
    }
    
    func removePromoCodeAlert(){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to remove the promo code?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            codeTitle = ""
            codeID = 0
            self.btnApply.setTitle("APPLY", for: .normal)
            self.btnApply.setTitleColor(UIColor(named: "buttonSelectedOrange"), for: .normal)
            self.promoApply = false
           
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func retrievePackageDetails() -> [PackageDetail]? {
        // Attempt to retrieve the saved data from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "packageDetailsKey") {
            let decoder = JSONDecoder()
            
            // Decode the data back into an array of PackageDetail objects
            if let loadedDetails = try? decoder.decode([PackageDetail].self, from: savedData) {
                return loadedDetails
            }
        }
        return nil
    }
    
    func getLocation(){
        self.getDetailedAddressFromLatLon(latitude: self.pickUpLocation?.location?.lat ?? 0.0, longitude: self.pickUpLocation?.location?.lng ?? 0.0) { str in
            if let address = str {
                DispatchQueue.main.async {
                    
                    self.lblPickup.text = str
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
        
        self.getDetailedAddressFromLatLon(latitude: self.dropLocation?.location?.lat ?? 0.0, longitude: self.dropLocation?.location?.lng ?? 0.0) { str in
            if let address = str {
                DispatchQueue.main.async {
                    
                    self.lblDropOff.text = str
                }
                print("Detailed Address: \(address)")
            } else {
                print("Address not found.")
            }
        }
    }
    
    func removeFromParentVC() {
//        self.tabBarController?.tabBar.isHidden = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    func callBack() {
        viewModel.callbackRequestRideData = { rideReq in
            self.removeFromParentVC()
            self.dismiss(animated: true) {
                codeTitle = ""
                codeID = 0
                UserDefaults.standard.removeObject(forKey: "packageDetailsKey")
               
                self.onConfirm?(0, rideReq)
            }
        }
        
        viewModel.callbackScheduleRequestRideData = { rideReq in
            codeTitle = ""
            codeID = 0
            
            self.scheduleAlert()
        }
    }
    
    func scheduleAlert(){
        let alert = UIAlertController(title: "Smart App", message: "Your ride has been scheduled successfully!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            self.removeFromParentVC()
            self.dismiss(animated: true)
            VCRouter.goToSaveUserVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func swipeAction(){
        if isSechdule == true{
            if self.objOperator_availablity?.id == 1{
                scheduleRequest()
            }else{
                if txtFldReceiverName.text?.trimTrailingWhitespace() == ""{
                    SKToast.show(withMessage: "Please enter Receiver's name.")
                }else if txtFldMobileNumber.text?.trimTrailingWhitespace() == ""{
                    SKToast.show(withMessage: "Please enter Receiver's mobile number.")
                }
//                else if txtFldGoods.text?.trimTrailingWhitespace() == ""{
//                    SKToast.show(withMessage: "Please select Goods type.")
//                }
                else{
                    scheduleRequest()
                }
            }
        }else{
            
            if self.objOperator_availablity?.id == 1{
                requestRide()
            }else{
                if txtFldReceiverName.text?.trimTrailingWhitespace() == ""{
                    SKToast.show(withMessage: "Please enter Receiver's name.")
                }else if txtFldMobileNumber.text?.trimTrailingWhitespace() == ""{
                    SKToast.show(withMessage: "Please enter Receiver's mobile number.")
                }
//                else if txtFldGoods.text?.trimTrailingWhitespace() == ""{
//                    SKToast.show(withMessage: "Please select Goods type.")
//                }
                else{
                    requestRide()
                }
            }
            
        }
    }
    
    @IBAction func btnApplyPromoCation(_ sender: Any) {
        if promoApply == false{
            if txtFldPromocode.text?.trimmingCharacters(in: .whitespaces) == ""{
                txtFldPromocode.resignFirstResponder()
                SKToast.show(withMessage: "Please enter Promo Code")
            }else{
                promoApi()
            }
        }else{
            txtFldPromocode.text = ""
            removePromoCodeAlert()
        }
        
    }
    
    
    @IBAction func btnRadioAction(_ sender: Any) {
        self.objSelecrCard = nil
        self.lblCardDetails.isHidden = true
        self.btnChange.isHidden = true
        self.btnRadio.setImage(UIImage(named: "radioSelected"), for: .normal)
        self.btnRadioPayByCard.setImage(UIImage(named: "radio"), for: .normal)
    }
    
    @IBAction func btnRadioPaybyCardAction(_ sender: Any) {
        let vc = CardsVC.create()
        vc.comesFromAccount = false
        vc.emptyObj = self.objSelecrCard
        vc.modalPresentationStyle = .overFullScreen
        vc.didPressSelecrCard = { selectedCardData in
            self.lblCardDetails.text = "Selected Card: **** \(selectedCardData.last_4 ?? "")"
            self.lblCardDetails.isHidden = false
            self.btnChange.isHidden = false
            
            self.objSelecrCard = selectedCardData
            self.btnRadioPayByCard.setImage(UIImage(named: "radioSelected"), for: .normal)
            self.btnRadio.setImage(UIImage(named: "radio"), for: .normal)
        }
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
    }
    
    @IBAction func btnDeliveryAction(_ sender: Any) {
        if isDeliveryHidden == true{
            imgViewArrowDelivery.image = UIImage(named: "arrowDown2")
            viewDeliveryDetail.isHidden = false
            isDeliveryHidden = false
        }else{
            imgViewArrowDelivery.image = UIImage(named: "upArrow")
            
            isDeliveryHidden = true
            viewDeliveryDetail.isHidden = true
        }
    }
    
    @IBAction func btnPackageAction(_ sender: Any) {
        if isPackageHidden == true{
            imgViewArrowPackage.image = UIImage(named: "arrowDown2")
            isPackageHidden = false
            tblView.isHidden = false
        }else{
            imgViewArrowPackage.image = UIImage(named: "upArrow")
            isPackageHidden = true
            tblView.isHidden = true
        }
    }
    
}
extension ReviewDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedPackageDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailTblCell", for: indexPath) as! PackageDetailTblCell
      
        cell.lblSize.text = loadedPackageDetails?[indexPath.row].package_size ?? ""
        cell.lblQuantity.text = "\(loadedPackageDetails?[indexPath.row].quantity ?? "")"
        cell.lblPackageType.text = loadedPackageDetails?[indexPath.row].type ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.heightConstant.constant = self.tblView.contentSize.height
        }
    }
}

extension ReviewDetailsVC{
    
    func viewHandelAccordingToAppStatus(){
        if objOperator_availablity?.id == 1{
            
            
        }else{
           
            
        }
    }
    
    func requestRide() {
        var att: [String:Any] = [
            "latitude": pickUpLocation?.location?.lat ?? 0.0,
            "longitude": pickUpLocation?.location?.lng ?? 0.0,
            "pickupLocationAddress": pickupLoc,//pickUpPlace?.description ?? "",
            "dropLocationAddress": dropoffLoc,//dropPlace?.description ?? "",
            "duplicateFlag": "0",
            "dropLongitude": dropLocation?.location?.lng ?? 0.0,
            "dropLatitude": dropLocation?.location?.lat ?? 0.0,
            "regionId": selectedRegions?.region_id ?? 0,
            "vehicleType": selectedRegions?.vehicle_type ?? 0,
            "phoneNo": UserModel.currentUser.login?.phone_no ?? "",
            "estimated_fare": "\(selectedRegions?.region_fare?.fare ?? 0.0)",
            "estimated_trip_distance" : "\(customerETA?.rideDistance ?? 0.0)",
            "coupon_to_apply": codeID,
            "promo_to_apply": "\(promoCodeID)",
            "customer_base_fare": "\(selectedRegions?.region_fare?.original_fare ?? 0.0)",
            "request_ride_type": self.objOperator_availablity?.id ?? 0
        ]
        
        if ClientModel.currentClientData.enabled_service! == 3{
            att["request_ride_type"] = self.objOperator_availablity?.id ?? 0
        }else if ClientModel.currentClientData.enabled_service! == 2{
            att["request_ride_type"] = 2
        }else{
            att["request_ride_type"] = 1
          
        }
        
        if self.objOperator_availablity?.id == 1{
            att["customerNote"] = notesTF.text ?? ""
        }else{
            att["recipient_name"] = self.txtFldReceiverName.text ?? ""
            att["recipient_phone_no"] = self.txtFldMobileNumber.text ?? ""
            
            
            
            
            if let json = convertToJSON(packageDetails: loadedPackageDetails!) {
                
                if let jsonObject = convertJSONStringToJSON(jsonString: json) {
                    print("Converted JSON Object: \(jsonObject)")
                    att["package_details"] = jsonObject
                } else {
                    print("Failed to convert JSON string.")
                }
            }
           
        }
        
        if objSelecrCard != nil{
            att["stripe_token"] = self.objSelecrCard?.card_id ?? ""
            att["preferred_payment_mode"] = "9"
            att["card_id"] = self.objSelecrCard?.card_id ?? ""
        }
        if let location = LocationTracker.shared.lastLocation {
            att["currentLongitude"] = location.coordinate.longitude
            att["currentLatitude"] = location.coordinate.latitude
        }

        var jsonAtt: JSONDictionary {
           return att
        }
        
        
        viewModel.requestRideApi(jsonAtt)
    }
    
    func scheduleRequest(){
        var att: [String:Any] = [
            "latitude": pickUpLocation?.location?.lat ?? 0.0,
            "longitude": pickUpLocation?.location?.lng ?? 0.0,
            "pickup_location_address": pickupLoc,//pickUpPlace?.description ?? "",
            "drop_location_address": dropoffLoc,//dropPlace?.description ?? "",
            "op_drop_latitude": dropLocation?.location?.lat ?? 0.0,
            "op_drop_longitude": dropLocation?.location?.lng ?? 0.0,
            "region_id": selectedRegions?.region_id ?? 0,
            "vehicleType": selectedRegions?.vehicle_type ?? 0,
            "fare": selectedRegions?.region_fare?.fare ?? 0.0,
            "pickup_time": utcDate,
            "preferred_payment_mode": "1",
            "ride_distance": selectedRegions?.eta ?? 0.0,
            "estimated_fare": "\(selectedRegions?.region_fare?.fare ?? 0.0)",
            "estimated_trip_distance" : "\(customerETA?.rideDistance ?? 0.0)",
            "coupon_to_apply": codeID,
            "promo_to_apply": "\(promoCodeID)",
            "customer_base_fare": "\(selectedRegions?.region_fare?.original_fare ?? 0.0)",
            
        ]
        
        if ClientModel.currentClientData.enabled_service! == 3{
            att["request_ride_type"] = self.objOperator_availablity?.id ?? 0
        }else if ClientModel.currentClientData.enabled_service! == 2{
            att["request_ride_type"] = 2
        }else{
            att["request_ride_type"] = 1
          
        }
        
        if self.objOperator_availablity?.id == 1{
            att["customerNote"] = notesTF.text ?? ""
        }else{
            att["recipient_name"] = self.txtFldReceiverName.text ?? ""
            att["recipient_phone_no"] = self.txtFldMobileNumber.text ?? ""
            
            if let json = convertToJSON(packageDetails: loadedPackageDetails!) {
                
                if let jsonObject = convertJSONStringToJSON(jsonString: json) {
                    print("Converted JSON Object: \(jsonObject)")
                    att["package_details"] = jsonObject
                } else {
                    print("Failed to convert JSON string.")
                }
            }
           // att["customerNote"] = self.txtFldGoods.text ?? ""
        }
        
       
      
        var jsonAtt: JSONDictionary {
           return att
        }
        
        viewModel.scheduleRequestRideApi(jsonAtt)
    }
}

extension ReviewDetailsVC{
    
    func convertToJSON(packageDetails: [PackageDetail]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            
            let jsonData = try encoder.encode(packageDetails)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
    
    func convertJSONStringToJSON(jsonString: String) -> Any? {
        // Convert the JSON string to Data
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                // Deserialize JSON data into a Swift object (Dictionary or Array)
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                return jsonObject
            } catch {
                print("Error deserializing JSON: \(error)")
                return nil
            }
        }
        return nil
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
