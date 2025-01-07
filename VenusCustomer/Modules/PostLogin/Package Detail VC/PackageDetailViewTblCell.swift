//
//  PackageDetailViewTblCell.swift
//  VenusCustomer
//
//  Created by TechBuilder on 07/01/25.
//

import UIKit

class PackageDetailViewTblCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    var didPressAccept: (()->Void)?
    var didPressReject: (()->Void)?
    var deliveryPackages : DeliveryPackages?
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnAcceptAction(_ sender: Any) {
        self.didPressAccept!()
    }
    
    @IBAction func btnRejectAction(_ sender: Any) {
        self.didPressReject!()
    }
    
}
extension PackageDetailViewTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return deliveryPackages?.package_images_by_customer?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
        cell.imgViewImages.setImage( deliveryPackages?.package_images_by_customer?[indexPath.row] ?? "", placeHolder: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(58, 58)
    }
    
    
    
}

struct DeliveryPackageData: Codable {
    var quantity: String?
    var id: String?
    var type: String?
    var image: [String]?
    var package_size: String?
    var description: String?
}
