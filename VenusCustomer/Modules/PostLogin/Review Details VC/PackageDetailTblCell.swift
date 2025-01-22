//
//  PackageDetailTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/11/24.
//

import UIKit
protocol CollectionViewCellDelegate: AnyObject {
    func didSelectItem(url: String)
}

class PackageDetailTblCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var pickUpImageView: UIStackView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var collectionViewCustomer: UICollectionView!
    @IBOutlet weak var collectionViewPickup: UICollectionView!
    @IBOutlet weak var collectionViewDelivery: UICollectionView!
  
    @IBOutlet weak var deliveryImageView: UIStackView!
    var didPressEdit: (()->Void)?
    var didPressDlt: (()->Void)?
    var delivery_packages: deliveryPackagesD?
    weak var delegate: CollectionViewCellDelegate?
    var tableViewIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
        if collectionViewCustomer != nil{
            collectionViewCustomer.delegate = self
            collectionViewCustomer.dataSource = self
            
            collectionViewPickup.delegate = self
            collectionViewPickup.dataSource = self
            
            collectionViewDelivery.delegate = self
            collectionViewDelivery.dataSource = self
        }
        
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
extension PackageDetailTblCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCustomer{
            return self.delivery_packages?.package_images_by_customer?.count ?? 0
        }else if collectionView == collectionViewPickup{
            return self.delivery_packages?.package_image_while_pickup?.count ?? 0
        }else{
            return self.delivery_packages?.package_image_while_drop_off?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCustomer{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellCustomer", for: indexPath) as! CollectionViewCellCustomer
            let urlStr = self.delivery_packages?.package_images_by_customer?[indexPath.row] ?? ""
            cell.imgViewCustomer.contentMode = .scaleAspectFill
            cell.imgViewCustomer.layer.cornerRadius = 5
            cell.imgViewCustomer.setImage(urlStr)
            return cell
        }else if collectionView == collectionViewPickup{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellPickup", for: indexPath) as! CollectionViewCellPickup
            let urlStr = self.delivery_packages?.package_image_while_pickup?[indexPath.row] ?? ""
            cell.imgViewPickup.layer.cornerRadius = 5
            cell.imgViewPickup.setImage(urlStr)
            cell.imgViewPickup.contentMode = .scaleAspectFill
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellDelivery", for: indexPath) as! CollectionViewCellDelivery
            cell.imgViewDelivery.layer.cornerRadius = 5
            let urlStr = self.delivery_packages?.package_image_while_drop_off?[indexPath.row] ?? ""
            cell.imgViewDelivery.contentMode = .scaleAspectFill

            cell.imgViewDelivery.setImage(urlStr)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //  guard let tableViewIndexPath = tableViewIndexPath else { return }
        
        if collectionView == collectionViewCustomer{
            
            let urlStr = self.delivery_packages?.package_images_by_customer?[indexPath.row] ?? ""
            
            delegate?.didSelectItem(url:urlStr)
        }else if collectionView == collectionViewPickup{
            
            let urlStr = self.delivery_packages?.package_image_while_pickup?[indexPath.row] ?? ""
            delegate?.didSelectItem(url:urlStr)
            
        }else{
            
            let urlStr = self.delivery_packages?.package_image_while_drop_off?[indexPath.row] ?? ""
            delegate?.didSelectItem(url:urlStr)
            
        }
        
    }
    
}
