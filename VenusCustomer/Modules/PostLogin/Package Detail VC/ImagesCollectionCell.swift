//
//  ImagesCollectionCell.swift
//  VenusCustomer
//
//  Created by TechBuilder on 07/01/25.
//

import UIKit

class ImagesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?

}
