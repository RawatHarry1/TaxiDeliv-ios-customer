//
//  VCFeedbackVC.swift
//  VenusCustomer
//
//  Created by Amit on 12/07/23.
//

import UIKit

class VCFeedbackVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var feebackTV: UITextView!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starfour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!


    var viewModel = VCTripHistoryViewModel()
    var selectedTrip: TripHistoryDetails?
    var callBackRatingSuccess : ((Int) -> ())?
    var ratings = 5
    var viewcontrollerType = 1
    //  To create ViewModel
    static func create() -> VCFeedbackVC {
        let obj = VCFeedbackVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        feebackTV.textContainerInset = UIEdgeInsets.zero
        feebackTV.textContainer.lineFragmentPadding = 0

//        feebackTV.backgroundColor = UIColor.lightGray
        feebackTV.textColor = VCColors.textColorGrey.color
        feebackTV.text = "Share feedback with driver."
        feebackTV.delegate = self
//        descLbl.text = "How was your ride with \(selectedTrip?.driver_name ?? "")"
        titleLabelAttributes((selectedTrip?.driver_name ?? ""))
        callBacks()
        ratingLbl.text = "Best"
    }

    private func callBacks() {
        viewModel.successCallBack = { status in
            self.dismiss(animated: true) {
                if self.viewcontrollerType == 1 {
                    self.callBackRatingSuccess?(self.ratings)
                } else {
                    VCRouter.goToSaveUserVC()
                }
            }
        }
    }

    func titleLabelAttributes(_ clickAble: String) {
        let clickAble = clickAble
        let fullText = "How was your trip with \(clickAble)"
        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 24.0, weight: .semibold), range: rangeClickableText)
        descLbl.attributedText = attributedString
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        if self.viewcontrollerType == 1 {
            self.dismiss(animated: true)
        } else {
            VCRouter.goToSaveUserVC()
        }
    }

    @IBAction func starOneBtn(_ sender: UIButton) {
        setStarImages(1)
        ratings = 1
    }
    
    @IBAction func starTwoBtn(_ sender: UIButton) {
        setStarImages(2)
        ratings = 2
    }
    
    @IBAction func starThreeBtn(_ sender: Any) {
        setStarImages(3)
        ratings = 3
    }

    @IBAction func starFourBtn(_ sender: Any) {
        setStarImages(4)
        ratings = 4
    }
    
    @IBAction func starFiveBtn(_ sender: Any) {
        setStarImages(5)
        ratings = 5
    }
    

    @IBAction func btnSubmit(_ sender: Any) {
        var feeback = feebackTV.text ?? ""
        if feebackTV.text == "Share feedback with driver." {
            feeback = ""
        }

//        if feeback == "" {
//            SKToast.show(withMessage: "Please enter feedback.")
//            return
//        }
        var params : JSONDictionary {
            let att: [String:Any] = [
                "feedback": feeback,
                "feedbackReasons": "testing",
                "givenRating": ratings,
                "engagementId": selectedTrip?.engagement_id ?? 0,
            ] as [String : Any]
            return att
        }
        viewModel.rateDriver(params)
    }

    @IBAction func btnSkip(_ sender: Any) {
        if self.viewcontrollerType == 1 {
            self.dismiss(animated: true)
        } else {
            VCRouter.goToSaveUserVC()
        }
    }
    

    func setStarImages(_ count: Int) {

        starOne.image = VCImageAsset.star.asset
        starTwo.image = VCImageAsset.star.asset
        starThree.image = VCImageAsset.star.asset
        starfour.image = VCImageAsset.star.asset
        starFive.image = VCImageAsset.star.asset

//        1 Star- Worst
//        2 Star- Bad
//        3 Star- Good
//        4 Star- Better
//        5 Star- Best

        if count == 1 {
            starTwo.image = VCImageAsset.starDisable.asset
            starThree.image = VCImageAsset.starDisable.asset
            starfour.image = VCImageAsset.starDisable.asset
            starFive.image = VCImageAsset.starDisable.asset
            ratingLbl.text = "Worst"
        } else if count == 2 {
            starThree.image = VCImageAsset.starDisable.asset
            starfour.image = VCImageAsset.starDisable.asset
            starFive.image = VCImageAsset.starDisable.asset
            ratingLbl.text = "Bad"
        } else if count == 3 {
            starfour.image = VCImageAsset.starDisable.asset
            starFive.image = VCImageAsset.starDisable.asset
            ratingLbl.text = "Good"
        } else if count == 4 {
            starFive.image = VCImageAsset.starDisable.asset
            ratingLbl.text = "Better"
        } else if count == 5 {
            starFive.image = VCImageAsset.starDisable.asset
            ratingLbl.text = "Best"
        }
    }

}

extension VCFeedbackVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VCColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VCColors.textColor.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share feedback with driver."
            textView.textColor = VCColors.textColorGrey.color
        }
    }
}
