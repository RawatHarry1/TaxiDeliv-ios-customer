//
//  VCFAQVC.swift
//  VenusCustomer
//
//  Created by Amit on 07/07/23.
//

import UIKit

class VCFAQVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var faqTableView: UITableView!

    // MARK: -> Variables
    var indexSelection = -1
    var informationUrls: InformationURLModel?
    //  To create ViewModel
    static func create() -> VCFAQVC {
        let obj = VCFAQVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.register(UINib(nibName: "VCFAQCell", bundle: nil), forCellReuseIdentifier: "VCFAQCell")
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func selectionAction(_ button: UIButton) {
        indexSelection == button.tag ? (indexSelection = -1) : (indexSelection = button.tag)
        faqTableView.reloadData()
    }
}

extension VCFAQVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.informationUrls?.faq?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCFAQCell", for: indexPath) as! VCFAQCell
        cell.lblTitle.text = self.informationUrls?.faq?[indexPath.row].Ques ?? ""
        cell.descLabel.text = self.informationUrls?.faq?[indexPath.row].Ans ?? ""
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.addTarget(self, action: #selector(selectionAction(_ :)), for: .touchUpInside)
        cell.setUpUI(indexSelection != indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
