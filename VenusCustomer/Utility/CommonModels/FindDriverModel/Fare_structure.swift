
import Foundation
struct Fare_structure : Codable {
	let fare_per_min : Double?
	let fare_per_waiting_min : Double?
	let no_of_xmin : Double?
	let fare_per_xmin : Double?
	let fare_threshold_waiting_time : Double?
	let fare_per_km_after_threshold : Double?
	let vehicle_type : Int?
	let fare_per_km : Double?
	let ride_type : Int?
	let scheduled_ride_fare : Double?
	let fare_per_km_before_threshold : Double?
	let display_base_fare : String?
	let fare_threshold_time : Double?
	let operator_id : Int?
	let fare_per_baggage : Int?
	let end_time : String?
	let fare_fixed : Double?
	let fare_minimum : Double?
	let region_id : Int?
	let fare_per_km_threshold_distance : Double?
	let fare_threshold_distance : Double?
	let display_fare_text : String?
	let start_time : String?

	enum CodingKeys: String, CodingKey {

		case fare_per_min = "fare_per_min"
		case fare_per_waiting_min = "fare_per_waiting_min"
		case no_of_xmin = "no_of_xmin"
		case fare_per_xmin = "fare_per_xmin"
		case fare_threshold_waiting_time = "fare_threshold_waiting_time"
		case fare_per_km_after_threshold = "fare_per_km_after_threshold"
		case vehicle_type = "vehicle_type"
		case fare_per_km = "fare_per_km"
		case ride_type = "ride_type"
		case scheduled_ride_fare = "scheduled_ride_fare"
		case fare_per_km_before_threshold = "fare_per_km_before_threshold"
		case display_base_fare = "display_base_fare"
		case fare_threshold_time = "fare_threshold_time"
		case operator_id = "operator_id"
		case fare_per_baggage = "fare_per_baggage"
		case end_time = "end_time"
		case fare_fixed = "fare_fixed"
		case fare_minimum = "fare_minimum"
		case region_id = "region_id"
		case fare_per_km_threshold_distance = "fare_per_km_threshold_distance"
		case fare_threshold_distance = "fare_threshold_distance"
		case display_fare_text = "display_fare_text"
		case start_time = "start_time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fare_per_min = try values.decodeIfPresent(Double.self, forKey: .fare_per_min)
		fare_per_waiting_min = try values.decodeIfPresent(Double.self, forKey: .fare_per_waiting_min)
		no_of_xmin = try values.decodeIfPresent(Double.self, forKey: .no_of_xmin)
		fare_per_xmin = try values.decodeIfPresent(Double.self, forKey: .fare_per_xmin)
		fare_threshold_waiting_time = try values.decodeIfPresent(Double.self, forKey: .fare_threshold_waiting_time)
		fare_per_km_after_threshold = try values.decodeIfPresent(Double.self, forKey: .fare_per_km_after_threshold)
		vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
		fare_per_km = try values.decodeIfPresent(Double.self, forKey: .fare_per_km)
		ride_type = try values.decodeIfPresent(Int.self, forKey: .ride_type)
		scheduled_ride_fare = try values.decodeIfPresent(Double.self, forKey: .scheduled_ride_fare)
		fare_per_km_before_threshold = try values.decodeIfPresent(Double.self, forKey: .fare_per_km_before_threshold)
		display_base_fare = try values.decodeIfPresent(String.self, forKey: .display_base_fare)
		fare_threshold_time = try values.decodeIfPresent(Double.self, forKey: .fare_threshold_time)
		operator_id = try values.decodeIfPresent(Int.self, forKey: .operator_id)
		fare_per_baggage = try values.decodeIfPresent(Int.self, forKey: .fare_per_baggage)
		end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
		fare_fixed = try values.decodeIfPresent(Double.self, forKey: .fare_fixed)
		fare_minimum = try values.decodeIfPresent(Double.self, forKey: .fare_minimum)
		region_id = try values.decodeIfPresent(Int.self, forKey: .region_id)
		fare_per_km_threshold_distance = try values.decodeIfPresent(Double.self, forKey: .fare_per_km_threshold_distance)
		fare_threshold_distance = try values.decodeIfPresent(Double.self, forKey: .fare_threshold_distance)
		display_fare_text = try values.decodeIfPresent(String.self, forKey: .display_fare_text)
		start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
	}
}
