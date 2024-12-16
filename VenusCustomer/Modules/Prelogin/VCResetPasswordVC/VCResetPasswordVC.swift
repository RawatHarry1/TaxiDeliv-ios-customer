//
//  VCResetPasswordVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/06/23.
//

import UIKit

class VCResetPasswordVC: VCBaseVC {

    @IBOutlet weak var confirmPassTF: VCTextField!
    @IBOutlet weak var newPassTF: VCTextField!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCResetPasswordVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        confirmPassTF.addLeftView(VCImageAsset.pass.asset)
        newPassTF.addLeftView(VCImageAsset.pass.asset)
        newPassTF.roundCornerTF()
        confirmPassTF.roundCornerTF()

    }

    @IBAction func btnUpdatePassword(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
