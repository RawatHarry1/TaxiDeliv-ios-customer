//
//  VCLogoutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCLogoutVC: VCBaseVC {
   

    // MARK: -> Outlets
    @IBOutlet weak var popUpDescription: UILabel!
    var onboardingViewModel: VCLoginViewModel = VCLoginViewModel()
    private var accountViewModel: VCAccountViewModel = VCAccountViewModel()

    //  To create ViewModel
    static func create() -> VCLogoutVC {
        let obj = VCLogoutVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    var deleteAccount : Bool = false
    override func initialSetup() {
    }
    override func viewDidLoad() {
        if  (deleteAccount == true)
        {
            popUpDescription.text = "Are you sure you want to delete account?"
        }
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func logoutBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        if  (deleteAccount == true)
        {
            self.accountViewModel.deleteAccount(parms: [:]) {
                codeTitle = ""
                codeID = 0
                promoCodeID = 0
                promoTitle = ""
                
                VCUserDefaults.removeAllValues()
                VCRouter.loadPreloginScreen()
            }
        }else
        {
            onboardingViewModel.logoutApi()
        }
        
    }
}
