//
//  VCCancelReasonVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VCCancelReasonVC: VCBaseVC {

    @IBOutlet weak var cancelTableView: UITableView!
    @IBOutlet weak var reasonTV: UITextView!

    var selectedReason : ((String) -> ()) = {_ in}
    private var viewModel = VCCancelReasonViewModel()
    var rideRequestDetails: RequestRideData?
    var sessionID = 0
    //  To create ViewModel
    static func create() -> VCCancelReasonVC {
        let obj = VCCancelReasonVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    var selectedReasonIndex = -1

    override func initialSetup() {
        cancelTableView.delegate = self
        cancelTableView.dataSource = self
        cancelTableView.register(UINib(nibName: "VCCancelReasonCell", bundle: nil), forCellReuseIdentifier: "VCCancelReasonCell")

        reasonTV.textContainerInset = UIEdgeInsets.zero
        reasonTV.textContainer.lineFragmentPadding = 0

//        feebackTV.backgroundColor = UIColor.lightGray
        reasonTV.textColor = VCColors.textColorGrey.color
        reasonTV.text = "Please Specify your reason"
        reasonTV.delegate = self
    }

    @objc func selectReasonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        setPlaceHolderText()
        if selectedReasonIndex == sender.tag {
            selectedReasonIndex = -1
        } else {
            selectedReasonIndex = sender.tag
        }
        cancelTableView.reloadData()
    }

    @IBAction func btnNo(_ sender: VDButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func canceRideBtn(_ sender: Any) {
        if selectedReasonIndex == -1 && (((reasonTV.text ?? "").trimmed == "") || (reasonTV.text ?? "").trimmed == "Please Specify your reason") {
            SKToast.show(withMessage: "Please Specify your reason")
            return
        } else if selectedReasonIndex == -1 {
            if (((reasonTV.text ?? "").trimmed == "") || (reasonTV.text ?? "").trimmed == "Please Specify your reason") {
                SKToast.show(withMessage: "Please Specify your reason")
                return
            } else {
                self.cancelRideRequest(reasonTV.text ?? "")
//                self.selectedReason(reasonTV.text ?? "")
            }
        } else {
            guard let reasons = UserModel.currentUser.login?.cancellation_reasons else {
                SKToast.show(withMessage: "Please Specify your reason")
                return
            }
            self.cancelRideRequest(reasons[selectedReasonIndex])
//            self.selectedReason(reasons[selectedReasonIndex])
        }
    }

    private func cancelRideRequest(_ reason: String) {
        if sessionID == 0{
            viewModel.cancelRideApi(rideRequestDetails?.session_id ?? 0, reasonTV.text ?? "")
        }else{
            viewModel.cancelRideApi(sessionID, reasonTV.text ?? "")
        }
      
    }
}

extension VCCancelReasonVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reasons = UserModel.currentUser.login?.cancellation_reasons else {return 0}
        return reasons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCCancelReasonCell", for: indexPath) as! VCCancelReasonCell
        cell.updateCellUI(index: indexPath.row)
        cell.btnSelection.addTarget(self, action: #selector(selectReasonAction(_:)), for: .touchUpInside)
        cell.btnSelection.tag = indexPath.row
        if selectedReasonIndex == indexPath.row {
            cell.selectionImg.image = VCImageAsset.checkBoxOrange.asset
        } else {
            cell.selectionImg.image = VCImageAsset.unchecked.asset
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VCCancelReasonVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VCColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VCColors.textColor.color
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        selectedReasonIndex = -1
        cancelTableView.reloadData()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Specify your reason"
            textView.textColor = VCColors.textColorGrey.color
        }
    }

    func setPlaceHolderText() {
        self.reasonTV.text = "Please Specify your reason"
        self.reasonTV.textColor = VCColors.textColorGrey.color
    }
}
