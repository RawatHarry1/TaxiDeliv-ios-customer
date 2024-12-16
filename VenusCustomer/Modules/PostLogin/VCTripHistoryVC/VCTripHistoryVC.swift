//
//  VCTripHistoryVC.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VCTripHistoryVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var tripsTableView: UITableView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var lblHistory: UILabel!
    
    var viewModel = VCTripHistoryViewModel()
    var isTrip = true
    var objData : [ScheduledData]?
    //  To create ViewModel
    static func create() -> VCTripHistoryVC {
        let obj = VCTripHistoryVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        callBacks()
        tripsTableView.register(UINib(nibName: "VCTripHistoryCell", bundle: nil), forCellReuseIdentifier: "VCTripHistoryCell")
        
        selectedBtn(btn: btnTrip)
        lblHistory.text = "Trip History"
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedBtn(btn: btnTrip)
        unSelectedBtn(btn: btnSchedule)
        lblHistory.text = "Trip History"
        isTrip = true
        viewModel.getRecentTrips()
    }
    
    func CancelScheduleApi(id: String){
        viewModel.cancelSchedule(pickip_Id: id) {
            if self.viewModel.objCancelScheduleModal?.message != nil{
                SKToast.show(withMessage: self.viewModel.objCancelScheduleModal?.message ?? "")
            }else{
                self.viewModel.scheduleTrips()
            }
        }
    }
    
    
    @IBAction func btnTripAction(_ sender: Any) {
        selectedBtn(btn: btnTrip)
        unSelectedBtn(btn: btnSchedule)
        lblHistory.text = "Trip History"
        isTrip = true
        viewModel.getRecentTrips()
    }
    
    @IBAction func btnScheduleAction(_ sender: Any) {
        selectedBtn(btn: btnSchedule)
        unSelectedBtn(btn: btnTrip)
        lblHistory.text = "Schedule History"
        isTrip = false
        viewModel.scheduleTrips()
    }
    
    func selectedBtn(btn:UIButton){
        btn.backgroundColor = .systemGray4
    }
    
    func unSelectedBtn(btn:UIButton){
        btn.backgroundColor = .white
    }
    
    private func callBacks() {
        viewModel.callBackForTripHistory = { tripHistory in
            self.tripsTableView.reloadData()
        }
        
        viewModel.callBackForScheduleHistory = { scheduleData in
            self.objData = scheduleData
            self.tripsTableView.reloadData()
        }
    }
}

extension VCTripHistoryVC : UITableViewDelegate , UITableViewDataSource  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTrip == true{
            guard let trips = viewModel.tripHistory else {
                noDataFoundLbl.isHidden = false
                return 0
            }
            noDataFoundLbl.isHidden = trips.count > 0 ? true : false
            return trips.count
        }else{
            guard let trips = viewModel.tripSchedule else {
                noDataFoundLbl.isHidden = false
                return 0
            }
            noDataFoundLbl.isHidden = trips.count > 0 ? true : false
            return trips.count
           
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTrip == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "VCTripHistoryCell") as! VCTripHistoryCell
            cell.btnCancel.isHidden = true
            cell.SetUpUI(viewModel.tripHistory[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "VCTripHistoryCell") as! VCTripHistoryCell
            cell.btnCancel.isHidden = false
            cell.SetUpUISchedule(viewModel.tripSchedule[indexPath.row])
            
            if self.viewModel.tripSchedule[indexPath.row].status != 0{
                cell.btnCancel.alpha = 0.4
                cell.btnCancel.isEnabled = false
            }else{
                cell.btnCancel.alpha = 1
                cell.btnCancel.isEnabled = true
            }
            cell.didPressCancel = {
               
                self.CancelScheduleApi(id: "\(self.viewModel.tripSchedule[indexPath.row].pickup_id ?? 0)")
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTrip == true{
            var vc = VCTripDetailVC.create()
            vc.selectedTrip = viewModel.tripHistory[indexPath.row]
            vc.driverId = "\(viewModel.tripHistory[indexPath.row].driver_id ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
}
