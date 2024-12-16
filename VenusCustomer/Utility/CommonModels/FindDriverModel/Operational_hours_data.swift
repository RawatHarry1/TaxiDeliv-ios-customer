

import Foundation
struct Operational_hours_data : Codable {
	let day_id : String?
	let is_operation_available : Int?
	let start_operation_time : String?
	let end_operation_time : String?

	enum CodingKeys: String, CodingKey {

		case day_id = "day_id"
		case is_operation_available = "is_operation_available"
		case start_operation_time = "start_operation_time"
		case end_operation_time = "end_operation_time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		day_id = try values.decodeIfPresent(String.self, forKey: .day_id)
		is_operation_available = try values.decodeIfPresent(Int.self, forKey: .is_operation_available)
		start_operation_time = try values.decodeIfPresent(String.self, forKey: .start_operation_time)
		end_operation_time = try values.decodeIfPresent(String.self, forKey: .end_operation_time)
	}

}
