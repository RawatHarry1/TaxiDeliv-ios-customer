//
//  VDColors.swift
//  VenusCustomer
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VCColors: String, CaseIterable {

    case textColor
    case textColorGrey
    case textColorWhite
    case buttonSelectedOrange
    case buttonBorder
    case textFieldBorder
    case placeHolderColor
    case signUpSelection
    case otpBackground
    case otpBorder
    case signupColor
    case buttonGreen

    var color: UIColor {
        return UIColor(named: rawValue)!
    }
}
