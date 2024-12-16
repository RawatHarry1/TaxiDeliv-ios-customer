
import Foundation
struct Request_levels : Codable {
	let enabled : Int?
	let level : Int?
	let tip_enabled : Int?

	enum CodingKeys: String, CodingKey {

		case enabled = "enabled"
		case level = "level"
		case tip_enabled = "tip_enabled"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		enabled = try values.decodeIfPresent(Int.self, forKey: .enabled)
		level = try values.decodeIfPresent(Int.self, forKey: .level)
		tip_enabled = try values.decodeIfPresent(Int.self, forKey: .tip_enabled)
	}

}
