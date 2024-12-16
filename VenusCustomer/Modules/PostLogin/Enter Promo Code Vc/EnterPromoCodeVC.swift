//
//  EnterPromoCodeVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 18/07/24.
//

import UIKit
var codeID = 0
var codeTitle = ""
class EnterPromoCodeVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtFldEnterPromoCode: VCTextField!
    
    private var viewModel = VCRideVehiclesListViewModel()
    var selectedRegions: Regions?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFldEnterPromoCode.delegate = self
    }
    
    func promoApi(){
        var parmas = [String: Any]()
        parmas["code"] = txtFldEnterPromoCode.text ?? ""
        viewModel.promoCodeApi(parms: parmas) {
            codeID = self.viewModel.objPromoModal?.data?.codeId ?? 0
            codeTitle = self.viewModel.objPromoModal?.data?.promo_code ?? ""
            self.dismiss(animated: true,completion: {
                NotificationCenter.default.post(name: .viewControllerDismissed, object: nil)
                Proxy.shared.displayStatusCodeAlert(self.viewModel.objPromoModal?.data?.codeMessage ?? "", title: "Promo Code")
            })
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        txtFldEnterPromoCode.resignFirstResponder()
        view.resignFirstResponder()
        if txtFldEnterPromoCode.text == ""  {
            SKToast.show(withMessage: "Please enter promo code.")
          //  Proxy.shared.displayStatusCodeAlert("Please enter promo code.", title: "Promo Code")
        }else{
            promoApi()
        }
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // if textField == userNameTF{
            if (string == " ") {
                return false
            }
       // }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
