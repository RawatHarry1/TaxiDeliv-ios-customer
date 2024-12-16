//
//  VCLocationCell.swift
//  VenusCustomer
//
//  Created by AB on 09/11/23.
//

import UIKit

class VCLocationCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var locationTitleLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTitle(_ location: GooglePlacesModel) {
        locationTitleLbl.text = location.description ?? ""
    }
    
}
