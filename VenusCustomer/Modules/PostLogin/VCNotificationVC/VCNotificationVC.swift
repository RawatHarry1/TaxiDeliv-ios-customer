//
//  VCNotificationVC.swift
//  VenusCustomer
//
//  Created by Amit on 30/06/23.
//

import UIKit

class VCNotificationVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!

    var notificationViewModel: VCNotificationViewModel = VCNotificationViewModel()
    var notificationList = [NotificationDetails]()

    //  To create ViewModel
    static func create() -> VCNotificationVC {
        let obj = VCNotificationVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(UINib(nibName: "VCNotificationCell", bundle: nil), forCellReuseIdentifier: "VCNotificationCell")
        notificationViewModel.fetchNotificationList()

        notificationViewModel.notificationListSuccessCallBack = { list in
            self.notificationList = list
            self.notificationTableView.reloadData()
        }
    }

    @IBAction func btnSideMenu(_ sender: Any) {

    }
}

extension VCNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLbl.isHidden = (notificationList.count != 0)
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCNotificationCell", for: indexPath) as? VCNotificationCell
        cell?.updateCell(notificationList[indexPath.row])
        return cell ?? UITableViewCell()
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 74
//    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}
