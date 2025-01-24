//
//  RentalVC.swift
//  VenusCustomer
//
//  Created by TechBuilder on 24/01/25.
//

import UIKit

class RentalVC: UIViewController {
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
    @IBOutlet weak var btnEndTime: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
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
    var selectedEndDatee: Date?
    var selectedEndTimee: Date?

    var utcDate = ""
    var didPressSubmit: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEndDate.setTitle("", for: .normal)
        btnEndTime.setTitle("", for: .normal)
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
       
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // Handle date picker value change events here
        let selectedDate = sender.date
        
        // Print selected date or do something else with it
        print("Selected date: \(selectedDate)")
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
            
           
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if isSelectedDate == false{
            SKToast.show(withMessage: "Select Date!!")
        }else if isSelectedTime == false{
            SKToast.show(withMessage: "Select Time!!")
        }else{
            self.dismiss(animated: true,completion: {
                self.didPressSubmit!(self.utcDate)
            })
        }
    }
    
    @IBAction func btnEndDateAct(_ sender: UIButton) {
//        openDatePicker()
    }
    @IBAction func btnEndTimeAct(_ sender: UIButton) {
//        openTimePicker()
    }
    @IBAction func btnDismissActiomn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSelectDate(_ sender: Any) {
       
    }
    
    func openDatePicker(_ textField : UITextField) {

        // Configure the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date() // Set the minimum date to today
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
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        isSelectedDate = true
        selectedDatee = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let selectedDate = formatter.string(from: datePicker.date)
        if startDateSelected == false{
            lblEndDate.text = formatter.string(from: datePicker.date)
        }
        else
        {
            lblStartDate.text = formatter.string(from: datePicker.date)
        }
        
//        lblDate.text = formatter.string(from: datePicker.date)
        updateDateTimeLabel()
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
    }
    
    @IBAction func btnScheduleLater(_ sender: UIButton) {
        iconScedule.image = UIImage(named: "iconCheck")?.withRenderingMode(.alwaysTemplate)
        iconNow.image = UIImage(named: "unchecked")?.withRenderingMode(.alwaysOriginal)
        viewStartTime.isHidden = false

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
        updateDateTimeLabel()
    }

    
    // Function to handle time changes in the picker
    @objc func timeChanged(timePicker: UIDatePicker) {
        isSelectedTime = true
        let selectedDate = timePicker.date

        // Subtract 30 minutes from the selected date
        let calendar = Calendar.current
        if let adjustedDate = calendar.date(byAdding: .minute, value: 0, to: selectedDate) {
            selectedTimee = adjustedDate
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            if startTimeSelected == false
            {
                lblEndTime.text = timeFormatter.string(from: adjustedDate)
            }
            else
            {
                lblStartTime.text = timeFormatter.string(from: adjustedDate)
            }
//            lblTime.text = timeFormatter.string(from: adjustedDate)
            updateDateTimeLabel()
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
