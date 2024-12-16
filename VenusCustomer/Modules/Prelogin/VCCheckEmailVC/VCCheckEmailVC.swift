//
//  VCCheckEmailVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/06/23.
//

import UIKit

class VCCheckEmailVC: VCBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCCheckEmailVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {

    }

    @IBAction func btnResetPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCResetPasswordVC.create(), animated: true)
    }
}
