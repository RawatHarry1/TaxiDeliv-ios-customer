//
//  VCPromoCell.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VCPromoCell: UITableViewCell {
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    var didPressApply: (()->Void)?
    var comesFromAccount : Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnApplyAction(_ sender: Any) {
        self.didPressApply!()
    }
    
}
