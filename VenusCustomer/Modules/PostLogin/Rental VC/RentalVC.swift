//
//  RentalVC.swift
//  VenusCustomer
//
//  Created by TechBuilder on 24/01/25.
//

import UIKit
import CoreLocation

class RentalVC: VCBaseVC {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var dropOffTf: VCTextField!
    @IBOutlet weak var btnSchedule: UIButton!
    
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var btnStartTime: UIButton!
    @IBOutlet weak var viewStartTime: UIView!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var pickUpTf: VCTextField!
    @IBOutlet weak var locationImageDestination: UIImageView!
    @IBOutlet weak var btnNow: UIButton!
    @IBOutlet weak var iconScedule: UIImageView!
    @IBOutlet weak var iconNow: UIImageView!
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var isSelectedDate = false
    var isSelectedTime = false
    var selectedDatee: Date?
    var selectedTimee: Date?
    private var viewModel = VCScheduleViewModel()
    var selectedEndDatee: Date?
    var selectedEndTimee: Date?
    @IBOutlet weak var baseView: UIView!
    private var screenType = 2
    var pickUpPlace : GooglePlacesModel?
    var dropPlace : GooglePlacesModel?
    var cancelScheduleRideAction:((Bool) -> Void)?
    var onConfirm:((FindDriverData,GeometryFromPlaceID,String,operator_availablityy,String,String,Bool) -> Void)?

    var objAddressViewModel: AddressViewModal = AddressViewModal()
    var objGetdata : GetAddData?
    var lat = 0.0
    var long = 0.0
    var pickUpLocation : GeometryFromPlaceID?
    var dropLocation : GeometryFromPlaceID?
    var objOperator_availablity : operator_availablityy?

    var utcDate = ""
    var utcEndDate = ""

    var didPressSubmit: ((String,String)->Void)?
    var setPickUpLocation: String = "" {
        didSet {
            self.pickUpTf.text = setPickUpLocation
        }
    }

    var setDropLocation: String = "" {
        didSet {
            self.dropOffTf.text = setDropLocation
        }
    }
    var selectedLocationFromPlaceID : GeometryFromPlaceID?
    var onPickUpClicked:((Int, String,GeometryFromPlaceID) -> Void)?
    var onDropClicked:((Int, String) -> Void)?

    static func create(_ type: Int) -> RentalVC {
        let obj = RentalVC.instantiate(fromAppStoryboard: .ride)
        obj.screenType = type
        return obj
    }
    var viewStartTimeHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()

        btnStartDate.setTitle("", for: .normal)
        btnStartTime.setTitle("", for: .normal)
        viewStartTime.isHidden = true
        iconNow.image = iconNow.image?.withRenderingMode(.alwaysTemplate)
        locationImage.image = locationImage.image?.withRenderingMode(.alwaysTemplate)
        locationImageDestination.image = locationImageDestination.image?.withRenderingMode(.alwaysTemplate)
        txtFldDate.delegate = self
        txtFldTime.delegate = self
        tfStartDate.delegate = self
        tfStartTime.delegate = self
        datePicker.datePickerMode = .date
        btnNow.setTitle("", for: .normal)
        btnSchedule.setTitle("", for: .normal)
        getCurrentDate()
        callBacks()
    }
    func callBacks() {
        self.viewModel.findDriverSuccessCallBack = { object in
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: self.long, lat: self.lat)
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.onConfirm?(object,placeId!,self.pickUpTf.text ?? "",self.objOperator_availablity!,self.utcDate,self.utcEndDate, !self.viewStartTimeHidden)
//            self.removeFromParentVC()
        }
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
                        self.pickUpTf.text = address
                    }
                    print("Detailed Address: \(address)")
                } else {
                    print("Address not found.")
                }
            }
        }
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
    
    @IBAction func onDropAct(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.onDropClicked?(self.screenType, "\(self.dropOffTf.text ?? "")")
        }
    }
 
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // Handle date picker value change events here
        let selectedDate = sender.date
        
        // Print selected date or do something else with it
        print("Selected date: \(selectedDate)")
    }
    
    @IBAction func onPickUpAct(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let location: LocationFromPlaceID? = LocationFromPlaceID(lng: self.long, lat: self.lat)
            let placeId: GeometryFromPlaceID? = GeometryFromPlaceID(location: location)
            self.selectedLocationFromPlaceID = placeId
            self.onPickUpClicked?(self.screenType, "\(self.pickUpTf.text ?? "")", placeId!)
        }
    }
    func getCurrentDate(){
        isSelectedDate = true
         let currentDate = Date()
         let dateFormatter = DateFormatter()
        selectedDatee = currentDate
         dateFormatter.dateFormat = "E, MMM d"
         let formattedDate = dateFormatter.string(from: currentDate)
        lblStartDate.text = formattedDate
        getCurrentTime()
     }
    
    @IBAction func btnStartTimeAct(_ sender: UIButton) {
    }
    @IBAction func btnStartDateAct(_ sender: UIButton) {
    }
    func getCurrentTime() {
        isSelectedTime = true
        let currentDate = Date()
        
        // Subtract 30 minutes from the current time
        let calendar = Calendar.current
        if let adjustedDate = calendar.date(byAdding: .minute, value: +32, to: currentDate) {
            selectedTimee = adjustedDate
            
            // Format the adjusted date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: adjustedDate)
            lblStartTime.text = formattedDate
            updateDateTimeLabel()
            
           
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if (pickUpTf.text ?? "") == "" {
            SKToast.show(withMessage: "Please enter pickup location.")
            return
        }
        
        if (dropOffTf.text ?? "") == "" {
            SKToast.show(withMessage: "Please enter drop location.")
           
            return
        }
       if  viewStartTimeHidden == false
        {
           if (lblStartDate.text ?? "") == "" || (lblStartDate.text ?? "") == "-- --" {
               SKToast.show(withMessage: "Please enter start date.")
              
               return
           }
           if (lblStartTime.text ?? "") == "" || (lblStartTime.text ?? "") == "-- --" {
               SKToast.show(withMessage: "Please enter start time.")
              
               return
           }

       }
        if (lblEndDate.text ?? "") == "" || (lblEndDate.text ?? "") == "-- --" {
            SKToast.show(withMessage: "Please enter end date.")
           
            return
        }
        if (lblEndTime.text ?? "") == "" || (lblEndTime.text ?? "") == "-- --" {
            SKToast.show(withMessage: "Please enter end time.")
           
            return
        }
       // if self.objOperator_availablity?.id == 1{
//            self.viewModel.findDriver(self.pickUpLocation, self.dropLocation, typeID: self.objOperator_availablity?.id ?? 0)
        self.viewModel.findDriver(self.pickUpLocation, self.dropLocation, typeID: self.objOperator_availablity?.id ?? 0,isForRental: true,start_date: utcDate,drop_date: utcEndDate)

//            self.dismiss(animated: true,completion: {
//                self.didPressSubmit!(self.utcDate,self.utcEndDate)
//            })
        
    }
    

    @IBAction func btnDismissActiomn(_ sender: Any) {
        cancelScheduleRideAction?(true)
        removeFromParentVC()

//        self.dismiss(animated: true)
    } 
    func removeFromParentVC() {
        self.tabBarController?.tabBar.isHidden = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func btnSelectDate(_ sender: Any) {
       
    }
    
    func openDatePicker(_ textField : UITextField) {

        // Configure the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if startDateSelected == false{
            
            datePicker.minimumDate = selectedEndDatee != nil ? selectedEndDatee : Date()
        }
        else
        {
            datePicker.minimumDate = selectedDatee != nil ? selectedDatee : Date()

        }
        // Set the minimum date to today
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        // Set the date picker's target to the text field
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textField.inputView = datePicker
        
        // Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        if #available(iOS 14.0, *) {
            toolbar.setItems([UIBarButtonItem.flexibleSpace(), doneButton], animated: true)
        } else {
            // Fallback on earlier versions
        }
        textField.inputAccessoryView = toolbar
        if startDateSelected == false{
            if utcEndDate == ""
            {
                setDateMain(date: Date())
            }
            
        }
        
    }
    func setDateMain(date : Date)
    {
        isSelectedDate = true
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let selectedDate = formatter.string(from: date)
        if startDateSelected == false{
            selectedEndDatee = date
            lblEndDate.text = formatter.string(from: date)
            updateDateTimeLabelEndDate()
        }
        else
        {
            selectedDatee = date
            lblStartDate.text = formatter.string(from: date)
            updateDateTimeLabel()
        }
    }
    @objc func dateChanged(datePicker: UIDatePicker) {
   
        setDateMain(date: datePicker.date)
//
        
    }
    
    @objc func doneButtonTapped() {
        txtFldDate.resignFirstResponder()
        txtFldTime.resignFirstResponder()
        tfStartDate.resignFirstResponder()
        tfStartTime.resignFirstResponder()
    }
    @IBAction func btnScheduleNow(_ sender: UIButton) {
        iconNow.image = UIImage(named: "iconCheck")?.withRenderingMode(.alwaysTemplate)
        iconScedule.image = UIImage(named: "unchecked")?.withRenderingMode(.alwaysOriginal)
        viewStartTime.isHidden = true
        viewStartTimeHidden = true
    }
    
    @IBAction func btnScheduleLater(_ sender: UIButton) {
        iconScedule.image = UIImage(named: "iconCheck")?.withRenderingMode(.alwaysTemplate)
        iconNow.image = UIImage(named: "unchecked")?.withRenderingMode(.alwaysOriginal)
        viewStartTime.isHidden = false
        viewStartTimeHidden = false


    }
    var startTimeSelected = false
    var startDateSelected = false

}

extension RentalVC{
    func openTimePicker(_ textField : UITextField) {
        // Configure the time picker
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        // Set the initial date to 30 minutes before the current time
        let calendar = Calendar.current
        let currentDate = Date()
        if let initialDate = calendar.date(byAdding: .minute, value: +32, to: currentDate) {
            timePicker.setDate(initialDate, animated: false)
        }
        
        // Set the time picker's target to call the timeChanged function
        timePicker.addTarget(self, action: #selector(timeChanged(timePicker:)), for: .valueChanged)
        textField.inputView = timePicker
        
        // Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        if #available(iOS 14.0, *) {
            toolbar.setItems([UIBarButtonItem.flexibleSpace(), doneButton], animated: true)
        } else {
            toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        }
        
        textField.inputAccessoryView = toolbar
            if startTimeSelected == false{
                if utcEndDate == ""
                {
                    updateTime(selectedDate: timePicker.date)
                }
                
            }

    }

    
    // Function to handle time changes in the picker
    @objc func timeChanged(timePicker: UIDatePicker) {
        updateTime(selectedDate: timePicker.date)
    }
    
    func updateTime(selectedDate : Date)
    {
        isSelectedTime = true

        // Subtract 30 minutes from the selected date
        let calendar = Calendar.current
        if let adjustedDate = calendar.date(byAdding: .minute, value: 0, to: selectedDate) {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            if startTimeSelected == false
            {
                selectedEndTimee = adjustedDate
                lblEndTime.text = timeFormatter.string(from: adjustedDate)
                updateDateTimeLabelEndDate()
            }
            else
            {
                selectedTimee = adjustedDate
                lblStartTime.text = timeFormatter.string(from: adjustedDate)
                updateDateTimeLabel()
            }
            
        }
    }
    
    @objc func doneButtonTappedd() {
        updateDateTimeLabel()
        txtFldTime.resignFirstResponder()
    }
    
    func updateDateTimeLabel() {
           guard let date = selectedDatee, let time = selectedTimee else { return }
           
           // Combine date and time
           let calendar = Calendar.current
           let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
           let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
           
           var combinedComponents = DateComponents()
           combinedComponents.year = dateComponents.year
           combinedComponents.month = dateComponents.month
           combinedComponents.day = dateComponents.day
           combinedComponents.hour = timeComponents.hour
           combinedComponents.minute = timeComponents.minute
           
           if let combinedDate = calendar.date(from: combinedComponents) {
               let dateFormatter = DateFormatter()
               dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
               dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
               print("Selected DateTime (UTC): \(dateFormatter.string(from: combinedDate))")
               utcDate = dateFormatter.string(from: combinedDate)
               print("UTC is => " ,utcDate)
           }
       }
    func updateDateTimeLabelEndDate() {
           guard let date = selectedEndDatee, let time = selectedEndTimee else { return }
           
           // Combine date and time
           let calendar = Calendar.current
           let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
           let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
           
           var combinedComponents = DateComponents()
           combinedComponents.year = dateComponents.year
           combinedComponents.month = dateComponents.month
           combinedComponents.day = dateComponents.day
           combinedComponents.hour = timeComponents.hour
           combinedComponents.minute = timeComponents.minute
           
           if let combinedDate = calendar.date(from: combinedComponents) {
               let dateFormatter = DateFormatter()
               dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
               dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
               print("Selected DateTime (UTC): \(dateFormatter.string(from: combinedDate))")
               utcEndDate = dateFormatter.string(from: combinedDate)
               print("UTC is => " ,utcEndDate)
           }
       }
}

extension RentalVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldDate{
            startDateSelected = false
            openDatePicker(textField)
            

        }else if  textField == txtFldTime{
            startTimeSelected = false

            openTimePicker(textField)

        }
        else if  textField == tfStartDate{
            startDateSelected = true
            openDatePicker(textField)

        }
        else if  textField == tfStartTime{
            startTimeSelected = true

            openTimePicker(textField)
        }

        return true
    }
}
