//
//  VCTripHistoryCell.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VCTripHistoryCell: UITableViewCell {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var pickUpLocationLbl: UILabel!
    @IBOutlet weak var dropLocationLbl: UILabel!
    @IBOutlet weak var pickUpTime: UILabel!
    @IBOutlet weak var dropTimeLbl: UILabel!
    
    var didPressCancel: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        self.didPressCancel!()
    }
    
    

    func SetUpUI(_ trip : TripHistoryModel) {
  //      dashedView.addDashedSmallBorder()
        baseView.addShadowView()

        pickUpLocationLbl.text = trip.pickup_address ?? ""
        dropLocationLbl.text = trip.drop_address ?? ""

        statusBtn.setTitle(trip.autos_status_text ?? "", for: .normal)
        if let hexColor = trip.autos_status_color {
            statusBtn.backgroundColor = hexStringToUIColor(hex: hexColor)
        }
        datelbl.text = ConvertDateFormater(date: trip.date ?? "")
        pickUpTime.text = ConvertTimeFormater(date: trip.pickup_time ?? "")
        dropTimeLbl.text = ConvertTimeFormater(date: trip.drop_time ?? "")
    }
    
    func SetUpUISchedule(_ trip : ScheduledData) {
    //    dashedView.addDashedSmallBorder()
        baseView.addShadowView()

        pickUpLocationLbl.text = trip.pickup_location_address ?? ""
        dropLocationLbl.text = trip.drop_location_address ?? ""
        if trip.status == 0{
            statusBtn.backgroundColor = .gray
            statusBtn.setTitle("In Queue", for: .normal)
        }else  if trip.status == 1{
            statusBtn.backgroundColor = .yellow
            statusBtn.setTitle("In Process", for: .normal)
        }else  if trip.status == 2{
            statusBtn.backgroundColor =  hexStringToUIColor(hex: "#2EA058")  
            statusBtn.setTitle("Ride Completed", for: .normal)
        }else  if trip.status == 3{
            statusBtn.backgroundColor = .red
            statusBtn.setTitle("Cancelled", for: .normal)
        }
       // statusBtn.setTitle(trip.autos_status_text ?? "", for: .normal)
//        if let hexColor = trip.autos_status_color {
//            statusBtn.backgroundColor = hexStringToUIColor(hex: hexColor)
//        }
        datelbl.text = ConvertDateFormater(date: trip.pickup_time ?? "")
        pickUpTime.text = ConvertTimeFormater(date: "")
        dropTimeLbl.text = ConvertTimeFormater(date: "")
    }
}
