//
//  VCAccountVC.swift
//  VenusCustomer
//
//  Created by Amit on 07/07/23.
//

import UIKit
import Kingfisher

class VCAccountVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    
    @IBOutlet weak var lblRatingCount: UILabel!
    private var accountViewModel: VCAccountViewModel = VCAccountViewModel()
    private var userData: UserProfileModel?

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCAccountVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.register(UINib(nibName: "VCAccountCell", bundle: nil), forCellReuseIdentifier: "VCAccountCell")
        callBacks()
        lblRatingCount.text = "\(UserModel.currentUser.login?.user_ratings ?? 0.0)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountViewModel.getAccountDetail()
    }
    
    func callBacks() {
        self.accountViewModel.successCallBack = { details in
            print(details)
            self.userData = details
            UserModel.currentUser.login?.user_name = self.userData?.name
            if let urlStr = details.user_image {
                self.imgProfile.setImage(urlStr)
            }
            self.userLbl.text = details.name ?? ""
        }
        
        self.accountViewModel.informationUrlsCallback = { information in
            if self.accountViewModel.pageType == 1{
                let vc = VCFAQVC.create()
                vc.informationUrls = information
                self.navigationController?.pushViewController(vc, animated: true)
              
            }else{
                let vc = VCAboutAppVC.create()
                vc.informationUrls = information
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
    }
    
    func deleteAccount(){
        deleteAccountAlert()
       
    }
    
    func deleteAccountAlert(){
        let refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete the Account?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.accountViewModel.deleteAccount(parms: [:]) {
                codeTitle = ""
                codeID = 0
                promoCodeID = 0
                promoTitle = ""
                
                VCUserDefaults.removeAllValues()
                VCRouter.loadPreloginScreen()
            }
           
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func openEditProfileBtn(_ sender: UIButton) {
        let vc = VCCreateProfileVC.create()
        vc.screenType = 1
        vc.userData = self.userData
        vc.comesFromAccount = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VCAccountVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VCAccountCell", for: indexPath) as! VCAccountCell
        cell.setUpUI(indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 0 }
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(VCChangePassVC.create(), animated: true)
        case 1:
            self.navigationController?.pushViewController(VCPromoCodesVC.create(), animated: true)
        case 2:
            let vc = CardsVC.create()
            vc.comesFromAccount = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
//            let vc = VCWalletTCPopUp.create()
//            vc.modalPresentationStyle = .overFullScreen
//            vc.onAccept = { status in
                self.navigationController?.pushViewController(VCWalletVC.create(), animated: true)
//            }
//            self.navigationController?.present(vc, animated: true)
            
        case 4:
            self.navigationController?.pushViewController(ReferralVC.create(), animated: true)
         case 5:
            accountViewModel.fetchUrlInformation(type: 1)
         case 6:
            accountViewModel.fetchUrlInformation(type: 2)
         case 7:
            guard let url = URL(string: ClientModel.currentClientData.terms_of_use_url ?? "") else { return }
            UIApplication.shared.open(url)
            //self.navigationController?.pushViewController(VCTermsVC.create(), animated: true)
         case 8:
            let vc = VCLogoutVC.create()
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        case 9:
            print("delete account")
            self.deleteAccount()
        default:
            break
        }
    }
}
