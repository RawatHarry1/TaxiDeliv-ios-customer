

import Foundation
struct getTripSummaryModal : Codable {
	let flag : Int?
	let message : String?
	let data : DataTripHistory?

	enum CodingKeys: String, CodingKey {

		case flag = "flag"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		flag = try values.decodeIfPresent(Int.self, forKey: .flag)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(DataTripHistory.self, forKey: .data)
	}

}
struct DataTripHistory : Codable {
    let engagement_id : Int?
    let is_applepay_hyperpay : Int?
    let driver_image : String?
    let user_id : Int?
    let driver_id : Int?
    let customer_cancellation_charges : Int?
    let tracking_image : String?
    let distance : String?
    let distance_travelled : Double?
    let pickup_address : String?
    let drop_address : String?
    let pickup_time : String?
    let drop_time : String?
    let cancellation_charges : Int?
    let ride_date : String?
    let vehicle_type : Int?
    let fare : Int?
    let discount_value : Int?
    let paid_using_wallet : Int?
    let paid_using_paytm : Int?
    let preferred_payment_mode : Int?
    let to_pay : Int?
    let wait_time : Int?
    let ride_time : Int?
    let ride_type : Int?
    let accept_time : String?
    let engagement_date : String?
    let status : Int?
    let paid_using_mobikwik : Int?
    let paid_using_stripe : Int?
    let waiting_charges_applicable : Int?
    let convenience_charge : Int?
    let sub_region_id : Int?
    let pool_fare_id : String?
    let paid_using_freecharge : Int?
    let customer_fare_id : Int?
    let driver_fare_id : Int?
    let paid_using_razorpay : Int?
    let payment_mode_razorpay : Int?
    let city : Int?
    let ride_end_time : String?
    let manually_edited : Int?
    let fare_discount : Int?
    let currency : String?
    let distance_unit : String?
    let operator_id : Int?
    let utc_offset : String?
    let toll_charge : Int?
    let tip_amount : Int?
    let luggage_count : Int?
    let customer_fare_per_baggage : Int?
    let net_customer_tax : Int?
    let customer_tax_percentage : Int?
    let partner_name : String?
    let partner_type : String?
    let pickup_latitude : Double?
    let pickup_longitude : Double?
    let drop_latitude : Int?
    let drop_longitude : Int?
    let currency_symbol : String?
    let is_invoiced : Int?
    let scheduled_ride_pickup_id : Int?
    let addn_info : String?
    let nts_driver_details : String?
    let nts_enabled : Int?
    let driver_rating : Int?
    let skip_rating_by_customer : Int?
    let meter_fare_applicable : Int?
    let pool_ride_time : String?
    let debt_added : Int?
    let pf_tip_amount : Int?
    let brand : String?
    let model_name : String?
    let vehicle_image : String?
    let autos_status_color : String?
    let autos_status_text : String?
    let is_corporate_ride : Int?
    let ride_end_time_utc : String?
    let luggage_charges : Int?
    let total_luggage_charges : Int?
    let is_pooled : Int?
    let trip_total : Int?
    let driver_name : String?
    let driver_car_no : String?
    let discount : [Discount]?
    let phone_no : String?
    let icon_set : String?
    let invoice_icon : String?
    let driver_upi : String?
    let base_fare : Int?
    let fare_factor : Int?
    let venus_balance : Int?
    let last_4 : String?
    let support_number : String?
    let feedback_info : [Feedback_info]?
    let total_rides_as_user : Int?

    enum CodingKeys: String, CodingKey {

        case engagement_id = "engagement_id"
        case is_applepay_hyperpay = "is_applepay_hyperpay"
        case driver_image = "driver_image"
        case user_id = "user_id"
        case driver_id = "driver_id"
        case customer_cancellation_charges = "customer_cancellation_charges"
        case tracking_image = "tracking_image"
        case distance = "distance"
        case distance_travelled = "distance_travelled"
        case pickup_address = "pickup_address"
        case drop_address = "drop_address"
        case pickup_time = "pickup_time"
        case drop_time = "drop_time"
        case cancellation_charges = "cancellation_charges"
        case ride_date = "ride_date"
        case vehicle_type = "vehicle_type"
        case fare = "fare"
        case discount_value = "discount_value"
        case paid_using_wallet = "paid_using_wallet"
        case paid_using_paytm = "paid_using_paytm"
        case preferred_payment_mode = "preferred_payment_mode"
        case to_pay = "to_pay"
        case wait_time = "wait_time"
        case ride_time = "ride_time"
        case ride_type = "ride_type"
        case accept_time = "accept_time"
        case engagement_date = "engagement_date"
        case status = "status"
        case paid_using_mobikwik = "paid_using_mobikwik"
        case paid_using_stripe = "paid_using_stripe"
        case waiting_charges_applicable = "waiting_charges_applicable"
        case convenience_charge = "convenience_charge"
        case sub_region_id = "sub_region_id"
        case pool_fare_id = "pool_fare_id"
        case paid_using_freecharge = "paid_using_freecharge"
        case customer_fare_id = "customer_fare_id"
        case driver_fare_id = "driver_fare_id"
        case paid_using_razorpay = "paid_using_razorpay"
        case payment_mode_razorpay = "payment_mode_razorpay"
        case city = "city"
        case ride_end_time = "ride_end_time"
        case manually_edited = "manually_edited"
        case fare_discount = "fare_discount"
        case currency = "currency"
        case distance_unit = "distance_unit"
        case operator_id = "operator_id"
        case utc_offset = "utc_offset"
        case toll_charge = "toll_charge"
        case tip_amount = "tip_amount"
        case luggage_count = "luggage_count"
        case customer_fare_per_baggage = "customer_fare_per_baggage"
        case net_customer_tax = "net_customer_tax"
        case customer_tax_percentage = "customer_tax_percentage"
        case partner_name = "partner_name"
        case partner_type = "partner_type"
        case pickup_latitude = "pickup_latitude"
        case pickup_longitude = "pickup_longitude"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case currency_symbol = "currency_symbol"
        case is_invoiced = "is_invoiced"
        case scheduled_ride_pickup_id = "scheduled_ride_pickup_id"
        case addn_info = "addn_info"
        case nts_driver_details = "nts_driver_details"
        case nts_enabled = "nts_enabled"
        case driver_rating = "driver_rating"
        case skip_rating_by_customer = "skip_rating_by_customer"
        case meter_fare_applicable = "meter_fare_applicable"
        case pool_ride_time = "pool_ride_time"
        case debt_added = "debt_added"
        case pf_tip_amount = "pf_tip_amount"
        case brand = "brand"
        case model_name = "model_name"
        case vehicle_image = "vehicle_image"
        case autos_status_color = "autos_status_color"
        case autos_status_text = "autos_status_text"
        case is_corporate_ride = "is_corporate_ride"
        case ride_end_time_utc = "ride_end_time_utc"
        case luggage_charges = "luggage_charges"
        case total_luggage_charges = "total_luggage_charges"
        case is_pooled = "is_pooled"
        case trip_total = "trip_total"
        case driver_name = "driver_name"
        case driver_car_no = "driver_car_no"
        case discount = "discount"
        case phone_no = "phone_no"
        case icon_set = "icon_set"
        case invoice_icon = "invoice_icon"
        case driver_upi = "driver_upi"
        case base_fare = "base_fare"
        case fare_factor = "fare_factor"
        case venus_balance = "venus_balance"
        case last_4 = "last_4"
        case feedback_info = "feedback_info"
        case total_rides_as_user = "total_rides_as_user"
        case support_number = "support_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        is_applepay_hyperpay = try values.decodeIfPresent(Int.self, forKey: .is_applepay_hyperpay)
        driver_image = try values.decodeIfPresent(String.self, forKey: .driver_image)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        customer_cancellation_charges = try values.decodeIfPresent(Int.self, forKey: .customer_cancellation_charges)
        tracking_image = try values.decodeIfPresent(String.self, forKey: .tracking_image)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        distance_travelled = try values.decodeIfPresent(Double.self, forKey: .distance_travelled)
        pickup_address = try values.decodeIfPresent(String.self, forKey: .pickup_address)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        pickup_time = try values.decodeIfPresent(String.self, forKey: .pickup_time)
        drop_time = try values.decodeIfPresent(String.self, forKey: .drop_time)
        cancellation_charges = try values.decodeIfPresent(Int.self, forKey: .cancellation_charges)
        ride_date = try values.decodeIfPresent(String.self, forKey: .ride_date)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        fare = try values.decodeIfPresent(Int.self, forKey: .fare)
        discount_value = try values.decodeIfPresent(Int.self, forKey: .discount_value)
        paid_using_wallet = try values.decodeIfPresent(Int.self, forKey: .paid_using_wallet)
        paid_using_paytm = try values.decodeIfPresent(Int.self, forKey: .paid_using_paytm)
        preferred_payment_mode = try values.decodeIfPresent(Int.self, forKey: .preferred_payment_mode)
        to_pay = try values.decodeIfPresent(Int.self, forKey: .to_pay)
        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
        ride_type = try values.decodeIfPresent(Int.self, forKey: .ride_type)
        accept_time = try values.decodeIfPresent(String.self, forKey: .accept_time)
        engagement_date = try values.decodeIfPresent(String.self, forKey: .engagement_date)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        paid_using_mobikwik = try values.decodeIfPresent(Int.self, forKey: .paid_using_mobikwik)
        paid_using_stripe = try values.decodeIfPresent(Int.self, forKey: .paid_using_stripe)
        waiting_charges_applicable = try values.decodeIfPresent(Int.self, forKey: .waiting_charges_applicable)
        convenience_charge = try values.decodeIfPresent(Int.self, forKey: .convenience_charge)
        sub_region_id = try values.decodeIfPresent(Int.self, forKey: .sub_region_id)
        pool_fare_id = try values.decodeIfPresent(String.self, forKey: .pool_fare_id)
        paid_using_freecharge = try values.decodeIfPresent(Int.self, forKey: .paid_using_freecharge)
        customer_fare_id = try values.decodeIfPresent(Int.self, forKey: .customer_fare_id)
        driver_fare_id = try values.decodeIfPresent(Int.self, forKey: .driver_fare_id)
        paid_using_razorpay = try values.decodeIfPresent(Int.self, forKey: .paid_using_razorpay)
        payment_mode_razorpay = try values.decodeIfPresent(Int.self, forKey: .payment_mode_razorpay)
        city = try values.decodeIfPresent(Int.self, forKey: .city)
        ride_end_time = try values.decodeIfPresent(String.self, forKey: .ride_end_time)
        manually_edited = try values.decodeIfPresent(Int.self, forKey: .manually_edited)
        fare_discount = try values.decodeIfPresent(Int.self, forKey: .fare_discount)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
        utc_offset = try values.decodeIfPresent(String.self, forKey: .utc_offset)
        toll_charge = try values.decodeIfPresent(Int.self, forKey: .toll_charge)
        tip_amount = try values.decodeIfPresent(Int.self, forKey: .tip_amount)
        luggage_count = try values.decodeIfPresent(Int.self, forKey: .luggage_count)
        customer_fare_per_baggage = try values.decodeIfPresent(Int.self, forKey: .customer_fare_per_baggage)
        net_customer_tax = try values.decodeIfPresent(Int.self, forKey: .net_customer_tax)
        customer_tax_percentage = try values.decodeIfPresent(Int.self, forKey: .customer_tax_percentage)
        partner_name = try values.decodeIfPresent(String.self, forKey: .partner_name)
        partner_type = try values.decodeIfPresent(String.self, forKey: .partner_type)
        pickup_latitude = try values.decodeIfPresent(Double.self, forKey: .pickup_latitude)
        pickup_longitude = try values.decodeIfPresent(Double.self, forKey: .pickup_longitude)
        drop_latitude = try values.decodeIfPresent(Int.self, forKey: .drop_latitude)
        drop_longitude = try values.decodeIfPresent(Int.self, forKey: .drop_longitude)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        is_invoiced = try values.decodeIfPresent(Int.self, forKey: .is_invoiced)
        scheduled_ride_pickup_id = try values.decodeIfPresent(Int.self, forKey: .scheduled_ride_pickup_id)
        addn_info = try values.decodeIfPresent(String.self, forKey: .addn_info)
        nts_driver_details = try values.decodeIfPresent(String.self, forKey: .nts_driver_details)
        nts_enabled = try values.decodeIfPresent(Int.self, forKey: .nts_enabled)
        driver_rating = try values.decodeIfPresent(Int.self, forKey: .driver_rating)
        skip_rating_by_customer = try values.decodeIfPresent(Int.self, forKey: .skip_rating_by_customer)
        meter_fare_applicable = try values.decodeIfPresent(Int.self, forKey: .meter_fare_applicable)
        pool_ride_time = try values.decodeIfPresent(String.self, forKey: .pool_ride_time)
        debt_added = try values.decodeIfPresent(Int.self, forKey: .debt_added)
        pf_tip_amount = try values.decodeIfPresent(Int.self, forKey: .pf_tip_amount)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
        autos_status_color = try values.decodeIfPresent(String.self, forKey: .autos_status_color)
        autos_status_text = try values.decodeIfPresent(String.self, forKey: .autos_status_text)
        is_corporate_ride = try values.decodeIfPresent(Int.self, forKey: .is_corporate_ride)
        ride_end_time_utc = try values.decodeIfPresent(String.self, forKey: .ride_end_time_utc)
        luggage_charges = try values.decodeIfPresent(Int.self, forKey: .luggage_charges)
        total_luggage_charges = try values.decodeIfPresent(Int.self, forKey: .total_luggage_charges)
        is_pooled = try values.decodeIfPresent(Int.self, forKey: .is_pooled)
        trip_total = try values.decodeIfPresent(Int.self, forKey: .trip_total)
        driver_name = try values.decodeIfPresent(String.self, forKey: .driver_name)
        driver_car_no = try values.decodeIfPresent(String.self, forKey: .driver_car_no)
        discount = try values.decodeIfPresent([Discount].self, forKey: .discount)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        icon_set = try values.decodeIfPresent(String.self, forKey: .icon_set)
        invoice_icon = try values.decodeIfPresent(String.self, forKey: .invoice_icon)
        driver_upi = try values.decodeIfPresent(String.self, forKey: .driver_upi)
        base_fare = try values.decodeIfPresent(Int.self, forKey: .base_fare)
        fare_factor = try values.decodeIfPresent(Int.self, forKey: .fare_factor)
        venus_balance = try values.decodeIfPresent(Int.self, forKey: .venus_balance)
        last_4 = try values.decodeIfPresent(String.self, forKey: .last_4)
        feedback_info = try values.decodeIfPresent([Feedback_info].self, forKey: .feedback_info)
        total_rides_as_user = try values.decodeIfPresent(Int.self, forKey: .total_rides_as_user)
        support_number = try values.decodeIfPresent(String.self, forKey: .support_number)
    }

}
struct Discount : Codable {
    let key : String?
    let value : Int?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
    }

}
