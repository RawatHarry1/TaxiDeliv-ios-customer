//
//  VCAboutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VCAboutVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var aboutTableView: UITableView!

    //  To create ViewModel
    static func create() -> VCAboutVC {
        let obj = VCAboutVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutTableView.register(UINib(nibName: "", bundle: nil), forHeaderFooterViewReuseIdentifier: "")
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VCAboutVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as?
        return UITableViewCell()
    }
}
