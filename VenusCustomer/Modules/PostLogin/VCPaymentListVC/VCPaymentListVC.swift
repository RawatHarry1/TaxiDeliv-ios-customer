//
//  VCPaymentListVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VCPaymentListVC: VCBaseVC {

    @IBOutlet weak var paymentTableView: UITableView!

    //  To create ViewModel
    static func create() -> VCPaymentListVC {
        let obj = VCPaymentListVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(UINib(nibName: "VCCardDetailCell", bundle: nil), forCellReuseIdentifier: "VCCardDetailCell")

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension VCPaymentListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCCardDetailCell", for: indexPath) as! VCCardDetailCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
