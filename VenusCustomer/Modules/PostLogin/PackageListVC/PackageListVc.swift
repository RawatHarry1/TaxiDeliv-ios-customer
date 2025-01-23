//
//  PackageListVc.swift
//  E wallet App
//
//  Created by Ayush Verma on 05/11/24.
//

import UIKit

class PackageListVc: VCBaseVC {
    @IBOutlet weak var viewImg: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var packageText: UILabel!
    @IBOutlet weak var btnContinueOutlet: UIButton!
    @IBOutlet weak var dashedView: RectangularDashedView!
    
    @IBOutlet weak var img: UIImageView!
    var arrLoadedPackageDetails: [PackageDetail] = []
    var pickUpLocation : GeometryFromPlaceID?
    var dropLocation : GeometryFromPlaceID?
    @IBOutlet weak var dashedBorder: UIView!
    var objOperator_availablity : operator_availablityy?
    var lat = 0.0
    var long = 0.0
    var dropPlace : GooglePlacesModel?
    var pickUpPlace : GooglePlacesModel?
    var regions: [Regions]?
    var pickupLoc = ""
    var dropoffLoc = ""
    var isSechdule = false
    var utcDate = ""
    var customerETA : etaData?
    var selectedRegions: Regions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setImage(UIImage(named: "backWhite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        tblView.rowHeight = 200
        packageText.text = "Start adding your \n package"
//        dashedBorder.appendDashedBorder()
        dashedView.cornerRadius = 20
        dashedView.dashWidth = 3
        refreshData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
    }
    
    func refreshData(){
        if let loadedPackageDetails = retrievePackageDetails() {
            // Access data from the loaded array
            self.arrLoadedPackageDetails = loadedPackageDetails
            if  self.arrLoadedPackageDetails.count  == 0{
                viewImg.isHidden = false
                tblView.isHidden = true
                btnContinueOutlet.isHidden = true
                
            }else{
                viewImg.isHidden = true
                tblView.isHidden = false
                btnContinueOutlet.isHidden = false
                tblView.reloadData()
            }
           
        } else {
            print("No package details found in UserDefaults.")
        }
    }
    
    func retrievePackageDetails() -> [PackageDetail]? {
        // Attempt to retrieve the saved data from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "packageDetailsKey") {
            let decoder = JSONDecoder()
            
            // Decode the data back into an array of PackageDetail objects
            if let loadedDetails = try? decoder.decode([PackageDetail].self, from: savedData) {
                return loadedDetails
            }
        }
        return nil
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPackage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPackageVC") as! AddPackageVC
        vc.isEdit = false
        vc.dismissController = {
            self.refreshData()
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDetailsVC") as! ReviewDetailsVC
        vc.dropPlace = self.dropPlace
        vc.dropLocation = self.dropLocation
        vc.pickUpPlace = self.pickUpPlace
        vc.pickUpLocation = self.pickUpLocation
        vc.regions = self.regions
        vc.pickupLoc = self.pickupLoc
        vc.dropoffLoc = self.dropoffLoc
        vc.isSechdule = self.isSechdule
        vc.utcDate = self.utcDate
        vc.customerETA = self.customerETA
        vc.objOperator_availablity = self.objOperator_availablity
        vc.selectedRegions = self.selectedRegions
        vc.onConfirm = { (status, rideDetails) in
            vc.removeFromParentVC()
            let cancelPopupVC = VCCancelPopUpVC.create()
            cancelPopupVC.pickUpLocation = self.pickUpLocation
            cancelPopupVC.dropLocation = self.dropLocation
            cancelPopupVC.rideRequestDetails = rideDetails
            cancelPopupVC.modalPresentationStyle = .overFullScreen
            cancelPopupVC.onConfirm = { value in
//                let vc = VCCancelRideVC.create()
//                vc.modalPresentationStyle = .overFullScreen
//                vc.onConfirm = { value in
//                    if value == 1  {
                        let cancelReasonVC = VCCancelReasonVC.create()
                       
                        cancelReasonVC.rideRequestDetails = cancelPopupVC.rideRequestDetails
                        self.navigationController?.pushViewController(cancelReasonVC, animated: true)
//                    }
//                }
//                self.navigationController?.present(vc, animated: true)

            }
            //self.backView.isHidden = true
            self.addViewToSelf(cancelPopupVC)

        }

        //self.backView.isHidden = false
          self.addViewToSelf(vc)
    }
    
    func deleteAlert(){
       
    }
    
    func addViewToSelf(_ vc: UIViewController) {
        vc.view.frame = self.view.bounds
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
}
extension PackageListVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.arrLoadedPackageDetails.count == 0{
            viewImg.isHidden = false
            tblView.isHidden = true
            btnContinueOutlet.isHidden = true
           
        }else{
            viewImg.isHidden = true
            tblView.isHidden = false
            btnContinueOutlet.isHidden = false
        }
        return arrLoadedPackageDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailTblCell", for: indexPath) as! PackageDetailTblCell
        cell.lblSize.text = arrLoadedPackageDetails[indexPath.row].package_size ?? ""
        cell.lblQuantity.text = "\(arrLoadedPackageDetails[indexPath.row].quantity ?? "")"
        cell.lblPackageType.text = arrLoadedPackageDetails[indexPath.row].type ?? ""
        
        cell.didPressDlt = {
            let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want Delete?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
                self.deletePackageDetail(at: indexPath.row)
                
                // Reload the table view to reflect changes
                self.tblView.beginUpdates()
                // Then delete the row in the table view
                self.tblView.deleteRows(at: [indexPath], with: .fade)
                self.tblView.reloadData()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                // End table updates
                self.tblView.endUpdates()
              }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
              }))

            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        cell.didPressEdit = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPackageVC") as! AddPackageVC
            vc.objPackageDetailsArray = self.arrLoadedPackageDetails[indexPath.row]
            vc.index = indexPath.row
            vc.isEdit = true
            vc.editImg = self.arrLoadedPackageDetails[indexPath.row].image?[0] ?? ""
            vc.dismissController = {
                self.refreshData()
            }
            self.present(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.heightConstant.constant = self.tblView.contentSize.height
        }
    }
}
extension PackageListVc{
    // Define a new method to delete a package detail at a specified index
    func deletePackageDetail(at index: Int) {
        // Load existing data
        arrLoadedPackageDetails = loadPackageDetails()
        
        // Make sure the index is within bounds
        guard index < arrLoadedPackageDetails.count else { return }
        
        // Remove the package detail at the specified index
        arrLoadedPackageDetails.remove(at: index)
        
        // Save the updated array to UserDefaults
        savePackageDetails(self.arrLoadedPackageDetails)
    }


    // Load function (unchanged)
    func loadPackageDetails() -> [PackageDetail] {
        if let data = UserDefaults.standard.data(forKey: "packageDetailsKey") {
            let decoder = JSONDecoder()
            if let decodedDetails = try? decoder.decode([PackageDetail].self, from: data) {
                return decodedDetails
            }
        }
        return []
    }

    // Save function (unchanged)
    func savePackageDetails(_ details: [PackageDetail]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(details) {
            UserDefaults.standard.set(encoded, forKey: "packageDetailsKey")
            UserDefaults.standard.synchronize()
           
            self.dismiss(animated: true)
        }
    }

}
