//
//  CalenderVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 14/06/24.
//

import UIKit

class CalenderVC: UIViewController {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var isSelectedDate = false
    var isSelectedTime = false
    var selectedDatee: Date?
    var selectedTimee: Date?
    var utcDate = ""
    var didPressSubmit: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldDate.delegate = self
        txtFldTime.delegate = self
        datePicker.datePickerMode = .date
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
         dateFormatter.dateFormat = "d MMM, yyyy"
         let formattedDate = dateFormatter.string(from: currentDate)
        lblDate.text = formattedDate
        getCurrentTime()
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
            lblTime.text = formattedDate
            
           
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
    
    @IBAction func btnDismissActiomn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSelectDate(_ sender: Any) {
       
    }
    
    func openDatePicker() {

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
        txtFldDate.inputView = datePicker
        
        // Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        if #available(iOS 14.0, *) {
            toolbar.setItems([UIBarButtonItem.flexibleSpace(), doneButton], animated: true)
        } else {
            // Fallback on earlier versions
        }
        txtFldDate.inputAccessoryView = toolbar
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        isSelectedDate = true
        selectedDatee = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let selectedDate = formatter.string(from: datePicker.date)
        lblDate.text = formatter.string(from: datePicker.date)
        updateDateTimeLabel()
    }
    
    @objc func doneButtonTapped() {
        txtFldDate.resignFirstResponder()
        txtFldTime.resignFirstResponder()
    }
}

extension CalenderVC{
    func openTimePicker() {
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
        txtFldTime.inputView = timePicker
        
        // Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        if #available(iOS 14.0, *) {
            toolbar.setItems([UIBarButtonItem.flexibleSpace(), doneButton], animated: true)
        } else {
            toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        }
        txtFldTime.inputAccessoryView = toolbar
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
            lblTime.text = timeFormatter.string(from: adjustedDate)
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
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
               print("Selected DateTime (UTC): \(dateFormatter.string(from: combinedDate))")
               utcDate = dateFormatter.string(from: combinedDate)
               print("UTC is => " ,utcDate)
           }
       }
}

extension CalenderVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldDate{
            openDatePicker()

        }else if  textField == txtFldTime{
            openTimePicker()

        }
        return true
    }
}
