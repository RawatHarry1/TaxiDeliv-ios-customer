//
//  VCHome+MapDelegates.swift
//  VenusCustomer
//
//  Created by Amit on 04/02/24.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps


extension VCHomeVC {

    // MARK: - Reset Map to Default State ie. Current Location
    func resetMapToDefaultState() {
        mapView.clear()
//        plotMarkerOnPosition(to: TDUserModel.currentUser.location.location.coordinates, isSelectedMarker: false, bottomPadding: 0, shouldUpdateMapInsets: true, direction: nil)
        completeGmsPath = nil
        completePolyline = nil
        travelledGmsPath = nil
        travelledPolyline = nil
//        infoWindowETA = nil
        requestedPathCoordinates = nil
//        hasSetPolyLineBounds = false
        if let currentLocation = LocationTracker.shared.lastLocation {
            let camera = GMSCameraPosition.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 16)
            self.mapView.animate(to: camera)
        }
    }


    func updateNearByDrivers(_ drivers: [Drivers]) {
     //   mapView.clear()
        for driver in drivers {
            let driverMarker: GMSMarker?
            let coordinates = CLLocationCoordinate2D(latitude: driver.latitude ?? 0.0, longitude: driver.longitude ?? 0.0)
            driverMarker = GMSMarker(position: coordinates)
            driverMarker?.icon = VCImageAsset.vehicleMarker.asset
            driverMarker?.isFlat = false
            driverMarker?.position = coordinates
            driverMarker?.map = mapView
        }
    }

    

    
}

extension DeliveryHomeVC {

    // MARK: - Reset Map to Default State ie. Current Location
    func resetMapToDefaultState() {
        mapView.clear()
//        plotMarkerOnPosition(to: TDUserModel.currentUser.location.location.coordinates, isSelectedMarker: false, bottomPadding: 0, shouldUpdateMapInsets: true, direction: nil)
        completeGmsPath = nil
        completePolyline = nil
        travelledGmsPath = nil
        travelledPolyline = nil
//        infoWindowETA = nil
        requestedPathCoordinates = nil
//        hasSetPolyLineBounds = false
        if let currentLocation = LocationTracker.shared.lastLocation {
            let camera = GMSCameraPosition.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 16)
            self.mapView.animate(to: camera)
        }
    }


    func updateNearByDrivers(_ drivers: [Drivers]) {
     //   mapView.clear()
        for driver in drivers {
            let driverMarker: GMSMarker?
            let coordinates = CLLocationCoordinate2D(latitude: driver.latitude ?? 0.0, longitude: driver.longitude ?? 0.0)
            driverMarker = GMSMarker(position: coordinates)
            driverMarker?.icon = VCImageAsset.vehicleMarker.asset
            driverMarker?.isFlat = false
            driverMarker?.position = coordinates
            driverMarker?.map = mapView
        }
    }

    

    
}
