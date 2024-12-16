//
//  VCIntoCollectionViewCell.swift
//  VenusCustomer
//
//  Created by Amit on 30/06/23.
//

import UIKit

class VCIntoCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak private(set) var imgView: UIImageView!
    @IBOutlet weak private(set) var lblTitle: UILabel!
    @IBOutlet weak private(set) var lblSubTitle: UILabel!

    // MARK: - Variables
    var images = [VCImageAsset.introFirst.asset, VCImageAsset.introSecond.asset, VCImageAsset.introThird.asset,  VCImageAsset.introForth.asset ]
    var titles = ["Find An EV Close To You", "Go Green!", "Arrive In Style", "Enable Your Location"]
    var firstSubtitle = "The environmentally-friendly way to get around town"
    var secondSubtitle = "Save money while saving the planet"
    var thirdSubtitle = "Our service offers only the latest electric vehicles."
    var forthSubtitle = "Turn on location services in your device settings"
    var subtitle = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        subtitle = [firstSubtitle, secondSubtitle, thirdSubtitle, forthSubtitle]
    }

    func updateUIWithData(index: Int) {
        imgView.image = images[index]
        lblTitle.text = titles[index]
        lblSubTitle.text = subtitle[index]
    }

}
