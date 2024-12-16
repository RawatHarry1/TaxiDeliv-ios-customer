//
//  ReferralVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 06/08/24.
//

import UIKit

class ReferralVC: UIViewController {

    @IBOutlet weak var lblReferalCode: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgViewPhoto: UIImageView!
    
    static func create() -> ReferralVC {
        let obj = ReferralVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let obj = UserModel.currentUser.login?.referral_data
        if let urlStr = obj?.referral_image_d2c {
            self.imgViewPhoto.setImage(urlStr)
        }
        lblDesc.text = obj?.referral_message ?? ""
        lblReferalCode.text = UserModel.currentUser.login?.referral_code ?? ""
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnReferNowAction(_ sender: Any) {
        activityController()
    }
    
    @IBAction func btnActionCopy(_ sender: Any) {
        copyToClipboard(text: UserModel.currentUser.login?.referral_code ?? "")
    }
    
    func copyToClipboard(text: String) {
            UIPasteboard.general.string = text
            print("Text copied to clipboard: \(text)")
        SKToast.show(withMessage: "Referral code copied!")
    }
    
    func activityController(){
        let obj = UserModel.currentUser.login
        let text = "Hey, join \(Bundle.main.infoDictionary!["CFBundleName"] as! String) app using this referral code: \(obj?.referral_code ?? ""). Click here to download the app: \(obj?.referral_link ?? "")"
                
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
    }
}
