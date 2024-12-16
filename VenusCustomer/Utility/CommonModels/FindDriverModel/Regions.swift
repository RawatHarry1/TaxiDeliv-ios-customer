
import Foundation
struct Regions : Codable {
	let disclaimer_text : String?
	let offer_texts : Offer_texts?
	let region_name : String?
	let stations : [String]?
	let instructions : [String]?
	let vehicle_services : [String]?
	let vehicle_properties : String?
    let vehicle_desc : String?
	let reverse_bidding_enabled : Int?
	let multiple_destinations_enabled : Int?
	let destination_mandatory : Int?
	let ride_type : Int?
	let icon_set : String?
	let images : Images?
	let region_id : Int?
	let operator_id : Int?
	let distance : Double?
	let max_people : Int?
	let fare_mandatory : Int?
	let restricted_payment_modes : [Int]?
	let packages : [String]?
	let vehicle_type : Int?
	let customer_fare_factor : Int?
	let eta : Double?
	let driver_fare_factor : Int?
	let priority_tip_category : Int?
	let applicable_gender : Int?
	let customer_notes_enabled : Int?
	let show_fare_estimate : Int?
	let restricted_corporates : [String]?
    let region_fare : Region_fare?
    
//	let deepindex : Int?

	enum CodingKeys: String, CodingKey {

		case disclaimer_text = "disclaimer_text"
		case offer_texts = "offer_texts"
		case region_name = "region_name"
		case stations = "stations"
		case instructions = "instructions"
		case vehicle_services = "vehicle_services"
		case vehicle_properties = "vehicle_properties"
		case reverse_bidding_enabled = "reverse_bidding_enabled"
		case multiple_destinations_enabled = "multiple_destinations_enabled"
		case destination_mandatory = "destination_mandatory"
		case ride_type = "ride_type"
		case icon_set = "icon_set"
		case images = "images"
		case region_id = "region_id"
		case operator_id = "operator_id"
		case distance = "distance"
		case max_people = "max_people"
		case fare_mandatory = "fare_mandatory"
		case restricted_payment_modes = "restricted_payment_modes"
		case packages = "packages"
		case vehicle_type = "vehicle_type"
		case customer_fare_factor = "customer_fare_factor"
		case eta = "eta"
		case driver_fare_factor = "driver_fare_factor"
		case priority_tip_category = "priority_tip_category"
		case applicable_gender = "applicable_gender"
		case customer_notes_enabled = "customer_notes_enabled"
		case show_fare_estimate = "show_fare_estimate"
		case restricted_corporates = "restricted_corporates"
        case region_fare = "region_fare"
		case vehicle_desc = "vehicle_desc"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		disclaimer_text = try values.decodeIfPresent(String.self, forKey: .disclaimer_text)
		offer_texts = try values.decodeIfPresent(Offer_texts.self, forKey: .offer_texts)
		region_name = try values.decodeIfPresent(String.self, forKey: .region_name)
		stations = try values.decodeIfPresent([String].self, forKey: .stations)
		instructions = try values.decodeIfPresent([String].self, forKey: .instructions)
		vehicle_services = try values.decodeIfPresent([String].self, forKey: .vehicle_services)
		vehicle_properties = try values.decodeIfPresent(String.self, forKey: .vehicle_properties)
		reverse_bidding_enabled = try values.decodeIfPresent(Int.self, forKey: .reverse_bidding_enabled)
		multiple_destinations_enabled = try values.decodeIfPresent(Int.self, forKey: .multiple_destinations_enabled)
		destination_mandatory = try values.decodeIfPresent(Int.self, forKey: .destination_mandatory)
		ride_type = try values.decodeIfPresent(Int.self, forKey: .ride_type)
		icon_set = try values.decodeIfPresent(String.self, forKey: .icon_set)
		images = try values.decodeIfPresent(Images.self, forKey: .images)
		region_id = try values.decodeIfPresent(Int.self, forKey: .region_id)
		operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
		distance = try values.decodeIfPresent(Double.self, forKey: .distance)
		max_people = try values.decodeIfPresent(Int.self, forKey: .max_people)
		fare_mandatory = try values.decodeIfPresent(Int.self, forKey: .fare_mandatory)
		restricted_payment_modes = try values.decodeIfPresent([Int].self, forKey: .restricted_payment_modes)
		packages = try values.decodeIfPresent([String].self, forKey: .packages)
		vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
		customer_fare_factor = try values.decodeIfPresent(Int.self, forKey: .customer_fare_factor)
		eta = try values.decodeIfPresent(Double.self, forKey: .eta)
		driver_fare_factor = try values.decodeIfPresent(Int.self, forKey: .driver_fare_factor)
		priority_tip_category = try values.decodeIfPresent(Int.self, forKey: .priority_tip_category)
		applicable_gender = try values.decodeIfPresent(Int.self, forKey: .applicable_gender)
		customer_notes_enabled = try values.decodeIfPresent(Int.self, forKey: .customer_notes_enabled)
		show_fare_estimate = try values.decodeIfPresent(Int.self, forKey: .show_fare_estimate)
		restricted_corporates = try values.decodeIfPresent([String].self, forKey: .restricted_corporates)
        region_fare = try values.decodeIfPresent(Region_fare.self, forKey: .region_fare)
        vehicle_desc = try values.decodeIfPresent(String.self, forKey: .vehicle_desc)
    
	}

}
struct Region_fare : Codable {
    let fare : Double?
    let min_fare : Double?
    let max_fare : Double?
    let original_fare : Double?
    let min_original_fare : Double?
    let max_original_fare : Double?
    let ride_distance : Double?
    let min_ride_time : Double?
    let max_ride_time : Double?
    let convenience_charge : Double?
    let flat_charges : String?
    let currency : String?
    let currency_symbol : String?
    let fare_float : Double?
    let toll_charge : Int?
    let striked_fare_text : String?
    let fare_text : String?
    let distance_unit : String?
    let customer_fare_factor : Double?
    let driver_fare_factor : Double?
    let discount : Double?
    let nts_enabled : Double?
    let hold_amount : Double?
    let tax_percentage : Double?
    let tax_value : Double?
    let pool_fare_id : Double?

    enum CodingKeys: String, CodingKey {

        case fare = "fare"
        case min_fare = "min_fare"
        case max_fare = "max_fare"
        case original_fare = "original_fare"
        case min_original_fare = "min_original_fare"
        case max_original_fare = "max_original_fare"
        case ride_distance = "ride_distance"
        case min_ride_time = "min_ride_time"
        case max_ride_time = "max_ride_time"
        case convenience_charge = "convenience_charge"
        case flat_charges = "flat_charges"
        case currency = "currency"
        case currency_symbol = "currency_symbol"
        case fare_float = "fare_float"
        case toll_charge = "toll_charge"
        case striked_fare_text = "striked_fare_text"
        case fare_text = "fare_text"
        case distance_unit = "distance_unit"
        case customer_fare_factor = "customer_fare_factor"
        case driver_fare_factor = "driver_fare_factor"
        case discount = "discount"
        case nts_enabled = "nts_enabled"
        case hold_amount = "hold_amount"
        case tax_percentage = "tax_percentage"
        case tax_value = "tax_value"
        case pool_fare_id = "pool_fare_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fare = try values.decodeIfPresent(Double.self, forKey: .fare)
        min_fare = try values.decodeIfPresent(Double.self, forKey: .min_fare)
        max_fare = try values.decodeIfPresent(Double.self, forKey: .max_fare)
        original_fare = try values.decodeIfPresent(Double.self, forKey: .original_fare)
        min_original_fare = try values.decodeIfPresent(Double.self, forKey: .min_original_fare)
        max_original_fare = try values.decodeIfPresent(Double.self, forKey: .max_original_fare)
        ride_distance = try values.decodeIfPresent(Double.self, forKey: .ride_distance)
        min_ride_time = try values.decodeIfPresent(Double.self, forKey: .min_ride_time)
        max_ride_time = try values.decodeIfPresent(Double.self, forKey: .max_ride_time)
        convenience_charge = try values.decodeIfPresent(Double.self, forKey: .convenience_charge)
        flat_charges = try values.decodeIfPresent(String.self, forKey: .flat_charges)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        fare_float = try values.decodeIfPresent(Double.self, forKey: .fare_float)
        toll_charge = try values.decodeIfPresent(Int.self, forKey: .toll_charge)
        striked_fare_text = try values.decodeIfPresent(String.self, forKey: .striked_fare_text)
        fare_text = try values.decodeIfPresent(String.self, forKey: .fare_text)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        customer_fare_factor = try values.decodeIfPresent(Double.self, forKey: .customer_fare_factor)
        driver_fare_factor = try values.decodeIfPresent(Double.self, forKey: .driver_fare_factor)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        nts_enabled = try values.decodeIfPresent(Double.self, forKey: .nts_enabled)
        hold_amount = try values.decodeIfPresent(Double.self, forKey: .hold_amount)
        tax_percentage = try values.decodeIfPresent(Double.self, forKey: .tax_percentage)
        tax_value = try values.decodeIfPresent(Double.self, forKey: .tax_value)
        pool_fare_id = try values.decodeIfPresent(Double.self, forKey: .pool_fare_id)
    }

}
