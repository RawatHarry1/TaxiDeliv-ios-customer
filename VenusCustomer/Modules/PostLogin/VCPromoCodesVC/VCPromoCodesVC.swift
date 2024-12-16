//
//  VCPromoCodesVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
var promoCodeID = 0
var promoTitle = ""
class VCPromoCodesVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var promoTableView: UITableView!
    var objViewModal = promoCodeVM()
//    var lat = 0.0
//    var long = 0.0
    var isComesFromAccount = true
    var isUpdateOnce = true
    var didPressApply: ((String)->Void)?
    var promoIsApply = true
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
        if lat != 0{
           // let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            self.lat = lat
//            self.long = long
            
            if isUpdateOnce == true{
                isUpdateOnce = false
                self.objViewModal.promoCodeAPi(lat: lat, long: long) {
                    self.promoTableView.reloadData()
                }
            }
           
        }
    }

    @objc func handleNotification(_ notification: Notification) {
           if let userInfo = notification.userInfo as? [String: String] {
               let value = userInfo["key"]
               print("Notification received with value: \(value ?? "No value")")
           }
       }
    
    //  To create ViewModel
    static func create() -> VCPromoCodesVC {
        let obj = VCPromoCodesVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        //promoTableView.rowHeight = 380
        promoTableView.delegate = self
        promoTableView.dataSource = self
        promoTableView.register(UINib(nibName: "VCPromoCell", bundle: nil), forCellReuseIdentifier: "VCPromoCell")
      
       
        
    }
    
    func getPromocodeApi(){
        
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VCPromoCodesVC : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objViewModal.objPromocodeModal?.data?.promotions?.count ?? 0 > 0{
            self.lblDataFound.isHidden = true
        }else{
            self.lblDataFound.isHidden = false
        }
        return objViewModal.objPromocodeModal?.data?.promotions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCPromoCell", for: indexPath) as! VCPromoCell
        let obj  = objViewModal.objPromocodeModal?.data?.promotions?[indexPath.row]
        cell.lblCode.text = obj?.title ?? ""
        cell.lblDesc.text = "\(obj?.validity_text ?? "")"
//        if self.isComesFromAccount == true{
//            cell.btnApply.isHidden = true
//        }else{
//            cell.btnApply.isHidden = false
//        }
        if promoCodeID == obj?.promo_id{
            promoIsApply = false
            cell.btnApply.setTitle("Remove", for: .normal)
            cell.btnApply.backgroundColor = .systemRed
        }else{
            promoIsApply = true
            cell.btnApply.setTitle("Apply", for: .normal)
            cell.btnApply.backgroundColor = UIColor(named: "buttonSelectedOrange")
        }
        cell.didPressApply = {

            if promoCodeID == obj?.promo_id{
                promoCodeID =  0
                promoTitle =  ""
            }else{
                promoCodeID = obj?.promo_id ?? 0
                promoTitle = obj?.title ?? ""
                self.displayStatusCodeAlert("*This offer will be automatically applied while creating the ride*")
            }
            
            self.promoTableView.reloadData()
           
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func displayStatusCodeAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            VCRouter.goToSaveUserVC()
            //self.navigationController?.pushViewController(VCTabbarVC.create(), animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func addDottedBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2] // Dash pattern: 2 points filled, 2 points unfilled
        
        let path = CGMutablePath()
        path.addRoundedRect(in: self.bounds, cornerWidth: 10, cornerHeight: 10)
        shapeLayer.path = path
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = nil // If you don't want the view to be filled

        self.layer.addSublayer(shapeLayer)
    }
}
