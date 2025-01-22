//
//  VCLogoutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCThemeAlertVC: VCBaseVC {
   
    var didPressYesNo: ((Bool)->Void)?

    // MARK: -> Outlets
    @IBOutlet weak var popUpDescription: UILabel!
    var onboardingViewModel: VCLoginViewModel = VCLoginViewModel()
    private var accountViewModel: VCAccountViewModel = VCAccountViewModel()

    //  To create ViewModel
    static func create() -> VCThemeAlertVC {
        let obj = VCThemeAlertVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    var lblText = ""
    override func initialSetup() {
    }
    override func viewDidLoad() {
     
            popUpDescription.text = lblText
        
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.didPressYesNo?(false)
        }
    }

    @IBAction func logoutBtn(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.didPressYesNo?(true)
        }
      
        
    }
}
