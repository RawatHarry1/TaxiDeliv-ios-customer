//
//  VCWalletTCPopUp.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VCWalletTCPopUp: VCBaseVC {

    var onAccept:((Bool) -> Void)?


    //  To create ViewModel
    static func create() -> VCWalletTCPopUp {
        let obj = VCWalletTCPopUp.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    @IBAction func btnAccept(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.onAccept?(true)
        }
    }
}
