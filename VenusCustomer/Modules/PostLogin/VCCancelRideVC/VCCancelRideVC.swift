//
//  VCCancelRideVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VCCancelRideVC: VCBaseVC {

    var onConfirm:((Int) -> Void)?

    //  To create ViewModel
    static func create() -> VCCancelRideVC {
        let obj = VCCancelRideVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    @IBAction func btnNo(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(0)
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(1)
        }
    }
}
