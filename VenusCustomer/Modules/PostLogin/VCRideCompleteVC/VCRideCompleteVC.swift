//
//  VCRideCompleteVC.swift
//  VenusCustomer
//
//  Created by Amit on 17/07/23.
//

import UIKit

class VCRideCompleteVC: VCBaseVC {


    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var smallDashedView: UIView!

    //  To create ViewModel
    static func create() -> VCRideCompleteVC {
        let obj = VCRideCompleteVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func viewDidLayoutSubviews() {
        dashedView.addDashedBorder()
        smallDashedView.addDashedSmallBorder()
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }


}
