//
//  AddAddressVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 14/06/24.
//

import UIKit
protocol addressAdded{
    func dismiss()
}
class AddAddressVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtFldNickName: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var vwTxtFldOther: UIView!
    @IBOutlet weak var txtFldOther: UITextField!
    @IBOutlet weak var vwOther: UIView!
    @IBOutlet weak var vwWork: UIView!
    @IBOutlet weak var vwHome: UIView!
    
    var objAddressViewModel: AddressViewModal = AddressViewModal()
    var address = ""
    var nickName = ""
    var lat = 0.0
    var long = 0.0
    var placeId = ""
    var type = ""
    var delegate: addressAdded?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldOther.delegate = self
        txtFldNickName.delegate = self
        
        vwTxtFldOther.isHidden = true
        lblAddress.text = address
        txtFldNickName.text = nickName
        selectedButton(vw: vwHome)
        unSelectedButton(vw: vwWork)
        unSelectedButton(vw: vwOther)
        vwTxtFldOther.isHidden = true
        self.type = "Home"
        objAddressViewModel.successCallBack = {  result in
            self.dismiss(animated: true) {
                self.delegate?.dismiss()
            }
        }
    }
    
    func selectedButton(vw:UIView){
        vw.layer.borderColor = UIColor.systemGray4.cgColor
        vw.backgroundColor = .systemGray4
    }
    
    func unSelectedButton(vw:UIView){
        vw.layer.borderColor = UIColor.systemGray4.cgColor
        vw.backgroundColor = .white
    }
    
    func addAddressApi(){
        var attribute = [String : Any]()
       
        attribute["address"] = self.address
        attribute["latitude"] = self.lat
        attribute["longitude"] = self.long
        attribute["google_place_id"] = self.placeId
        attribute["keep_duplicate"] = 1
        attribute["type"] = self.type
        attribute["nick_name"] = self.nickName
        objAddressViewModel.addAddressApi(attribute, true)
       
    }
    
    
    @IBAction func btnChangeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        selectedButton(vw: vwHome)
        unSelectedButton(vw: vwWork)
        unSelectedButton(vw: vwOther)
        vwTxtFldOther.isHidden = true
        self.type = "Home"
    }
    
    @IBAction func btnWorkAction(_ sender: Any) {
        selectedButton(vw: vwWork)
        unSelectedButton(vw: vwHome)
        unSelectedButton(vw: vwOther)
        vwTxtFldOther.isHidden = true
        self.type = "Work"
    }
    
    @IBAction func btnOtherAction(_ sender: Any) {
        selectedButton(vw: vwOther)
        unSelectedButton(vw: vwHome)
        unSelectedButton(vw: vwWork)
        vwTxtFldOther.isHidden = false
        self.type = "Other"
    }
    
    @IBAction func btnAddAddressAction(_ sender: Any) {
        if type == ""{
            SKToast.show(withMessage: "Please select Save as!!")
        }else if vwTxtFldOther.isHidden == false{
            if type == "Other"{
                SKToast.show(withMessage: "Please enter name for Save as!!")
            }else{
                addAddressApi()
            }
        }else{
            addAddressApi()
        }
    }
}

extension AddAddressVC{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder() // Dismiss the keyboard
       
          return true
      }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldOther{
            if (range.location == 0 && string == " ") {
                return false
            }
            if let text = textField.text as NSString? {
                type = text.replacingCharacters(in: range, with: string)
            } else {
                type = string
            }
        }else if textField == txtFldNickName{
            if let text = textField.text as NSString? {
                nickName = text.replacingCharacters(in: range, with: string)
            } else {
                nickName = string
            }
        }
 
            print("Current text: \(type)")
            return true
        }
}
