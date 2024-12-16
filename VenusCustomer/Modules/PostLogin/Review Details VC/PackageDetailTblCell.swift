//
//  PackageDetailTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/11/24.
//

import UIKit

class PackageDetailTblCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    var didPressEdit: (()->Void)?
    var didPressDlt: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnEditAction(_ sender: Any) {
        self.didPressEdit!()
    }
    
    @IBAction func btnDltAction(_ sender: Any) {
        self.didPressDlt!()
    }
    
}
