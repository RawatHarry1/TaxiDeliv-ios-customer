//
//  VCWalletVC.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VCWalletVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var lblNoTransactionFound: UILabel!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var objWalletVM = WalletHistoryViewModal()
    var amount = ""
    var ohjGetCardData : GetCardData?
    //  To create ViewModel
    static func create() -> VCWalletVC {
        let obj = VCWalletVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        print(UserModel.currentUser.login?.wallet_balance ?? 0.0)
        walletTableView.delegate = self
        walletTableView.dataSource = self
        walletTableView.register(UINib(nibName: "VCWalletCell", bundle: nil), forCellReuseIdentifier: "VCWalletCell")
        walletTableView.register(UINib(nibName: "VCWalletHeaderCell", bundle: nil), forCellReuseIdentifier: "VCWalletHeaderCell")
        
        getWalletApi()
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnTopUp(_ sender: UIButton) {
        let vc = VCTopUPPopVC.create()
        vc.modalPresentationStyle = .overFullScreen
        vc.parseAmountToAdd = { amount in
            self.amount = amount
            let vc = CardsVC.create()
            vc.comesFromAccount = false
            vc.didPressSelecrCard = { selectedCardData in
                self.ohjGetCardData = selectedCardData
                let vc = VCThemeAlertVC.create()
                vc.lblText = "Are you sure you want to use **** \(selectedCardData.last_4 ?? "") card for top up?"
                vc.modalPresentationStyle = .overFullScreen
                vc.didPressYesNo = { useCard in
                    if useCard == true
                    {
                        self.objWalletVM.addAmountApi(cardID: self.ohjGetCardData?.card_id ?? "", amount: self.amount,currency:UserModel.currentUser.login?.currency_symbol ?? "") {
                            self.getWalletApi()
                        }
                    }
                }
                self.navigationController?.present(vc, animated: true)

//              self.addMoneyAlert(cardNo: selectedCardData.last_4 ?? "")
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.present(vc, animated: true)
//        self.navigationController?.present(vc, animated: true)
    }
    
    func addMoneyAlert(cardNo:String){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to use **** \(cardNo) card for top up?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.objWalletVM.addAmountApi(cardID: self.ohjGetCardData?.card_id ?? "", amount: self.amount,currency:UserModel.currentUser.login?.currency_symbol ?? "") {
                self.getWalletApi()
            }
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getWalletApi(){
        objWalletVM.walletHistoryApi {
            let obj = self.objWalletVM.objWalletModal?.data
            self.lblWalletBalance.text = "\(obj?.currency ?? "") \(obj?.balance ?? 0)"
            self.lblName.text = obj?.user_name ?? ""
            self.walletTableView.reloadData()
        }
    }
}

extension VCWalletVC: UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if self.objWalletVM.objWalletModal?.data?.transactions?.isEmpty == true
        {
            lblNoTransactionFound.isHidden = false
        }
        else
        {
            lblNoTransactionFound.isHidden = true
        }
        return objWalletVM.objWalletModal?.data?.transactions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCWalletCell", for: indexPath) as! VCWalletCell
        let obj = objWalletVM.objWalletModal?.data?.transactions?[indexPath.row]
        
        cell.lblTime.text = obj?.txn_time ?? ""
        cell.lblDate.text = obj?.txn_date ?? ""
        cell.lblAmount.text = "\(objWalletVM.objWalletModal?.data?.currency ?? "") \(obj?.amount ?? 0)"
        if obj?.txn_type == "Debited"{
            cell.lblAmoundAdded.text = "Amount Debited"
            cell.lblAmount.textColor = .systemRed
        }else{
            cell.lblAmoundAdded.text = "Amount Added"
            cell.lblAmount.textColor = .systemGreen
        }
        cell.lblProcessNumber.text = "\(obj?.txn_id ?? 0)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCWalletHeaderCell") as! VCWalletHeaderCell
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
