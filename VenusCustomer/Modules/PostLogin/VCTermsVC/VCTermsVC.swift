//
//  VCTermsVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCTermsVC: VCBaseVC {

    // MARK: -> Oulets

    
    override func initialSetup() {
        
    }
    //  To create ViewModel
    static func create() -> VCTermsVC {
        let obj = VCTermsVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
