
import Foundation
struct Offer_texts : Codable {
	let text1 : String?
	let text2 : String?

	enum CodingKeys: String, CodingKey {

		case text1 = "text1"
		case text2 = "text2"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text1 = try values.decodeIfPresent(String.self, forKey: .text1)
		text2 = try values.decodeIfPresent(String.self, forKey: .text2)
	}

}
