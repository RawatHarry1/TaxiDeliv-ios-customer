//
//  GoodsVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 16/08/24.
//

import UIKit

class GoodsVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var goods:((String,Int) -> Void)?
    var goodsArr = ["Timber / Plywood / Laminate",
                    "Electrical / Electronics / Home Appliances",
                    "Building / Construction",
                    "Catering / Restaurant / Event Management",
                    "Machines / Equipments / Spare Parts",
                    "General",
                    "House Shifting",
                    "Perishable food items",
                    "Plastic / Rubber",
                    "Books / Stationery / Toys",
                    "House Shifting",
                    "Chemicals / Paints"]
    
    var selectedIndex = -1
    var selectedGood = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if selectedGood == ""{
            SKToast.show(withMessage: "Please select Goods.")
        }else{
            self.dismiss(animated: true, completion: {
                self.goods!(self.selectedGood, self.selectedIndex)
            })
        }
       
    }
}
extension GoodsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTblCell", for: indexPath) as! GoodsTblCell
        
        cell.lblGoods.text = goodsArr[indexPath.row]
        
        if selectedIndex == indexPath.row{
            selectedGood = goodsArr[indexPath.row]
            cell.lblGoods.textColor = .black
        }else{
            cell.lblGoods.textColor = .systemGray2
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tblView.reloadData()
    }
    
}
