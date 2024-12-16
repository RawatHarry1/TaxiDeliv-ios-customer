//
//  VDImageAssets.swift
//  VenusCustomer
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VCImageAsset: String {

    case chooselogin
    case splashbackgroundLogo
    case splashLogo
    case checkBoxOrange
    case cross
    case facebook
    case googleLogo
    case appleLogo
    case backbutton
    case checkEmail
    case check
    case camera
    case imgPlaceholder
    case introFirst
    case introSecond
    case introThird
    case introForth
    case menu
    case offline
    case currentlocation
    case switchEnable
    case switchDisable
    case account
    case bookings
    case contactUs
    case documents
    case earnings
    case logout
    case notifications
    case ratings
    case removeDoc
    case dummyDoc
    case documentAdd
    case countryFlag
    case arrowDown
    case navBackground
    case rideDemo
    case star
    case radioDisable
    case radioEnable
    case addOrange
    case carchair
    case drivinglicense
    case xmlid359
    case unchecked
    case sendMessage
    case timeIcon
    case aboutUs
    case changePass
    case faq
    case terms
    case message
    case pass
    case accountTab
    case accountTabSelected
    case home
    case homeSelected
    case notification
    case notificationSelected
    case trips
    case tripsSelected
    case offers
    case wallet
    case emailAboutUs
    case legal
    case likeus
    case privacyPolicy
    case rateUs
    case settingsAboutApp
    case arrowRight
    case mastercard
    case netBanking
    case orangeCross
    case location
    case clockIcon
    case blackArrowDown
    case offersBanned
    case calender
    case homeline
    case carTime
    case backWhite
    case economy
    case sedan
    case suv
    case userPlaceHolder
    case crossWhite
    case blueTick
    case creditCard
    case promo
    case waitingUser
    case userWhite
    case chatIcon
    case callIcon
    case locationMarket
    case attachment
    case mic
    case saloneIntro1
    case saloneIntro2
    case saloneIntro3
    case saloneIntro4
    case skipBtn
    case starDisable
    case locationMarker
    case vehicleMarker
    case reffral
    case delete
    case back
    case sharpUnselected
    case sharpSelected
    case rideUnselected
    case deliveryUnselected
    case orderUnselected
    case rideSelected
    case deliverySelected
    case orderSelected
    case servicesSelected
    case serviceUnselected
    case backGray
    var asset: UIImage? {
        return UIImage(named: self.rawValue)
    }
}