

import Foundation
struct PromoCodeModal : Codable {
	let flag : Int?
	let data : PromoCodeData?
	let head : String?



}
struct PromoCodeData : Codable {
    let coupons : [Coupons]?
    let promotions : [promotionsData]?
    let commonOromotions : [String]?
    let commonCoupons : [String]?
    let autosPromotions : [String]?
    let autosCoupons : [AutosCoupons]?
    let freshPromotions : [String]?
    let freshCoupons : [String]?
    let payPromotions : [String]?
    let payCoupons : [String]?
    let prosPromotions : [String]?
    let prosCoupons : [String]?
    let suryaPromotions : [String]?
    let suryaCoupons : [String]?
    let promoCodes : [PromoCodes]?
    let inviteMessage : String?
}
struct Coupons : Codable {
    let coupon_id : Int?
    let title : String?
    let subtitle : String?
    let description : String?
    let coupon_type : Int?
    let type : Int?
    let discount_percentage : Int?
    let discount_maximum : Int?
    let discount : Int?
    let maximum : Int?
    let benefit_type : Int?
    let cashback_percentage : Int?
    let start_time : String?
    let end_time : String?
    let image : String?
    let operator_id : Int?
    let drop_latitude : Int?
    let drop_longitude : Int?
    let drop_radius : Int?
    let allowed_vehicles : [Int]?
    let account_id : Int?
    let redeemed_on : String?
    let status : Int?
    let expiry_date : String?
    let is_selected : Int?
    let coupon_card_type : Int?
    let is_scratched : Int?
    let autos : Int?
    let fresh : Int?
    let menus : Int?
    let meals : Int?
    let delivery_customer : Int?
    let grocery : Int?
}
struct AutosCoupons : Codable {
    let coupon_id : Int?
    let title : String?
    let subtitle : String?
    let description : String?
    let coupon_type : Int?
    let type : Int?
    let discount_percentage : Int?
    let discount_maximum : Int?
    let discount : Int?
    let maximum : Int?
    let benefit_type : Int?
    let cashback_percentage : Int?
    let start_time : String?
    let end_time : String?
    let image : String?
    let operator_id : Int?
    let drop_latitude : Int?
    let drop_longitude : Int?
    let drop_radius : Int?
    let allowed_vehicles : [Int]?
    let account_id : Int?
    let redeemed_on : String?
    let status : Int?
    let expiry_date : String?
    let is_selected : Int?
    let coupon_card_type : Int?
    let is_scratched : Int?
    let autos : Int?
    let fresh : Int?
    let menus : Int?
    let meals : Int?
    let delivery_customer : Int?
    let grocery : Int?
    
}

struct promotionsData: Codable{
    
    var promo_id: Int?
    var title: String?
    var promo_type: Int?
    var multiple_locations_allowed:Int?
    var benefit_type: Int?
    var cashback_percentage: Double?
    var pickup_latitude: Double?
    var pickup_longitude: Double?
    var pickup_radius: Double?
    var drop_latitude: Double?
    var is_active: Int?
    var promo_provider: Int?
    var city: Int?
    var start_time: String?
    var end_time: String?
    var start_from: String?
    var end_on: String?
    var drop_longitude: Double?
    var drop_radius:Double?
    var locations_coordinates:String?
    var terms_n_conds: String?
    var per_user_limit: Int?
    var is_selected: Int?
    //var allowed_vehicles":
    var per_day_limit: Int?
    var operator_id: Int?
   // var is_pass": null,
   // var amount": null,
    //var validity": null,
    var num_txns: Int?
    var remove_coupons: Int?
    var todays_txns: Int?
    var validity_text: String?
    var promo_text: String?
    
}
struct PromoCodes : Codable {
    let promo_code : String?
    let money_to_add : Int?
    let bonus_type : Int?
    let city_id : String?
    let coupons_validity_autos : Int?
    let start_date : String?
    let end_date : String?
    let max_number : Int?
    let num_redeemed : Int?
    let promo_type : Int?
    let user_type : Int?
    let is_active : Int?
    let coupon_id_autos : Int?
    let promo_id : Int?
    let promo_owner_client_id : String?
}
