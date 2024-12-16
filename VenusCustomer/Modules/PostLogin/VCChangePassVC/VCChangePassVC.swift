//
//  VCChangePassVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VCChangePassVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var currentPassTF: UITextField!
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!

    //  To create ViewModel
    static func create() -> VCChangePassVC {
        let obj = VCChangePassVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmit(_ sender: UIButton) {

    }
}
