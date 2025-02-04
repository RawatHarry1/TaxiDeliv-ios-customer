//
//  VCConfirmRideVC.swift
//  VenusCustomer
//
//  Created by Amit on 16/07/23.
//

import UIKit

class VCConfirmRideVC: VCBaseVC, UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var viewDelivery: UIStackView!
    @IBOutlet weak var viewVenus: UIStackView!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblCardDetails: UILabel!
    @IBOutlet weak var viewPayByCard: UIView!
    @IBOutlet weak var btnRadioPayByCard: UIButton!
    @IBOutlet weak var btnPromo: UIButton!
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var notesTF: UITextView!

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblOriginalFare: UILabel!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var addCardShadowView: UIView!
    @IBOutlet weak var applyPromoShadowView: UIView!
    @IBOutlet weak var defaultCardShadowView: UIView!

    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var vehicleTitleLbl: UILabel!
    @IBOutlet weak var seatsLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerPhoneLbl: UILabel!
    @IBOutlet weak var etaLbl: UILabel!
    
    @IBOutlet weak var viewPayByCash: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var imgViewKgIcon: UIImageView!
    @IBOutlet weak var viewStack: UIStackView!
    
    @IBOutlet weak var txtFldReceiverName: UITextField!
    
    @IBOutlet weak var txtFldMobileNumber: UITextField!
    
    @IBOutlet weak var txtFldGoods: UITextField!
    
    
    var onConfirm:((Int , RequestRideData) -> Void)?
    var selectedRegions: Regions?
    var pickUpPlace : GooglePlacesModel?
    var pickUpLocation : GeometryFromPlaceID?
    var customerETA : etaData?
    private var viewModelFindDriver = VCScheduleViewModel()
    var dropPlace : GooglePlacesModel?
    var dropLocation : GeometryFromPlaceID?
    var pickUpLoc = ""
    var dropOffLoc = ""
    var isSelectRadio = true
    var utcDate = ""
    var isSechdule = false
    var objSelecrCard : GetCardData?
    var objOperationAvalablity : operator_availablityy?
    private var viewModel = VCRideVehiclesListViewModel()
    var selectedIntGoods = -1
    var loadedPackageDetails: [PackageDetail]?
   
    //  To create ViewModel
    static func create() -> VCConfirmRideVC {
        let obj = VCConfirmRideVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

    override func initialSetup() {
        viewHandelAccordingToAppStatus()
        if codeTitle == ""{
            btnPromo.isHidden = false
            btnRemove.isHidden = true
            lblPromocode.text = "Apply Promo Code"
        }else{
            btnRemove.isHidden = false
            btnPromo.isHidden = true
            lblPromocode.text = "Applied: \(codeTitle)"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewControllerDismissed), name: .viewControllerDismissed, object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.lblCardDetails.isHidden = true
        self.btnChange.isHidden = true
        self.btnRadio.setImage(UIImage(named: "radioSelected"), for: .normal)
        print(selectedRegions!)
        notesTF.textContainerInset = UIEdgeInsets.zero
        notesTF.textContainer.lineFragmentPadding = 0

//        feebackTV.backgroundColor = UIColor.lightGray
        notesTF.textColor = VCColors.textColorGrey.color
       
        notesTF.delegate = self
        if let urlStr = selectedRegions?.images?.ride_now_normal_2x {
            self.vehicleImg.setImage(urlStr, showIndicator: true)
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
        vehicleTitleLbl.text = selectedRegions?.region_name ?? ""
        customerNameLbl.text = UserModel.currentUser.login?.user_name ?? ""
        customerPhoneLbl.text = UserModel.currentUser.login?.phone_no ?? ""
        etaLbl.text = "\(selectedRegions?.eta ?? 0) \((selectedRegions?.eta ?? 0) > 1 ? "mins" : "min")"
        callBack()
        
        self.navigationController?.delegate = self

                // Disable the interactive pop gesture recognizer
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func viewHandelAccordingToAppStatus(){
        if objOperationAvalablity?.id == 1{
            viewDelivery.isHidden = true
            viewVenus.isHidden = false
            seatsLbl.text = "\(selectedRegions?.max_people ?? 0) seats"
            imgViewKgIcon.image = UIImage(named: "userPlaceHolder")
        }else{
            viewDelivery.isHidden = false
            viewVenus.isHidden = true
            seatsLbl.text = "\(selectedRegions?.max_people ?? 0) Kg"
            imgViewKgIcon.image = UIImage(named: "kg")
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    deinit {
           // Remove observer
           NotificationCenter.default.removeObserver(self, name: .viewControllerDismissed, object: nil)
       }
    
    @objc private func handleViewControllerDismissed() {
        if codeTitle == ""{
            btnPromo.isHidden = false
            btnRemove.isHidden = true
            lblPromocode.text = "Apply Promo Code"
        }else{
            btnRemove.isHidden = false
            btnPromo.isHidden = true
            lblPromocode.text = "Applied: \(codeTitle)"
        }
    }

    override func viewDidLayoutSubviews() {
        addCardShadowView.addShadowView()
        applyPromoShadowView.addShadowView()
        defaultCardShadowView.addShadowView()
        viewPayByCash.addShadowView()
        viewPayByCard.addShadowView()
        baseView.roundCorner([.topLeft, .topRight], radius: 32)
        backView.roundCorner([.topRight, .bottomRight], radius: 28)
    }
    

    
    @IBAction func btnRemoveAction(_ sender: Any) {
        removePromoCodeAlert()
    }
    
    @IBAction func btnChangeAction(_ sender: Any) {
        let vc = CardsVC.create()
        vc.comesFromAccount = false
        vc.emptyObj = self.objSelecrCard
        vc.didPressSelecrCard = { selectedCardData in
            self.lblCardDetails.text = "Selected Card: **** \(selectedCardData.last_4 ?? "")"
            self.lblCardDetails.isHidden = false
            self.btnChange.isHidden = false
            
            self.objSelecrCard = selectedCardData
            self.btnRadioPayByCard.setImage(UIImage(named: "radioSelected"), for: .normal)
            self.btnRadio.setImage(UIImage(named: "radio"), for: .normal)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnRadioPaybyCardAction(_ sender: Any) {
        let vc = CardsVC.create()
        vc.comesFromAccount = false
        vc.emptyObj = self.objSelecrCard
        vc.didPressSelecrCard = { selectedCardData in
            self.lblCardDetails.text = "Selected Card: **** \(selectedCardData.last_4 ?? "")"
            self.lblCardDetails.isHidden = false
            self.btnChange.isHidden = false
            
            self.objSelecrCard = selectedCardData
            self.btnRadioPayByCard.setImage(UIImage(named: "radioSelected"), for: .normal)
            self.btnRadio.setImage(UIImage(named: "radio"), for: .normal)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    func removePromoCodeAlert(){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to remove the promo code?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            codeTitle = ""
            codeID = 0
            self.btnPromo.isHidden = false
            self.btnRemove.isHidden = true
            self.lblPromocode.text = "Apply Promo Code"
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectGoodsAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoodsVC") as! GoodsVC
        vc.selectedIndex = self.selectedIntGoods
        vc.goods = { (message: String, index: Int) in
            self.txtFldGoods.text = message
            self.selectedIntGoods = index
        }
        self.present(vc, animated: true)
    }
    
    
//    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: self.view)
//        
//        switch gesture.state {
//        case .began:
//
//           
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlUp, animations: {
//                self.viewStack.isHidden = false
//                self.view.setNeedsLayout()
//                self.view.layoutIfNeeded()
//                self.viewDidLayoutSubviews()
//            }, completion: nil)
//            
//        case .changed:
//            
//            if translation.y > 0 {
//                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCurlDown, animations: {
//                    self.viewStack.isHidden = true
//                    self.view.setNeedsLayout()
//                    self.view.layoutIfNeeded()
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
//    }

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
        let alert = UIAlertController(title: "Mars Delivery", message: "Your ride has been scheduled successfully!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            self.removeFromParentVC()
            self.dismiss(animated: true)
            VCRouter.goToSaveUserVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func scheduleRequest(){
        var att: [String:Any] = [
            "latitude": pickUpLocation?.location?.lat ?? 0.0,
            "longitude": pickUpLocation?.location?.lng ?? 0.0,
            "pickup_location_address": pickUpLoc,//pickUpPlace?.description ?? "",
            "drop_location_address": dropOffLoc,//dropPlace?.description ?? "",
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
            att["request_ride_type"] = self.objOperationAvalablity?.id ?? 0
        }else if ClientModel.currentClientData.enabled_service! == 2{
            att["request_ride_type"] = 2
        }else{
            att["request_ride_type"] = 1
          
        }
        
        if self.objOperationAvalablity?.id == 1{
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

    func requestRide() {
        var att: [String:Any] = [
            "latitude": pickUpLocation?.location?.lat ?? 0.0,
            "longitude": pickUpLocation?.location?.lng ?? 0.0,
            "pickupLocationAddress": pickUpLoc,//pickUpPlace?.description ?? "",
            "dropLocationAddress": dropOffLoc,//dropPlace?.description ?? "",
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
            "request_ride_type": self.objOperationAvalablity?.id ?? 0
        ]
        
        if ClientModel.currentClientData.enabled_service! == 3{
            att["request_ride_type"] = self.objOperationAvalablity?.id ?? 0
        }else if ClientModel.currentClientData.enabled_service! == 2{
            att["request_ride_type"] = 2
        }else{
            att["request_ride_type"] = 1
          
        }
        
        if self.objOperationAvalablity?.id == 1{
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
    
    @IBAction func btnPromoCodeAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPromoCodeVC") as! EnterPromoCodeVC
        vc.selectedRegions = self.selectedRegions
        self.present(vc, animated: true)
    }
    

    @IBAction func btnConfirm(_ sender: Any) {
        if isSechdule == true{
            if self.objOperationAvalablity?.id == 1{
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
            
            if self.objOperationAvalablity?.id == 1{
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

    @IBAction func backBtn(_ sender: UIButton) {
        codeTitle = ""
        codeID = 0
        removeFromParentVC()
    }
    @IBAction func btnRadioAction(_ sender: Any) {
        self.objSelecrCard = nil
        self.lblCardDetails.isHidden = true
        self.btnChange.isHidden = true
        self.btnRadio.setImage(UIImage(named: "radioSelected"), for: .normal)
        self.btnRadioPayByCard.setImage(UIImage(named: "radio"), for: .normal)
    }
    
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


}


extension VCConfirmRideVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VCColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VCColors.textColor.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = VCColors.textColorGrey.color
        }
    }
}

