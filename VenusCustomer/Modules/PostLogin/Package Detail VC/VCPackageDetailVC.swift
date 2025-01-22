//
//  VCPackageDetailVC.swift
//  VenusCustomer
//
//  Created by TechBuilder on 07/01/25.
//

import UIKit

class VCPackageDetailVC: UIViewController, CollectionViewCellDelegate {

    var deliveryPackages: [DeliveryPackages] = []
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnClose.setTitle("", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if tblView.numberOfRows(inSection: 0) < 3
        {
            tblView.reloadData()
            tblView.layoutIfNeeded()
            heightTblView.constant = tblView.contentSize.height

        }
    }
    static func create() -> VCPackageDetailVC {
        let obj = VCPackageDetailVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }

 
    @IBAction func closeButtonAct(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func didSelectItem(url: String) {
        var storyboardMain = UIStoryboard(name: "PostLogin", bundle: nil)
         
        let detailVC = storyboardMain.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        detailVC.url = url
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
    
}
extension VCPackageDetailVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryPackages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailViewTblCell", for: indexPath) as! PackageDetailViewTblCell
        cell.lblSize.text =  deliveryPackages[indexPath.row].package_size
        cell.lblPackageType.text =  deliveryPackages[indexPath.row].package_type
        cell.delegate = self
        cell.lblQuantity.text =  String(describing: deliveryPackages[indexPath.row].package_quantity ?? 0)
        cell.deliveryPackages = deliveryPackages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
        //    self.tblHeightConstant.constant = self.tblView.contentSize.height
        }
    }
}

