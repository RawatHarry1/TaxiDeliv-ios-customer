//
//  VCWalletCell.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VCWalletCell: UITableViewCell {

    @IBOutlet weak var lblAmoundAdded: UILabel!
    @IBOutlet weak var lblProcessNumber: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
