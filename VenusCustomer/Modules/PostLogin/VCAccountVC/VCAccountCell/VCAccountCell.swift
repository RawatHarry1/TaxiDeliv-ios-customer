//
//  VCAccountCell.swift
//  VenusCustomer
//
//  Created by Amit on 07/07/23.
//

import UIKit

class VCAccountCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
  //
  //
    var images = [VCImageAsset.changePass.asset,VCImageAsset.offers.asset,VCImageAsset.creditCard.asset,VCImageAsset.wallet.asset,VCImageAsset.reffral.asset,  VCImageAsset.faq.asset, VCImageAsset.aboutUs.asset, VCImageAsset.terms.asset, VCImageAsset.logout.asset,VCImageAsset.delete.asset]
    var titles = ["Change Password", "Offers","Cards","Wallet", "Referral", "FAQ’s", "About app", "Terms & Conditions", "Log Out","Delete Account"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpUI(_ index: Int) {
        titleImage.image = images[index]
        titleLabel.text = titles[index]
    }
}
