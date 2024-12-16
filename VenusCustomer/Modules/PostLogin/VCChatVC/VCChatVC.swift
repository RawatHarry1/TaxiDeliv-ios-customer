//
//  VCChatVC.swift
//  VenusCustomer
//
//  Created by Amit on 16/07/23.
//

import UIKit


class VCChatVC: VCBaseVC {

    @IBOutlet weak var navShadowView: UIView!
    @IBOutlet weak var messageTV: UITextView!

   
    //  To create ViewModel
    static func create() -> VCChatVC {
        let obj = VCChatVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

    override func initialSetup() {
        messageTV.textColor = VCColors.textColorGrey.color
        messageTV.text = "Type a message..."
        messageTV.delegate = self
        messageTV.resignFirstResponder()
        view.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageTV.resignFirstResponder()
        view.resignFirstResponder()
    }
    
   

    override func viewDidLayoutSubviews() {
        navShadowView.addShadowView()
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VCChatVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VCColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VCColors.textColor.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type a message..."
            textView.textColor = VCColors.textColorGrey.color
        }
    }
}

