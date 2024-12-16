
import Foundation
struct Drivers : Codable {
	let region_ids : [Int]?
	let customers_rated : Double?
	let vehicle_brand : String?
	let vehicle_type : Int?
	let vehicle_no : String?
	let car_no : String?
	let city_id : Int?
	let rating : Double?
    let device_token : String?
    let status : Int?
    let longitude : Double?
    let driver_id : Int?
    let driver_image : String?
    let distance : Double?
    let user_id : Int?
    let bearing : Double?
    let latitude : Double?

//	let battery_percentage : Int?
//	let vehicle_name : String?
//	let user_name : String?
//	let vehicle_make_id : Int?

//	let fleet_id : String?
//	let vehicle_set : [Int]?
//	let device_type : Int?

//	let vehicle_year : String?
//	let pooled_customers : Int?

//	let is_charging : Int?
//	let app_versioncode : Int?
//	let experience : Int?
//	let external_id : String?
//	let captive_driver_enabled : Int?
//	let is_tracker : Int?
//	let operator_id : Int?
//	let audit_status : String?
//	let phone_no : String?

	enum CodingKeys: String, CodingKey {

		case region_ids = "region_ids"
		case customers_rated = "customers_rated"
		case vehicle_brand = "vehicle_brand"
		case vehicle_type = "vehicle_type"
		case vehicle_no = "vehicle_no"
		case car_no = "car_no"
		case city_id = "city_id"
		case rating = "rating"
//		case battery_percentage = "battery_percentage"
//		case vehicle_name = "vehicle_name"
//		case user_name = "user_name"
//		case vehicle_make_id = "vehicle_make_id"
		case device_token = "device_token"
		case status = "status"
//		case fleet_id = "fleet_id"
//		case vehicle_set = "vehicle_set"
//		case device_type = "device_type"
		case longitude = "longitude"
		case driver_id = "driver_id"
//		case vehicle_year = "vehicle_year"
//		case pooled_customers = "pooled_customers"
		case driver_image = "driver_image"
		case distance = "distance"
//		case is_charging = "is_charging"
		case user_id = "user_id"
//		case app_versioncode = "app_versioncode"
//		case experience = "experience"
//		case external_id = "external_id"
//		case captive_driver_enabled = "captive_driver_enabled"
//		case is_tracker = "is_tracker"
//		case operator_id = "operator_id"
		case bearing = "bearing"
//		case audit_status = "audit_status"
		case latitude = "latitude"
//		case phone_no = "phone_no"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		region_ids = try values.decodeIfPresent([Int].self, forKey: .region_ids)
		customers_rated = try values.decodeIfPresent(Double.self, forKey: .customers_rated)
		vehicle_brand = try values.decodeIfPresent(String.self, forKey: .vehicle_brand)
		vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
		vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
		car_no = try values.decodeIfPresent(String.self, forKey: .car_no)
		city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
		rating = try values.decodeIfPresent(Double.self, forKey: .rating)
//		battery_percentage = try values.decodeIfPresent(Int.self, forKey: .battery_percentage)
//		vehicle_name = try values.decodeIfPresent(String.self, forKey: .vehicle_name)
//		user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
//		vehicle_make_id = try values.decodeIfPresent(Int.self, forKey: .vehicle_make_id)
		device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
//		fleet_id = try values.decodeIfPresent(String.self, forKey: .fleet_id)
//		vehicle_set = try values.decodeIfPresent([Int].self, forKey: .vehicle_set)
//		device_type = try values.decodeIfPresent(Int.self, forKey: .device_type)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
		driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
//		vehicle_year = try values.decodeIfPresent(String.self, forKey: .vehicle_year)
//		pooled_customers = try values.decodeIfPresent(Int.self, forKey: .pooled_customers)
		driver_image = try values.decodeIfPresent(String.self, forKey: .driver_image)
		distance = try values.decodeIfPresent(Double.self, forKey: .distance)
//		is_charging = try values.decodeIfPresent(Int.self, forKey: .is_charging)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
//		app_versioncode = try values.decodeIfPresent(Int.self, forKey: .app_versioncode)
//		experience = try values.decodeIfPresent(Int.self, forKey: .experience)
//		external_id = try values.decodeIfPresent(String.self, forKey: .external_id)
//		captive_driver_enabled = try values.decodeIfPresent(Int.self, forKey: .captive_driver_enabled)
//		is_tracker = try values.decodeIfPresent(Int.self, forKey: .is_tracker)
//		operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
		bearing = try values.decodeIfPresent(Double.self, forKey: .bearing)
//		audit_status = try values.decodeIfPresent(String.self, forKey: .audit_status)
		latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
//		phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
	}

}
