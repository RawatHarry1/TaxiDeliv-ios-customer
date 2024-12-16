//
//  TripHistoryDetails.swift
//  VenusCustomer
//
//  Created by Amit on 16/11/23.
//

import Foundation

struct cancelScheduleModal: Codable{
    var flag: Int?
    var message : String?
}

struct TripHistoryDetails : Codable {
    let fare : Double?
    let net_customer_tax : Double?
    let fare_discount : Double?
    let trip_total: Double?
    var engagement_id : Int?
    let ride_date : String?
    let pickup_time : String?
    let pickup_address : String?
    let drop_address : String?
    let drop_time : String?
    let driver_rating : Int?
    let autos_status_text : String?
    let driver_image : String?
    let model_name : String?
    var driver_name : String?
    let driver_car_no : String?
    var tracking_image : String?

//    let drop_longitude : Int?
//    let driver_fare_id : Int?
//    let distance : Int?
    let preferred_payment_mode : Int?
//    let wait_time : Int?
//    let autos_status_color : String?
//    let vehicle_image : String?
//    let waiting_charges_applicable : Int?
//    let partner_type : String?
//    let vehicle_type : Int?
//    let drop_latitude : Int?
//    let nts_enabled : Int?
//    let ride_end_time : String?
   let discount_value : Double?
//    let total_rides_as_user : Int?
//    let addn_info : String?
//    let manually_edited : Int?
//    let autos_status_text : String?
//    let distance_travelled : Int?
//    let customer_fare_id : Int?
//    let debt_added : Int?
//    let currency_symbol : String?
//    let pool_ride_time : String?
    let to_pay : Double?
//    let brand : String?
//    let meter_fare_applicable : Int?
//    let pickup_longitude : Double?
//    let customer_cancellation_charges : Int?
//    let scheduled_ride_pickup_id : String?
//    let luggage_count : Int?
//    let base_fare : Double?
//    let nts_driver_details : String?
//    let last_4 : String?
//    let convenience_charge_waiver : Int?
//    let user_id : Int?
//    let status : Int?
//    let toll_charge : Int?
    let paid_using_mobikwik : Double?
//    let tip_amount : Int?
//    let convenience_charge : Int?
//    let utc_offset : String?
//    let currency : String?
//    let partner_name : String?
//    let rate_app_dialog_content : Rate_app_dialog_content?
//    let payment_mode_razorpay : Int?
//    let fare_factor : Int?
//    let venus_balance : Int?
//    let rate_app : Int?
//    let city : Int?
//    let ride_end_good_feedback_view_type : Int?
//    let flag : Int?
//    let distance_unit : String?
    let customer_tax_percentage : Double?
//    let skip_rating_by_customer : Int?
//    let accept_time : String?
    let paid_using_wallet : Double?
//    let engagement_date : String?
//    let cancellation_charges : Int?
//    let operator_id : Int?
//    let is_applepay_hyperpay : Int?
//    let is_corporate_ride : Int?
//    let pool_fare_id : String?
//    let pickup_latitude : Double?
//    let sub_region_id : Int?
//    let ride_type : Int?
//    let feedback_info : [Feedback_info]?
//    let paid_using_razorpay : Int?
//    let pf_tip_amount : Int?
//    let driver_id : Int?
    let paid_using_freecharge : Double?
//    let model_name : String?
    let paid_using_paytm : Double?
//    let ride_time : Int?
//    let is_invoiced : Int?
    let paid_using_stripe : Double?
//    let customer_fare_per_baggage : Int?
    var discount: [DiscountDataValue]?
    enum CodingKeys: String, CodingKey {

        case fare = "fare"
        case net_customer_tax = "net_customer_tax"
        case fare_discount = "fare_discount"
        case trip_total = "trip_total"
        case engagement_id = "engagement_id"
        case ride_date = "ride_date"
        case pickup_time = "pickup_time"
        case pickup_address = "pickup_address"
        case drop_address = "drop_address"
        case drop_time = "drop_time"
        case driver_rating = "driver_rating"
        case autos_status_text = "autos_status_text"
        case driver_image = "driver_image"
        case model_name = "model_name"
        case driver_name = "driver_name"
        case driver_car_no = "driver_car_no"
        case tracking_image = "tracking_image"
        case discount = "discount"
//        case drop_longitude = "drop_longitude"
//        case driver_fare_id = "driver_fare_id"
//        case distance = "distance"
        case preferred_payment_mode = "preferred_payment_mode"
//        case wait_time = "wait_time"
//        case autos_status_color = "autos_status_color"
//        case vehicle_image = "vehicle_image"
//        case waiting_charges_applicable = "waiting_charges_applicable"
//        case partner_type = "partner_type"
//        case vehicle_type = "vehicle_type"
//        case drop_latitude = "drop_latitude"
//        case net_customer_tax = "net_customer_tax"
//        case nts_enabled = "nts_enabled"
//        case ride_end_time = "ride_end_time"
        case discount_value = "discount_value"
//        case total_rides_as_user = "total_rides_as_user"
//        case addn_info = "addn_info"
//        case manually_edited = "manually_edited"
//        case autos_status_text = "autos_status_text"
//        case pickup_time = "pickup_time"
//        case engagement_id = "engagement_id"
//        case distance_travelled = "distance_travelled"
//        case customer_fare_id = "customer_fare_id"
//        case debt_added = "debt_added"
//        case currency_symbol = "currency_symbol"
//        case drop_address = "drop_address"
//        case pool_ride_time = "pool_ride_time"
        case to_pay = "to_pay"
//        case brand = "brand"
//        case meter_fare_applicable = "meter_fare_applicable"
//        case pickup_longitude = "pickup_longitude"
//        case customer_cancellation_charges = "customer_cancellation_charges"
//        case scheduled_ride_pickup_id = "scheduled_ride_pickup_id"
//        case luggage_count = "luggage_count"
//        case base_fare = "base_fare"
//        case nts_driver_details = "nts_driver_details"
//        case last_4 = "last_4"
//        case convenience_charge_waiver = "convenience_charge_waiver"
//        case user_id = "user_id"
//        case status = "status"
//        case toll_charge = "toll_charge"
        case paid_using_mobikwik = "paid_using_mobikwik"
//        case tip_amount = "tip_amount"
//        case convenience_charge = "convenience_charge"
//        case utc_offset = "utc_offset"
//        case ride_date = "ride_date"
//        case currency = "currency"
//        case partner_name = "partner_name"
//        case rate_app_dialog_content = "rate_app_dialog_content"
//        case payment_mode_razorpay = "payment_mode_razorpay"
//        case fare_factor = "fare_factor"
//        case venus_balance = "venus_balance"
//        case rate_app = "rate_app"
//        case fare = "fare"
//        case city = "city"
//        case ride_end_good_feedback_view_type = "ride_end_good_feedback_view_type"
//        case flag = "flag"
//        case distance_unit = "distance_unit"
        case customer_tax_percentage = "customer_tax_percentage"
//        case skip_rating_by_customer = "skip_rating_by_customer"
//        case accept_time = "accept_time"
        case paid_using_wallet = "paid_using_wallet"
//        case fare_discount = "fare_discount"
//        case engagement_date = "engagement_date"
//        case cancellation_charges = "cancellation_charges"
//        case drop_time = "drop_time"
//        case operator_id = "operator_id"
//        case pickup_address = "pickup_address"
//        case is_applepay_hyperpay = "is_applepay_hyperpay"
//        case is_corporate_ride = "is_corporate_ride"
//        case pool_fare_id = "pool_fare_id"
//        case pickup_latitude = "pickup_latitude"
//        case sub_region_id = "sub_region_id"
//        case ride_type = "ride_type"
//        case feedback_info = "feedback_info"
//        case paid_using_razorpay = "paid_using_razorpay"
//        case pf_tip_amount = "pf_tip_amount"
//        case driver_id = "driver_id"
//        case driver_rating = "driver_rating"
        case paid_using_freecharge = "paid_using_freecharge"
//        case model_name = "model_name"
        case paid_using_paytm = "paid_using_paytm"
//        case ride_time = "ride_time"
//        case is_invoiced = "is_invoiced"
        case paid_using_stripe = "paid_using_stripe"
//        case customer_fare_per_baggage = "customer_fare_per_baggage"
//        case trip_total = "trip_total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        pickup_time = try values.decodeIfPresent(String.self, forKey: .pickup_time)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        ride_date = try values.decodeIfPresent(String.self, forKey: .ride_date)
        fare_discount = try values.decodeIfPresent(Double.self, forKey: .fare_discount)
        fare = try values.decodeIfPresent(Double.self, forKey: .fare)
        driver_rating = try values.decodeIfPresent(Int.self, forKey: .driver_rating)
        pickup_address = try values.decodeIfPresent(String.self, forKey: .pickup_address)
        drop_time = try values.decodeIfPresent(String.self, forKey: .drop_time)
        net_customer_tax = try values.decodeIfPresent(Double.self, forKey: .net_customer_tax)
        trip_total = try values.decodeIfPresent(Double.self, forKey: .trip_total)
        autos_status_text = try values.decodeIfPresent(String.self, forKey: .autos_status_text)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        driver_name = try values.decodeIfPresent(String.self, forKey: .driver_name)
        driver_car_no = try values.decodeIfPresent(String.self, forKey: .driver_car_no)
        driver_image = try values.decodeIfPresent(String.self, forKey: .driver_image)
        tracking_image = try values.decodeIfPresent(String.self, forKey: .tracking_image)

//        drop_longitude = try values.decodeIfPresent(Int.self, forKey: .drop_longitude)
//        driver_fare_id = try values.decodeIfPresent(Int.self, forKey: .driver_fare_id)
//        distance = try values.decodeIfPresent(Int.self, forKey: .distance)
        preferred_payment_mode = try values.decodeIfPresent(Int.self, forKey: .preferred_payment_mode)
//        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
//        autos_status_color = try values.decodeIfPresent(String.self, forKey: .autos_status_color)
//        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
//        waiting_charges_applicable = try values.decodeIfPresent(Int.self, forKey: .waiting_charges_applicable)
//        partner_type = try values.decodeIfPresent(String.self, forKey: .partner_type)
//        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
//        drop_latitude = try values.decodeIfPresent(Int.self, forKey: .drop_latitude)
//        nts_enabled = try values.decodeIfPresent(Int.self, forKey: .nts_enabled)
//        ride_end_time = try values.decodeIfPresent(String.self, forKey: .ride_end_time)
        discount_value = try values.decodeIfPresent(Double.self, forKey: .discount_value)
//        total_rides_as_user = try values.decodeIfPresent(Int.self, forKey: .total_rides_as_user)
//        addn_info = try values.decodeIfPresent(String.self, forKey: .addn_info)
//        manually_edited = try values.decodeIfPresent(Int.self, forKey: .manually_edited)
//        autos_status_text = try values.decodeIfPresent(String.self, forKey: .autos_status_text)
//
//        distance_travelled = try values.decodeIfPresent(Int.self, forKey: .distance_travelled)
//        customer_fare_id = try values.decodeIfPresent(Int.self, forKey: .customer_fare_id)
//        debt_added = try values.decodeIfPresent(Int.self, forKey: .debt_added)
//        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
//        pool_ride_time = try values.decodeIfPresent(String.self, forKey: .pool_ride_time)
        to_pay = try values.decodeIfPresent(Double.self, forKey: .to_pay)
//        brand = try values.decodeIfPresent(String.self, forKey: .brand)
//        meter_fare_applicable = try values.decodeIfPresent(Int.self, forKey: .meter_fare_applicable)
//        pickup_longitude = try values.decodeIfPresent(Double.self, forKey: .pickup_longitude)
//        customer_cancellation_charges = try values.decodeIfPresent(Int.self, forKey: .customer_cancellation_charges)
//        scheduled_ride_pickup_id = try values.decodeIfPresent(String.self, forKey: .scheduled_ride_pickup_id)
//        luggage_count = try values.decodeIfPresent(Int.self, forKey: .luggage_count)
//        base_fare = try values.decodeIfPresent(Double.self, forKey: .base_fare)
//        nts_driver_details = try values.decodeIfPresent(String.self, forKey: .nts_driver_details)
//        last_4 = try values.decodeIfPresent(String.self, forKey: .last_4)
//        convenience_charge_waiver = try values.decodeIfPresent(Int.self, forKey: .convenience_charge_waiver)
//        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
//        status = try values.decodeIfPresent(Int.self, forKey: .status)
//        toll_charge = try values.decodeIfPresent(Int.self, forKey: .toll_charge)
        paid_using_mobikwik = try values.decodeIfPresent(Double.self, forKey: .paid_using_mobikwik)
//        tip_amount = try values.decodeIfPresent(Int.self, forKey: .tip_amount)
//        convenience_charge = try values.decodeIfPresent(Int.self, forKey: .convenience_charge)
//        utc_offset = try values.decodeIfPresent(String.self, forKey: .utc_offset)
//        currency = try values.decodeIfPresent(String.self, forKey: .currency)
//        partner_name = try values.decodeIfPresent(String.self, forKey: .partner_name)
//        rate_app_dialog_content = try values.decodeIfPresent(Rate_app_dialog_content.self, forKey: .rate_app_dialog_content)
//        payment_mode_razorpay = try values.decodeIfPresent(Int.self, forKey: .payment_mode_razorpay)
//        fare_factor = try values.decodeIfPresent(Int.self, forKey: .fare_factor)
//        venus_balance = try values.decodeIfPresent(Int.self, forKey: .venus_balance)
//        rate_app = try values.decodeIfPresent(Int.self, forKey: .rate_app)
//        city = try values.decodeIfPresent(Int.self, forKey: .city)
//        ride_end_good_feedback_view_type = try values.decodeIfPresent(Int.self, forKey: .ride_end_good_feedback_view_type)
//        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
//        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        customer_tax_percentage = try values.decodeIfPresent(Double.self, forKey: .customer_tax_percentage)
//        skip_rating_by_customer = try values.decodeIfPresent(Int.self, forKey: .skip_rating_by_customer)
//        accept_time = try values.decodeIfPresent(String.self, forKey: .accept_time)
        paid_using_wallet = try values.decodeIfPresent(Double.self, forKey: .paid_using_wallet)
//        engagement_date = try values.decodeIfPresent(String.self, forKey: .engagement_date)
//        cancellation_charges = try values.decodeIfPresent(Int.self, forKey: .cancellation_charges)
//        operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
//        is_applepay_hyperpay = try values.decodeIfPresent(Int.self, forKey: .is_applepay_hyperpay)
//        is_corporate_ride = try values.decodeIfPresent(Int.self, forKey: .is_corporate_ride)
//        pool_fare_id = try values.decodeIfPresent(String.self, forKey: .pool_fare_id)
//        pickup_latitude = try values.decodeIfPresent(Double.self, forKey: .pickup_latitude)
//        sub_region_id = try values.decodeIfPresent(Int.self, forKey: .sub_region_id)
//        ride_type = try values.decodeIfPresent(Int.self, forKey: .ride_type)
//        feedback_info = try values.decodeIfPresent([Feedback_info].self, forKey: .feedback_info)
//        paid_using_razorpay = try values.decodeIfPresent(Int.self, forKey: .paid_using_razorpay)
//        pf_tip_amount = try values.decodeIfPresent(Int.self, forKey: .pf_tip_amount)
//        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
       paid_using_freecharge = try values.decodeIfPresent(Double.self, forKey: .paid_using_freecharge)
//        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        paid_using_paytm = try values.decodeIfPresent(Double.self, forKey: .paid_using_paytm)
//        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
//        is_invoiced = try values.decodeIfPresent(Int.self, forKey: .is_invoiced)
        paid_using_stripe = try values.decodeIfPresent(Double.self, forKey: .paid_using_stripe)
        discount = try values.decodeIfPresent([DiscountDataValue].self, forKey: .discount)
//        customer_fare_per_baggage = try values.decodeIfPresent(Int.self, forKey: .customer_fare_per_baggage)
    }

    init() {
       fare = nil
       net_customer_tax = nil
       fare_discount = nil
       trip_total = nil
       engagement_id = nil
       ride_date = nil
       pickup_time = nil
       pickup_address = nil
       drop_address = nil
       drop_time = nil
       driver_rating = nil
       autos_status_text = nil
       driver_image = nil
       model_name = nil
       driver_name = nil
       driver_car_no = nil
        discount_value = nil
        paid_using_wallet = nil
        paid_using_paytm = nil
        paid_using_mobikwik = nil
        paid_using_stripe = nil
        paid_using_freecharge = nil
        customer_tax_percentage = nil
        to_pay = nil
        preferred_payment_mode = nil
    }

}

struct Feedback_info : Codable {
    let text_badges : [String]?
    let desc : String?
    let rating : Int?
    let image_badges : [String]?

    enum CodingKeys: String, CodingKey {

        case text_badges = "text_badges"
        case desc = "desc"
        case rating = "rating"
        case image_badges = "image_badges"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text_badges = try values.decodeIfPresent([String].self, forKey: .text_badges)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        rating = try values.decodeIfPresent(Int.self, forKey: .rating)
        image_badges = try values.decodeIfPresent([String].self, forKey: .image_badges)
    }

}

struct Rate_app_dialog_content : Codable {
    let confirm_button_text : String?
    let cancel_button_text : String?
    let never_button_text : String?
    let text : String?
    let url : String?
    let title : String?

    enum CodingKeys: String, CodingKey {

        case confirm_button_text = "confirm_button_text"
        case cancel_button_text = "cancel_button_text"
        case never_button_text = "never_button_text"
        case text = "text"
        case url = "url"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confirm_button_text = try values.decodeIfPresent(String.self, forKey: .confirm_button_text)
        cancel_button_text = try values.decodeIfPresent(String.self, forKey: .cancel_button_text)
        never_button_text = try values.decodeIfPresent(String.self, forKey: .never_button_text)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}
struct DiscountDataValue: Codable{
    var key: String?
    var value: Double?
}
