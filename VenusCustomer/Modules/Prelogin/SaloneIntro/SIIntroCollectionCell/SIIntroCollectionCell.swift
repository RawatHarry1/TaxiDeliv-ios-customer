//
//  SIIntroCollectionCell.swift
//  VenusDriver
//
//  Created by Amit on 22/07/23.
//

import UIKit

class SIIntroCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var introImg: UIImageView!

    var images = [VCImageAsset.saloneIntro1.asset, VCImageAsset.saloneIntro2.asset, VCImageAsset.saloneIntro3.asset ]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUIWithData(index: Int) {
        introImg.image = images[index]
    }
}
