//
//  VCSignUpVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VCSignUpVC: VCBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCSignUpVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCOtpVC.create(), animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignIn(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCLoginVC.create(), animated: true)
    }
}
