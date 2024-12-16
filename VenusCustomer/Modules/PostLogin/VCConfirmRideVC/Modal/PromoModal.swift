//
//  PromoCodeModal.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 18/07/24.
//

import Foundation

class PromoModal: Codable{
    let flag : Int?
    let message : String?
    let data : promoCData?
}
struct promoCData : Codable {
    let action : String?
    let promo_code : String?
    let referral_type : Int?
    let codeId : Int?
    let codeMessage : String?
}
