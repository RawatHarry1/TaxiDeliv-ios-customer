//
//  UserModel.swift
//  VenusCustomer
//
//  Created by AB on 21/10/23.
//

import Foundation

struct UserModel : Codable {
    let flag : Int?
    let access_token : String?
    var login : LoginModel?

    // MARK: - Parameters
    static var currentUser = UserModel.getFromUserDefaults() {
        didSet {
            UserModel.currentUser.saveToUserDefaults()
        }
    }

    enum CodingKeys: String, CodingKey {
        case flag = "flag"
        case access_token = "access_token"
        case login = "login"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        login = try values.decodeIfPresent(LoginModel.self, forKey: .login)
    }

    init() {
        flag = nil
        access_token = nil
        login = nil
    }

    // MARK: - Custom Functions
    private func saveToUserDefaults() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        VCUserDefaults.save(value: data, forKey: .userData)
    }

    private static func getFromUserDefaults() -> UserModel {
        guard let data = try? VCUserDefaults.value(forKey: .userData).rawData(), let user = try? JSONDecoder().decode(UserModel.self, from: data) else { return UserModel() }
        return user
    }
}

struct LoginModel : Codable {
    let registration_steps : Registration_steps?
    let date_format : String?
    let vehicle_type : Int?
    let req_inactive_drivers : Int?
    var actual_credit_balance : Double?
    var user_name : String?
    let driver_dob_input : String?
    let driver_tag : Int?
    let driver_traction_api_interval : Int?
    let vehicle_model_enabled : Int?
    let show_wallet : Int?
    let wallet_balance: Double?
    let vehicle_year : String?
    let country_code : Int?
    let incentive_enabled : Int?
    let driver_image : String?
    let is_registration_complete : Bool?
    let multiple_vehicles_enabled : Int?
    var registration_step_completed : Registration_step_completed?
    var min_driver_balance : Double?
    let driver_rating : String?
    let enable_vehicle_edit_setting : Int?
    let mandatory_registration_steps : Mandatory_registration_steps?
    let phone_no : String?
    let user_email : String?
    let driver_gender_filter : String?
    let driver_subscription : Int?
    let mlm_jul_enabled : Int?
    let ownership_status : String?
    let show_bank_list : Int?
    let city : Int?
    let deactivation_reasons_driver : [String]?
    let user_id : Int?
    let show_payouts : Int?
    let vehicle_no : String?
    let make_details : DefaultVehicleDetails?
    let currency_symbol : String?
    var driver_document_status : DriverDocStatus?
    var driver_blocked_multiple_cancelation : Driver_blocked_multiple_cancelation?
    let cancellation_reasons : [String]?
    let is_threshold_reached : Int?
    let user_ratings : Double?
    var is_customer_profile_complete : Int?
    var stripeCredentials : stripeCredentialsDa?
    var referral_code : String?
    var referral_data : refral_data?
    var referral_link : String?
    var popup : popupData?
    var banner :[bannerData]?
    var user_image : String?
    var vehicle_types :[vechleType]?
    var package_details: [packageDetails]?
    var package_types : [String]?
    
    
    enum CodingKeys: String, CodingKey {
        case referral_code = "referral_code"
        case referral_data = "referral_data"
        case referral_link = "referral_link"
        case registration_steps = "registration_steps"
        case date_format = "date_format"
        case vehicle_type = "vehicle_type"
        case req_inactive_drivers = "req_inactive_drivers"
        case actual_credit_balance = "actual_credit_balance"
        case user_name = "user_name"
        case driver_dob_input = "driver_dob_input"
        case driver_tag = "driver_tag"
        case driver_traction_api_interval = "driver_traction_api_interval"
        case vehicle_model_enabled = "vehicle_model_enabled"
        case show_wallet = "show_wallet"
        case vehicle_year = "vehicle_year"
        case country_code = "country_code"
        case incentive_enabled = "incentive_enabled"
        case driver_image = "driver_image"
        case is_registration_complete = "is_registration_complete"
        case multiple_vehicles_enabled = "multiple_vehicles_enabled"
        case registration_step_completed = "registration_step_completed"
        case min_driver_balance = "min_driver_balance"
        case driver_rating = "driver_rating"
        case enable_vehicle_edit_setting = "enable_vehicle_edit_setting"
        case mandatory_registration_steps = "mandatory_registration_steps"
        case phone_no = "phone_no"
        case user_email = "user_email"
        case driver_gender_filter = "driver_gender_filter"
        case driver_subscription = "driver_subscription"
        case mlm_jul_enabled = "mlm_jul_enabled"
        case ownership_status = "ownership_status"
        case show_bank_list = "show_bank_list"
        case city = "city_id"
        case deactivation_reasons_driver = "deactivation_reasons_driver"
        case user_id = "user_id"
        case show_payouts = "show_payouts"
        case vehicle_no = "vehicle_no"
        case make_details = "make_details"
        case currency_symbol = "currency_symbol"
        case driver_document_status = "driver_document_status"
        case driver_blocked_multiple_cancelation = "driver_blocked_multiple_cancelation"
        case cancellation_reasons = "cancellation_reasons"
        case is_threshold_reached = "is_threshold_reached"
        case is_customer_profile_complete = "is_customer_profile_complete"
        case wallet_balance = "wallet_balance"
        case user_ratings = "user_ratings"
        case stripeCredentials = "stripeCredentials"
        case popup = "popup"
        case banner = "banner"
        case user_image = "user_image"
        case vehicle_types = "vehicle_types"
        case package_details = "package_details"
        case package_types = "package_types"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        registration_steps = try values.decodeIfPresent(Registration_steps.self, forKey: .registration_steps)
        date_format = try values.decodeIfPresent(String.self, forKey: .date_format)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        req_inactive_drivers = try values.decodeIfPresent(Int.self, forKey: .req_inactive_drivers)
        actual_credit_balance = try values.decodeIfPresent(Double.self, forKey: .actual_credit_balance)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        driver_dob_input = try values.decodeIfPresent(String.self, forKey: .driver_dob_input)
        driver_tag = try values.decodeIfPresent(Int.self, forKey: .driver_tag)
        driver_traction_api_interval = try values.decodeIfPresent(Int.self, forKey: .driver_traction_api_interval)
        vehicle_model_enabled = try values.decodeIfPresent(Int.self, forKey: .vehicle_model_enabled)
        show_wallet = try values.decodeIfPresent(Int.self, forKey: .show_wallet)
        do {
            vehicle_year = try values.decodeIfPresent(String.self, forKey: .vehicle_year) ?? "2001"
        } catch {
            vehicle_year = "2001"
        }
        country_code = try values.decodeIfPresent(Int.self, forKey: .country_code)
        incentive_enabled = try values.decodeIfPresent(Int.self, forKey: .incentive_enabled)
        driver_image = try values.decodeIfPresent(String.self, forKey: .driver_image)
        is_registration_complete = try values.decodeIfPresent(Bool.self, forKey: .is_registration_complete)
        multiple_vehicles_enabled = try values.decodeIfPresent(Int.self, forKey: .multiple_vehicles_enabled)
        registration_step_completed = try values.decodeIfPresent(Registration_step_completed.self, forKey: .registration_step_completed)
        min_driver_balance = try values.decodeIfPresent(Double.self, forKey: .min_driver_balance)
        driver_rating = try values.decodeIfPresent(String.self, forKey: .driver_rating)
        enable_vehicle_edit_setting = try values.decodeIfPresent(Int.self, forKey: .enable_vehicle_edit_setting)
        mandatory_registration_steps = try values.decodeIfPresent(Mandatory_registration_steps.self, forKey: .mandatory_registration_steps)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        user_email = try values.decodeIfPresent(String.self, forKey: .user_email)
        driver_gender_filter = try values.decodeIfPresent(String.self, forKey: .driver_gender_filter)
        driver_subscription = try values.decodeIfPresent(Int.self, forKey: .driver_subscription)
        mlm_jul_enabled = try values.decodeIfPresent(Int.self, forKey: .mlm_jul_enabled)
        ownership_status = try values.decodeIfPresent(String.self, forKey: .ownership_status)
        show_bank_list = try values.decodeIfPresent(Int.self, forKey: .show_bank_list)
        city = try values.decodeIfPresent(Int.self, forKey: .city)
        deactivation_reasons_driver = try values.decodeIfPresent([String].self, forKey: .deactivation_reasons_driver)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        show_payouts = try values.decodeIfPresent(Int.self, forKey: .show_payouts)
        vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
        make_details = try values.decodeIfPresent(DefaultVehicleDetails.self, forKey: .make_details)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        driver_document_status = try values.decodeIfPresent(DriverDocStatus.self, forKey: .driver_document_status)
        driver_blocked_multiple_cancelation = try values.decodeIfPresent(Driver_blocked_multiple_cancelation.self, forKey: .driver_blocked_multiple_cancelation)
        cancellation_reasons = try values.decodeIfPresent([String].self, forKey: .cancellation_reasons)
        is_threshold_reached = try values.decodeIfPresent(Int.self, forKey: .is_threshold_reached)
        is_customer_profile_complete = try values.decodeIfPresent(Int.self, forKey: .is_customer_profile_complete)
        wallet_balance = try values.decodeIfPresent(Double.self, forKey: .wallet_balance)
        user_ratings = try values.decodeIfPresent(Double.self, forKey: .user_ratings)
        stripeCredentials = try values.decodeIfPresent(stripeCredentialsDa.self, forKey: .stripeCredentials)
        referral_code = try values.decodeIfPresent(String.self, forKey: .referral_code)
        referral_link = try values.decodeIfPresent(String.self, forKey: .referral_link)
        referral_data = try values.decodeIfPresent(refral_data.self, forKey: .referral_data)
        popup = try values.decodeIfPresent(popupData.self, forKey: .popup)
        banner = try values.decodeIfPresent([bannerData].self, forKey: .banner)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        vehicle_types = try values.decodeIfPresent([vechleType].self, forKey: .vehicle_types)
        package_details  = try values.decodeIfPresent([packageDetails].self, forKey: .package_details)
        
        package_types  = try values.decodeIfPresent([String].self, forKey: .package_types)
    }


    init() {
        package_types = nil
        package_details = nil
        vehicle_types = nil
        registration_steps = nil
        date_format = nil
        vehicle_type = nil
        req_inactive_drivers = nil
        actual_credit_balance = nil
        user_name = nil
        driver_dob_input = nil
        driver_tag = nil
        driver_traction_api_interval = nil
        vehicle_model_enabled = nil
        show_wallet = nil
        vehicle_year = nil
        country_code = nil
        incentive_enabled = nil
        driver_image = nil
        is_registration_complete = nil
        multiple_vehicles_enabled = nil
        registration_step_completed = nil
        min_driver_balance = nil
        driver_rating = nil
        enable_vehicle_edit_setting = nil
        mandatory_registration_steps = nil
        phone_no = nil
        user_email = nil
        driver_gender_filter = nil
        driver_subscription = nil
        mlm_jul_enabled = nil
        ownership_status = nil
        show_bank_list = nil
        city = nil
        deactivation_reasons_driver = nil
        user_id = nil
        show_payouts = nil
        vehicle_no = nil
        make_details = nil
        currency_symbol = nil
        driver_document_status = nil
        driver_blocked_multiple_cancelation = nil
        cancellation_reasons = nil
        is_threshold_reached = nil
        is_customer_profile_complete = nil
        wallet_balance = nil
        user_ratings = nil
        stripeCredentials = nil
        referral_code = nil
        referral_link = nil
        referral_data = nil
        popup = nil
        banner = nil
        user_image = nil
    }
}

struct Mandatory_registration_steps : Codable {
    let is_bank_details_mandatory : Bool
    let is_document_upload_mandatory : Bool
    let is_profile_mandatory : Bool
    let is_vehicle_info_mandatory : Bool

    enum CodingKeys: String, CodingKey {
        case is_bank_details_mandatory = "is_bank_details_mandatory"
        case is_document_upload_mandatory = "is_document_upload_mandatory"
        case is_profile_mandatory = "is_profile_mandatory"
        case is_vehicle_info_mandatory = "is_vehicle_info_mandatory"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_bank_details_mandatory = try values.decodeIfPresent(Bool.self, forKey: .is_bank_details_mandatory) ?? true
        is_document_upload_mandatory = try values.decodeIfPresent(Bool.self, forKey: .is_document_upload_mandatory) ?? true
        is_profile_mandatory = try values.decodeIfPresent(Bool.self, forKey: .is_profile_mandatory) ?? true
        is_vehicle_info_mandatory = try values.decodeIfPresent(Bool.self, forKey: .is_vehicle_info_mandatory) ?? true

    }

    init() {
        is_bank_details_mandatory = true
        is_document_upload_mandatory = true
        is_profile_mandatory = true
        is_vehicle_info_mandatory = true
    }
}


struct Registration_step_completed : Codable {
    var is_document_uploaded : Bool
    var is_profile_completed : Bool
    var is_bank_details_completed : Bool
    var is_vehicle_info_completed : Bool

    enum CodingKeys: String, CodingKey {
        case is_document_uploaded = "is_document_uploaded"
        case is_profile_completed = "is_profile_completed"
        case is_bank_details_completed = "is_bank_details_completed"
        case is_vehicle_info_completed = "is_vehicle_info_completed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_document_uploaded = try values.decodeIfPresent(Bool.self, forKey: .is_document_uploaded) ?? false
        is_profile_completed = try values.decodeIfPresent(Bool.self, forKey: .is_profile_completed) ?? false
        is_bank_details_completed = try values.decodeIfPresent(Bool.self, forKey: .is_bank_details_completed) ?? false
        is_vehicle_info_completed = try values.decodeIfPresent(Bool.self, forKey: .is_vehicle_info_completed) ?? false
    }

    init() {
        is_document_uploaded = false
        is_profile_completed = false
        is_bank_details_completed = false
        is_vehicle_info_completed = false
    }
}


struct Registration_steps : Codable {
    let vehicle_info : Int?
    let profile : Int?
    let document_upload : Int?
    let bank_details : Int?

    enum CodingKeys: String, CodingKey {

        case vehicle_info = "vehicle_info"
        case profile = "profile"
        case document_upload = "document_upload"
        case bank_details = "bank_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vehicle_info = try values.decodeIfPresent(Int.self, forKey: .vehicle_info)
        profile = try values.decodeIfPresent(Int.self, forKey: .profile)
        document_upload = try values.decodeIfPresent(Int.self, forKey: .document_upload)
        bank_details = try values.decodeIfPresent(Int.self, forKey: .bank_details)
    }

}

struct DefaultVehicleDetails : Codable {
    let model_id : Int?
    let door_id : Int?
    let brand : String?
    let color : String?
    let id : Int?
    let no_of_seat_belts : String?
    let vehicle_image : String?
    let seat_belt_id : Int?
    let no_of_doors : String?
    let updated_at : String?
    let color_id : Int?
    let vehicle_type : Int?
    let created_at : String?
    let model_name : String?

    enum CodingKeys: String, CodingKey {

        case model_id = "model_id"
        case door_id = "door_id"
        case brand = "brand"
        case color = "color"
        case id = "id"
        case no_of_seat_belts = "no_of_seat_belts"
        case vehicle_image = "vehicle_image"
        case seat_belt_id = "seat_belt_id"
        case no_of_doors = "no_of_doors"
        case updated_at = "updated_at"
        case color_id = "color_id"
        case vehicle_type = "vehicle_type"
        case created_at = "created_at"
        case model_name = "model_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        model_id = try values.decodeIfPresent(Int.self, forKey: .model_id)
        door_id = try values.decodeIfPresent(Int.self, forKey: .door_id)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        no_of_seat_belts = try values.decodeIfPresent(String.self, forKey: .no_of_seat_belts)
        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
        seat_belt_id = try values.decodeIfPresent(Int.self, forKey: .seat_belt_id)
        no_of_doors = try values.decodeIfPresent(String.self, forKey: .no_of_doors)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        color_id = try values.decodeIfPresent(Int.self, forKey: .color_id)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
    }

}

struct DriverDocStatus : Codable {
    let error : String?
    var requiredDocsStatus : String?

    enum CodingKeys: String, CodingKey {

        case error = "error"
        case requiredDocsStatus = "requiredDocsStatus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        requiredDocsStatus = try values.decodeIfPresent(String.self, forKey: .requiredDocsStatus)
    }

}

struct BlockDriverModel : Codable {
    var driver_blocked_multiple_cancelation : Driver_blocked_multiple_cancelation?

    enum CodingKeys: String, CodingKey {

        case driver_blocked_multiple_cancelation = "driver_blocked_multiple_cancelation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        driver_blocked_multiple_cancelation = try values.decodeIfPresent(Driver_blocked_multiple_cancelation.self, forKey: .driver_blocked_multiple_cancelation)
    }

}

struct Driver_blocked_multiple_cancelation : Codable {
    var blocked : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case blocked = "blocked"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        blocked = try values.decodeIfPresent(Int.self, forKey: .blocked)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
struct stripeCredentialsDa: Codable{
    var publishable_key : String?
    var client_secret: String?
    enum CodingKeys: String, CodingKey {

        case publishable_key = "publishable_key"
        case client_secret = "client_secret"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publishable_key = try values.decodeIfPresent(String.self, forKey: .publishable_key)
        client_secret = try values.decodeIfPresent(String.self, forKey: .client_secret)
    }
}
struct refral_data:Codable{
    var branch_android_url : String?
    var branch_desktop_url: String?
    var branch_fallback_url: String?
    var branch_ios_url: String?
    var fb_share_caption: String?
    var fb_share_description: String?
    var invite_earn_more_info: String?
    var invite_earn_short_msg: String?
    var referral_caption: String?
    var referral_cashback_popup_text: String?
    var referral_email_subject: String?
    var referral_image_d2c: String?
    var referral_image_d2d: String?
    var referral_message: String?
    var referral_sharing_message: String?
}
struct popupData:Codable{
    var download_link: String?
    var force_to_version:Int?
    var is_force: Int?
    var popup_text : String?
}
struct bannerData:Codable{
    var action_url : String?
    var banner_image : String?
    var banner_text : String?
}
struct vechleType: Codable{
    var images : String?
    var region_id : Int?
    var region_name : String?
    var vehicle_type: Int?
}
struct packageDetails:Codable{
    
    var package_3d_image: String?
    var package_description : String?
    var package_height: Int?
    var package_id : Int?
    var package_length: Int?
    var package_size : String?
    var package_size_units : String?
    var package_weight : Double?
    var package_width: Double?
}
