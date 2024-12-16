//
//  VCWelcomeVC.swift
//  VenusCustomer
//
//  Created by Amit on 07/06/23.
//

import UIKit

class VCWelcomeVC: VCBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var signUpLabel: TTAttributedLabel!

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var attributedString = NSMutableAttributedString()
    let fullText = "Don’t have an account? Sign Up"

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCWelcomeVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        
        lblTitle.text = ClientModel.currentClientData.walk_through_title ?? ""
        lblDescription.text = ClientModel.currentClientData.walk_through_desc ?? ""
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpSignUpLabel()
    }
}

// MARK: - IBActions
extension VCWelcomeVC {
    @IBAction func btnSignIn(_ sender: UIButton) {
        let vc = VCLoginVC.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnSignUp(_ sender: UIButton) {
        let vc = VCLoginVC.create()
        vc.isLogin = false
        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.pushViewController(VCSignUpVC.create(), animated: true)
    }
}

// MARK: - Set sign up label
extension VCWelcomeVC: TTTAttributedLabelDelegate {

    func setUpSignUpLabel() {
        let clickAble = "Sign up"

        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : VCColors.textColorGrey.color], range: NSRange(location: 0, length: fullText.count))

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: VCColors.signupColor.color.cgColor, range: rangeClickableText)
//        signUpLabel.addLink(toAddress: [AnyHashable : Any](), with: rangeClickableText)
        signUpLabel.attributedText = attributedString
//        signUpLabel.delegate = self
    }

    func pushToView(){
//        self.navigationController?.pushViewController(VCSignUpVC.create(), animated: true)
    }

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithAddress addressComponents: [AnyHashable : Any]!) {
        pushToView()
    }
}
