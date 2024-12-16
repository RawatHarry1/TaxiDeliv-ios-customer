//
//  VCForgotPasswordVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VCForgotPasswordVC: VCBaseVC {


    @IBOutlet weak var emailTF: VCTextField!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCForgotPasswordVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        emailTF.addLeftView(VCImageAsset.message.asset)
        emailTF.roundCornerTF()
    }

    @IBAction func btnResetPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCCheckEmailVC.create(), animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
