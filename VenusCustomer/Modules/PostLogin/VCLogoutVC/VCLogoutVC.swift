//
//  VCLogoutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCLogoutVC: VCBaseVC {

    // MARK: -> Outlets
    var onboardingViewModel: VCLoginViewModel = VCLoginViewModel()

    //  To create ViewModel
    static func create() -> VCLogoutVC {
        let obj = VCLogoutVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    override func initialSetup() {
    }

    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func logoutBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        onboardingViewModel.logoutApi()
    }
}
