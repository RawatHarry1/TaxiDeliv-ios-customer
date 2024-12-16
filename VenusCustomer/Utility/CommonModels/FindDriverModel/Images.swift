
import Foundation
struct Images : Codable {
	let marker_icon : String?
	let ride_now_highlighted_3x : String?
	let ride_now_normal_2x : String?
	let tab_highlighted_2x : String?
	let tab_normal_2x : String?
	let ride_now_normal_3x : String?
	let tab_highlighted_3x : String?
	let tab_normal_3x : String?
	let ride_now_highlighted_2x : String?
	let history_icon : String?
	let driver_icon_2x : String?
	let invoice_icon : String?
	let driver_icon_3x : String?

	enum CodingKeys: String, CodingKey {

		case marker_icon = "marker_icon"
		case ride_now_highlighted_3x = "ride_now_highlighted_3x"
		case ride_now_normal_2x = "ride_now_normal_2x"
		case tab_highlighted_2x = "tab_highlighted_2x"
		case tab_normal_2x = "tab_normal_2x"
		case ride_now_normal_3x = "ride_now_normal_3x"
		case tab_highlighted_3x = "tab_highlighted_3x"
		case tab_normal_3x = "tab_normal_3x"
		case ride_now_highlighted_2x = "ride_now_highlighted_2x"
		case history_icon = "history_icon"
		case driver_icon_2x = "driver_icon_2x"
		case invoice_icon = "invoice_icon"
		case driver_icon_3x = "driver_icon_3x"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		marker_icon = try values.decodeIfPresent(String.self, forKey: .marker_icon)
		ride_now_highlighted_3x = try values.decodeIfPresent(String.self, forKey: .ride_now_highlighted_3x)
		ride_now_normal_2x = try values.decodeIfPresent(String.self, forKey: .ride_now_normal_2x)
		tab_highlighted_2x = try values.decodeIfPresent(String.self, forKey: .tab_highlighted_2x)
		tab_normal_2x = try values.decodeIfPresent(String.self, forKey: .tab_normal_2x)
		ride_now_normal_3x = try values.decodeIfPresent(String.self, forKey: .ride_now_normal_3x)
		tab_highlighted_3x = try values.decodeIfPresent(String.self, forKey: .tab_highlighted_3x)
		tab_normal_3x = try values.decodeIfPresent(String.self, forKey: .tab_normal_3x)
		ride_now_highlighted_2x = try values.decodeIfPresent(String.self, forKey: .ride_now_highlighted_2x)
		history_icon = try values.decodeIfPresent(String.self, forKey: .history_icon)
		driver_icon_2x = try values.decodeIfPresent(String.self, forKey: .driver_icon_2x)
		invoice_icon = try values.decodeIfPresent(String.self, forKey: .invoice_icon)
		driver_icon_3x = try values.decodeIfPresent(String.self, forKey: .driver_icon_3x)
	}

}
