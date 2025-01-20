//
//  SignUpCompleteVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VCSignUpCompleteVC: VCBaseVC {

    @IBOutlet weak var imgTick: UIImageView!
    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCSignUpCompleteVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        imgTick.image = imgTick.image?.withRenderingMode(.alwaysTemplate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(VCTabbarVC.create(), animated: true)
        }
    }
}
