//
//  VCRideVehicleCell.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit
import SDWebImage
class VCRideVehicleCell: UITableViewCell {

    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var originalFare: UILabel!
    @IBOutlet weak var oldOfferLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var awayTimeLbl: UILabel!
    @IBOutlet weak var seatsAvailableLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var finalPriceLbl: UILabel!
    
    var customerETA : etaData?
    let currentDate = Date()
    let currentTime = Date()
    let timeFormatter = DateFormatter()
    var timeString = ""
    var objOperator_availablity : operator_availablityy?
    // Set the desired time format
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        timeFormatter.dateFormat = "HH:mm"

        // Convert the time to a string
        self.timeString = timeFormatter.string(from: currentTime)
        print("Current time: \(timeString)")
        // Initialization code
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "58.27$")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))

        oldOfferLbl.attributedText = attributeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpVehicleUI(_ region: Regions, _ isSelected: Bool) {
        if let _ = region.eta {
            baseView.layer.opacity = 1.0
        } else {
            baseView.layer.opacity = 0.5
        }

        if isSelected {
            baseView.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
            baseView.layer.borderWidth = 1
        } else {
            baseView.layer.borderColor = UIColor.clear.cgColor
            baseView.layer.borderWidth = 0

            baseView.addShadowView(radius: 0, color: .clear)
        }

        if let urlStr = region.images?.ride_now_normal_2x {
            self.iconImg.setImage(urlStr, showIndicator: true)
            iconImg.sd_setImage(with: URL(string: urlStr) , placeholderImage: UIImage(named: "Ujeff Customers"), options: [.refreshCached, .highPriority], completed: nil)

        }
        var sum = 0.0
        
        if region.region_fare?.discount ?? 0 > 0{
            originalFare.isHidden = false
            lblLine.isHidden = false
            originalFare.text = "\(region.region_fare?.currency ?? "") \(region.region_fare?.original_fare ?? 0)"
        }else{
            lblLine.isHidden = true
            originalFare.isHidden = true
        }
        
        if self.objOperator_availablity?.id ?? 0 == 1{
            seatsAvailableLbl.text = "\(region.max_people ?? 0)"
            self.imgViewIcon.image = UIImage(named: "userPlaceHolder")
        }else{
            seatsAvailableLbl.text = "\(region.max_people ?? 0) Kg"
            self.imgViewIcon.image = UIImage(named: "kg")
        }
        
        finalPriceLbl.text = "\(region.region_fare?.currency ?? "") \(region.region_fare?.fare ?? 0)"
        
        awayTimeLbl.text = "\(region.eta ?? 0) \((region.eta ?? 0) > 1 ? "mins" : "min") away"
        titleLbl.text = region.region_name ?? ""
        descLbl.text = region.vehicle_desc ?? ""
        if let first = region.eta, let second = customerETA?.rideTime {
                sum = first + second
        }else{
            awayTimeLbl.text = "\(region.eta ?? 0) \((region.eta ?? 0) > 1 ? "mins" : "min") away"
        }
        
        if let newDate = Calendar.current.date(byAdding: .minute, value: Int(sum), to: currentDate) {
                    // Display the new time
                    let newTimeString =  convertTo12HourTime(from: timeFormatter.string(from: newDate))
            awayTimeLbl.text = "\(newTimeString ?? "") | \(region.eta ?? 0) \((region.eta ?? 0) > 1 ? "mins" : "min") away"
           
        }
    }
}
