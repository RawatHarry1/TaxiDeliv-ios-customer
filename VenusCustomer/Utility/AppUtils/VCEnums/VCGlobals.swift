//
//  VDGlobals.swift
//  VenusCustomer
//
//  Created by Amit on 11/06/23.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

var googleAPIKey = ClientModel.currentClientData.google_map_keys //"AIzaSyAK6809b_21d4H62yMZpIV9JcTVWcyDtPY"
typealias JSONDictionary = [String: Any]
typealias HTTPHeaders = [String:String]
typealias APIResponse = (Result<JSON,NSError>) -> Void
let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
typealias ImageCompletionHandlerWithStatus = ((_ status: Bool, _ image: UIImage?) -> Void)?
var CountryList = CountriesData.fetchCountries()
var failedToFetchLocation = false

func printDebug <T> (_ object1: T , _ object2: T? = nil) {
    #if DEBUG
    if let object2 = object2 {
       print(object1 , object2)
    } else {
        print(object1)
    }
    #endif
}

func delay(withSeconds seconds: Double,_ completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


func getSelectedAddressCoordinate(placeId:String, gmsSessionToken: GMSAutocompleteSessionToken) {
    var name = UInt(GMSPlaceField.name.rawValue)
    var coordinates = UInt(GMSPlaceField.coordinate.rawValue)
    var addressComponents = UInt(GMSPlaceField.addressComponents.rawValue)
    var formatedAddress = UInt(GMSPlaceField.formattedAddress.rawValue)
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(UInt64(UInt(name | coordinates  | addressComponents | formatedAddress))))
    GMSPlacesClient().fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: gmsSessionToken) { place, error in
        printDebug(place)
    }


//    fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: gmsSessionToken) { [weak self] (place, error) in
//        guard let `self` = self else { return }
//        printDebug("gmsSessionToken :- \(self.gmsSessionToken)")
//        if error != nil { return }
//        self.gmsSessionToken = GMSAutocompleteSessionToken.init()
//        printDebug("gmsSessionToken :- \(self.gmsSessionToken)")
//
//        var selectedPlace = PlaceSearchResult(placeData: place, name : "", fullAddress : "", placeId : placeId)
//        var geoCoder : GMSGeocoder = GMSGeocoder()
//        geoCoder.reverseGeocodeCoordinate(selectedPlace.getFavPlaceData.clLocationCoordinate2D) { [weak self] response, error in
//            printDebug(error?.localizedDescription)
//            response?.firstResult()
//            let place : GMSAddress? = response?.firstResult()
//           printDebug(place)
//        }
//    }
}

func ConvertDateFormater(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    guard let date = dateFormatter.date(from: date) else {
//            assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = "d MMM yyyy, HH:mm"//"yyyy MMM EEEE HH:mm"
    dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}


func ConvertTimeFormater(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    guard let date = dateFormatter.date(from: date) else {
//            assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = "HH:mm"//"yyyy MMM EEEE HH:mm"
    dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}



func convertTo12HourTime(from time24: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm" // input format
    
    guard let date = dateFormatter.date(from: time24) else {
        print("Invalid time format")
        return nil
    }
    
    dateFormatter.dateFormat = "hh:mm a" // output format
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let time12 = dateFormatter.string(from: date)
    return time12
}

import UIKit

class GradientProgressView: UIProgressView {

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.systemBlue.cgColor, UIColor.green.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = frame.height / 2
        gradientLayer.masksToBounds = true

        layer.addSublayer(gradientLayer)
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true

        progressTintColor = UIColor.clear
        trackTintColor = UIColor.clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func setProgress(_ progress: Float, animated: Bool) {
        super.setProgress(progress, animated: animated)

        let progressWidth = bounds.width * CGFloat(progress)
        let newBounds = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)

        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        gradientLayer.frame = newBounds
        CATransaction.commit()
    }
}
