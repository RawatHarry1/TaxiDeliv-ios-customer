//
//  VCOnGoingRideVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class VCOnGoingRideVC: VCBaseVC {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    

    var regions: [Regions]?
    var pickUpPlace : GooglePlacesModel?
    var pickUpLocation : GeometryFromPlaceID?
    var markerUser : GMSMarker?
    var dropPlace : GooglePlacesModel?
    var dropLocation : GeometryFromPlaceID?
    var pickupLoc = ""
    var dropoffLoc = ""
    var utcDate = ""
    var isSechdule = false
    var selectedRegions: Regions?
    var customerETA : etaData?
    var objOperator_availablity : operator_availablityy?
    var loadedPackageDetails: [PackageDetail]?
    var is_for_rental = false
    var drop_date = ""
    var start_date = ""

    //  To create ViewModel
    static func create() -> VCOnGoingRideVC {
        let obj = VCOnGoingRideVC.instantiate(fromAppStoryboard: .ride)
        return obj
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
        if lat != 0{
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.addMarkerToPosition(coordinates)
        }
    }

    override func initialSetup() {
        let vc = VCRideVehiclesListVC.create()
        self.backView.isHidden = false
        vc.isSechdule = self.isSechdule
        vc.regions = regions
        vc.dropPlace = self.dropPlace
        vc.dropLocation = self.dropLocation
        vc.pickUpPlace = self.pickUpPlace
        vc.pickUpLocation = self.pickUpLocation
        vc.customerETA = self.customerETA
        vc.is_for_rental = self.is_for_rental
        vc.objOperator_availablity = self.objOperator_availablity
       // vc.loadedPackageDetails = self.loadedPackageDetails
        vc.onConfirm = { value,selectedRegions,customerEta,obj_perator_availablityy, str in
            
            if self.objOperator_availablity?.id == 1{
               // let confirmVC = self.storyboard?.instantiateViewController(identifier: "PackageListVc") as! PackageListVc
                
                let confirmVC = ReviewDetailsVC.create()
                confirmVC.selectedRegions = vc.selectedRegions
                confirmVC.is_for_rental = self.is_for_rental
                confirmVC.drop_date = self.drop_date
                confirmVC.start_date = self.start_date
                confirmVC.dropPlace = self.dropPlace
                confirmVC.dropLocation = self.dropLocation
                confirmVC.pickUpPlace = self.pickUpPlace
                confirmVC.pickUpLocation = self.pickUpLocation
                confirmVC.pickupLoc = self.pickupLoc
                confirmVC.dropoffLoc = self.dropoffLoc
                confirmVC.utcDate = self.utcDate
                confirmVC.isSechdule = self.isSechdule
                confirmVC.selectedRegions = selectedRegions
                confirmVC.customerETA = customerEta
                confirmVC.objOperator_availablity = obj_perator_availablityy
               // confirmVC.loadedPackageDetails = loadedPackageDetails
                confirmVC.modalPresentationStyle = .overFullScreen
                confirmVC.onConfirm = { (status, rideDetails) in
                    vc.removeFromParentVC()
                    let cancelPopupVC = VCCancelPopUpVC.create()
                    cancelPopupVC.rideRequestDetails = rideDetails
                    cancelPopupVC.pickUpLocation = self.pickUpLocation
                    cancelPopupVC.dropLocation = self.dropLocation
                    cancelPopupVC.modalPresentationStyle = .overFullScreen
                    cancelPopupVC.onConfirm = { value in
                        let vc = VCCancelRideVC.create()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.onConfirm = { value in
                            if value == 1  {
                                let cancelReasonVC = VCCancelReasonVC.create()
                                cancelReasonVC.rideRequestDetails = cancelPopupVC.rideRequestDetails
                                self.navigationController?.pushViewController(cancelReasonVC, animated: true)
                            }
                        }
                        self.navigationController?.present(vc, animated: true)

                    }
                    self.backView.isHidden = true
                    self.addViewToSelf(cancelPopupVC)

                }

                self.backView.isHidden = false
                  self.addViewToSelf(confirmVC)
            }else{
                let confirmVC = self.storyboard?.instantiateViewController(identifier: "PackageListVc") as! PackageListVc
                confirmVC.is_for_rental = self.is_for_rental
                confirmVC.drop_date = self.drop_date
                confirmVC.start_date = self.start_date
                confirmVC.selectedRegions = vc.selectedRegions
                confirmVC.dropPlace = self.dropPlace
                confirmVC.dropLocation = self.dropLocation
                confirmVC.pickUpPlace = self.pickUpPlace
                confirmVC.pickUpLocation = self.pickUpLocation
                confirmVC.pickupLoc = self.pickupLoc
                confirmVC.dropoffLoc = self.dropoffLoc
                confirmVC.utcDate = self.utcDate
                confirmVC.isSechdule = self.isSechdule
                confirmVC.selectedRegions = selectedRegions
                confirmVC.customerETA = customerEta
                confirmVC.objOperator_availablity = obj_perator_availablityy
               // confirmVC.loadedPackageDetails = loadedPackageDetails
                confirmVC.modalPresentationStyle = .overFullScreen
                self.backView.isHidden = false
                  self.addViewToSelf(confirmVC)
//                confirmVC.onConfirm = { (status, rideDetails) in
//                    vc.removeFromParentVC()
//                    let cancelPopupVC = VCCancelPopUpVC.create()
//                    cancelPopupVC.rideRequestDetails = rideDetails
//                    cancelPopupVC.modalPresentationStyle = .overFullScreen
//                    cancelPopupVC.onConfirm = { value in
//                        let vc = VCCancelRideVC.create()
//                        vc.modalPresentationStyle = .overFullScreen
//                        vc.onConfirm = { value in
//                            if value == 1  {
//                                let cancelReasonVC = VCCancelReasonVC.create()
//                                cancelReasonVC.rideRequestDetails = cancelPopupVC.rideRequestDetails
//                                self.navigationController?.pushViewController(cancelReasonVC, animated: true)
//                            }
//                        }
//                        self.navigationController?.present(vc, animated: true)
//
//                    }
//                    self.backView.isHidden = true
//                    self.addViewToSelf(cancelPopupVC)
//
//                }

              
            }
           


        }

        addViewToSelf(vc)
        self.view.bringSubviewToFront(backView)
    }

    override func viewDidLayoutSubviews() {
        backView.roundCorner([.topRight, .bottomRight], radius: 28)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func addViewToSelf(_ vc: UIViewController) {
        vc.view.frame = self.view.bounds
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
}
extension VCOnGoingRideVC {

    func initializeMap() {
        mapView.clear()
    }

    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
        mapView.clear()
        markerUser?.map = nil
        markerUser = GMSMarker(position: coordinates)
        markerUser?.icon = VCImageAsset.locationMarker.asset
        markerUser?.isFlat = false
        markerUser?.position = coordinates
        markerUser?.map = mapView
        let camera = GMSCameraPosition.init(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
//        self.viewMap.camera = camera
        self.mapView.animate(to: camera)
    }
}
