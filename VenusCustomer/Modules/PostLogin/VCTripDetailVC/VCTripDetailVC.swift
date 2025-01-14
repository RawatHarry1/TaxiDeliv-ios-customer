//
//  VCTripDetailVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit
import GoogleMaps
import PDFKit
class VCTripDetailVC: VCBaseVC, CollectionViewCellDelegate {

    // MARK: -> Outlets
    
    @IBOutlet weak var viewProductDetail: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var pickUpTimeLbl: UILabel!
    @IBOutlet weak var pickupAddressLbl: UILabel!
    @IBOutlet weak var dropTimeLbl: UILabel!
    @IBOutlet weak var dropLocationLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var ratingsLbl: UILabel!
    @IBOutlet weak var vehicleNumberLbl: UIButton!
    @IBOutlet weak var vehicleModelLbl: UIButton!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var paymentCashLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalChargeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
  //  @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageMap: UIImageView!
    @IBOutlet weak var lblPaidByStripe: UILabel!
    @IBOutlet weak var viewStripe: UIView!
    @IBOutlet weak var lblPaidByWallet: UILabel!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var lblPaybyPaytm: UILabel!
    
    @IBOutlet weak var viewPaytm: UIView!
    private var viewModel = VCTripHistoryViewModel()

    var markerUser : GMSMarker?
    var selectedTrip: TripHistoryModel?
    var selectedTripDetails: TripHistoryDetails?
    var angagementID = ""
    var driverId = ""
    var tripId = 0
    var delivery_packages: [deliveryPackagesD]?
    var isHideDetail = false
    var fromFeedback = false
    
    //  To create ViewModel
    static func create() -> VCTripDetailVC {
        let obj = VCTripDetailVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
        if lat != 0{
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
         //   self.addMarkerToPosition(coordinates)
        }
    }

    override func initialSetup() {
        if requestRideType == 1{
          
            viewProductDetail.isHidden = true
        }else if requestRideType == 2{
            viewProductDetail.isHidden = false
        }else{
            viewProductDetail.isHidden = true
        }
        //dashedView.addDashedSmallBorder()
        if fromFeedback == false {
            guard let trip = selectedTrip else {return}
            viewModel.getTripDetails(trip)
            
            viewModel.callBackForTripHistoryDetails = { trip in
                self.selectedTripDetails = trip
                
                self.pickupAddressLbl.text = trip.pickup_address ?? ""
                self.dropLocationLbl.text = trip.drop_address ?? ""
                self.pickUpTimeLbl.text = ConvertTimeFormater(date: trip.pickup_time ?? "")
                self.dropTimeLbl.text = ConvertTimeFormater(date: trip.drop_time ?? "")
                self.angagementID = "\(trip.engagement_id ?? 0)"
                if let currency = UserModel.currentUser.login?.currency_symbol {
                    self.paymentCashLbl.text = currency + " " + (trip.fare ?? 0.0).toString
                    self.subTotalLbl.text = currency + " " + (trip.fare ?? 0.0).toString
                    self.vatLbl.text = currency + " " + (trip.net_customer_tax ?? 0.0).toString
                    self.discountLbl.text = currency + " " + (trip.discount_value ?? 0.0).toString
                    self.totalChargeLbl.text = currency + " " + (trip.trip_total ?? 0.0).toString
                    self.ratingsLbl.text = ((trip.driver_rating ?? -1) == -1) ? "0" : "\(trip.driver_rating ?? -1)"
                    
                    self.ratingView.isHidden = (trip.driver_rating ?? -1 ) != -1
                    self.titleLbl.text =  trip.autos_status_text ?? ""
                    self.driverNameLbl.text = trip.driver_name ?? ""
                    self.vehicleNumberLbl.setTitle(trip.driver_car_no ?? "", for: .normal)
                    self.vehicleModelLbl.setTitle(trip.model_name ?? "", for: .normal)
                    
                    if let urlStr = trip.driver_image {
                        self.driverImage.setImage(urlStr, showIndicator: true)
                    }
                    if let urlStr = trip.tracking_image {
                        self.imageMap.setImage(urlStr, showIndicator: true)
                    }
                    
                    self.questionLbl.text = "How was your trip with \(trip.driver_name ?? "")"
                    if trip.paid_using_stripe ?? 0 > 0{
                        self.lblPaidByStripe.text = "\(currency) \(trip.paid_using_stripe ?? 0.0)"
                        self.viewStripe.isHidden = false
                    }else{
                        self.viewStripe.isHidden = true
                    }
                    if trip.paid_using_wallet ?? 0 > 0{
                        self.lblPaidByWallet.text = "\(currency) \(trip.paid_using_wallet ?? 0.0)"
                        self.viewWallet.isHidden = false
                    }else{
                        self.viewWallet.isHidden = true
                    }
                    
                    if trip.paid_using_paytm ?? 0 > 0{
                        self.lblPaybyPaytm.text = "\(currency) \(trip.paid_using_paytm ?? 0.0)"
                        self.viewPaytm.isHidden = false
                    }else{
                        self.viewPaytm.isHidden = true
                    }
                    
                    self.getTripSummaryApi()
                }
            }
        }
        else
        {
            viewModel.getTripDetailsFromID(tripId)
            
            viewModel.callBackForTripHistoryDetails = { trip in
                self.selectedTripDetails = trip
                
                self.pickupAddressLbl.text = trip.pickup_address ?? ""
                self.dropLocationLbl.text = trip.drop_address ?? ""
                self.pickUpTimeLbl.text = ConvertTimeFormater(date: trip.pickup_time ?? "")
                self.dropTimeLbl.text = ConvertTimeFormater(date: trip.drop_time ?? "")
                self.angagementID = "\(trip.engagement_id ?? 0)"
                if let currency = UserModel.currentUser.login?.currency_symbol {
                    self.paymentCashLbl.text = currency + " " + (trip.fare ?? 0.0).toString
                    self.subTotalLbl.text = currency + " " + (trip.fare ?? 0.0).toString
                    self.vatLbl.text = currency + " " + (trip.net_customer_tax ?? 0.0).toString
                    self.discountLbl.text = currency + " " + (trip.discount_value ?? 0.0).toString
                    self.totalChargeLbl.text = currency + " " + (trip.trip_total ?? 0.0).toString
                    self.ratingsLbl.text = ((trip.driver_rating ?? -1) == -1) ? "0" : "\(trip.driver_rating ?? -1)"
                    
                    self.ratingView.isHidden = (trip.driver_rating ?? -1 ) != -1
                    self.titleLbl.text =  trip.autos_status_text ?? ""
                    self.driverNameLbl.text = trip.driver_name ?? ""
                    self.vehicleNumberLbl.setTitle(trip.driver_car_no ?? "", for: .normal)
                    self.vehicleModelLbl.setTitle(trip.model_name ?? "", for: .normal)
                    
                    if let urlStr = trip.driver_image {
                        self.driverImage.setImage(urlStr, showIndicator: true)
                    }
                    if let urlStr = trip.tracking_image {
                        self.imageMap.setImage(urlStr, showIndicator: true)
                    }
                    
                    self.questionLbl.text = "How was your trip with \(trip.driver_name ?? "")"
                    if trip.paid_using_stripe ?? 0 > 0{
                        self.lblPaidByStripe.text = "\(currency) \(trip.paid_using_stripe ?? 0.0)"
                        self.viewStripe.isHidden = false
                    }else{
                        self.viewStripe.isHidden = true
                    }
                    if trip.paid_using_wallet ?? 0 > 0{
                        self.lblPaidByWallet.text = "\(currency) \(trip.paid_using_wallet ?? 0.0)"
                        self.viewWallet.isHidden = false
                    }else{
                        self.viewWallet.isHidden = true
                    }
                    
                    if trip.paid_using_paytm ?? 0 > 0{
                        self.lblPaybyPaytm.text = "\(currency) \(trip.paid_using_paytm ?? 0.0)"
                        self.viewPaytm.isHidden = false
                    }else{
                        self.viewPaytm.isHidden = true
                    }
                    
                    self.getTripSummaryApi()
                }
            }
        }
    }
    
    func getTripSummaryApi(){
        viewModel.tripSummaryApi(urlSting: "\(angagementID)&driverId=\(driverId)") {
            print()
            self.delivery_packages = self.viewModel.objGetTripSummaryModal?.data?.delivery_packages
            self.tblView.reloadData()
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
   
    @IBAction func btnRaiseTicketAction(_ sender: Any) {
//        if fromFeedback == true{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaiseTicketVC") as! RaiseTicketVC
//            vc.rideId = "\(self.viewModel.objGetTripSummaryModal?.data?.engagement_id ?? 0)"
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
//
//        }
//        else
//        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaiseTicketVC") as! RaiseTicketVC
            vc.rideId = "\(self.viewModel.objGetTripSummaryModal?.data?.engagement_id ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)

    //    }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if fromFeedback == true{
            VCRouter.goToSaveUserVC()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
      }
      
    }

    @IBAction func btnSupport(_ sender: Any) {
        guard let url = URL(string: "telprompt://\(self.viewModel.objGetTripSummaryModal?.data?.support_number ?? "")"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
   //
    @available(iOS 14.0, *)
    @IBAction func btnInvoiceAction(_ sender: Any) {
        let pdfUrlString = "\(sharedAppDelegate.appEnvironment.baseURL)/ride/invoice?ride_id=\(self.angagementID)"
             if let pdfUrl = URL(string: pdfUrlString) {
                 SKToast.show(withMessage: "Downloading invoice please wait!!")
                 downloadPDF(from: pdfUrl)
             }
    }
    
    @IBAction func btnPackageDetailAction(_ sender: Any) {
        if isHideDetail == false{
            isHideDetail = true
            tblView.isHidden = true
        }else{
            isHideDetail = false
            tblView.isHidden = false
        }
        
    }
    
    
    @IBAction func btnRateDriver(_ sender: UIButton) {
        guard let trip = selectedTripDetails else {return}
        let vc = VCFeedbackVC.create()
        vc.selectedTrip = trip
        vc.callBackRatingSuccess = { ratings in
            self.ratingsLbl.text = "\(ratings)"
            self.ratingView.isHidden = true
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
}

extension VCTripDetailVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delivery_packages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailTblCell", for: indexPath) as! PackageDetailTblCell
        let obj = delivery_packages?[indexPath.row]
        cell.delivery_packages = obj
        cell.lblSize.text = obj?.package_size ?? ""
        cell.lblQuantity.text = "\(obj?.package_quantity ?? 0)"
        cell.lblPackageType.text = obj?.package_type ?? ""
        cell.delegate = self
        return cell
    }
    
    func didSelectItem(url: String) {
        // Navigate to a new view controller
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        detailVC.url = url
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.heightConstant.constant = self.tblView.contentSize.height
        }
    }
}
extension VCTripDetailVC {

    func initializeMap() {
      //  mapView.clear()
    }

//    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
//        mapView.clear()
//        markerUser?.map = nil
//        markerUser = GMSMarker(position: coordinates)
//        markerUser?.icon = VCImageAsset.locationMarker.asset
//        markerUser?.isFlat = false
//        markerUser?.position = coordinates
//        markerUser?.map = mapView
//        let camera = GMSCameraPosition.init(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
////        self.viewMap.camera = camera
//        self.mapView.animate(to: camera)
//    }
}
extension VCTripDetailVC: UIDocumentPickerDelegate {
    @available(iOS 14.0, *)
    func downloadPDF(from url: URL) {
        let urlSession = URLSession.shared
        let downloadTask = urlSession.downloadTask(with: url) { (location, response, error) in
            guard let location = location, error == nil else {
                SKToast.show(withMessage: "Error downloading PDF: \(String(describing: error?.localizedDescription))")

                print("Error downloading PDF: \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                let temporaryDirectoryURL = FileManager.default.temporaryDirectory
                let temporaryPdfUrl = temporaryDirectoryURL.appendingPathComponent("downloadedInvoice.pdf")
                
                // Remove existing file if it exists
                if FileManager.default.fileExists(atPath: temporaryPdfUrl.path) {
                    try FileManager.default.removeItem(at: temporaryPdfUrl)
                }
                
                // Move the downloaded file to the temporary location
                try FileManager.default.moveItem(at: location, to: temporaryPdfUrl)
                SKToast.show(withMessage: "PDF downloaded")

                DispatchQueue.main.async {
                    self.saveToiCloudDrive(fileUrl: temporaryPdfUrl)
                }
                
            } catch {
                SKToast.show(withMessage: "Error saving PDF: \(error.localizedDescription)")
                print("Error saving PDF: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }
    
    @available(iOS 14.0, *)
    func saveToiCloudDrive(fileUrl: URL) {
        let documentPicker = UIDocumentPickerViewController(forExporting: [fileUrl])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
}

extension VCTripDetailVC {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Document saved to: \(urls.first?.path ?? "")")
        // Optionally, you can show an alert to inform the user that the document was saved successfully
        let alertController = UIAlertController(title: "Success", message: "PDF has been saved to iCloud Drive.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User cancelled the document picker")
    }
}
