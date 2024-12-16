//
//  VCNotificationCell.swift
//  VenusCustomer
//
//  Created by Amit on 30/06/23.
//

import UIKit

class VCNotificationCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(_ notification: NotificationDetails) {
        titleLbl.text = notification.title ?? ""
        lblDescription.text = notification.message ?? ""
        
        
        lblDate.text = notification.time_sent?.utcToLocal()
    }
}
