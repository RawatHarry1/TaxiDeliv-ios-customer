//
//  AddressTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 12/06/24.
//

import UIKit

class AddressTblCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var didPressCell: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnAction(_ sender: Any) {
        
        self.didPressCell!()
    }
}
