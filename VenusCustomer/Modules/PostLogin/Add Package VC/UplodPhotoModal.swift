

import Foundation
struct UplodPhotoModal : Codable {
	let message : String?
	let flag : Int?
	let data : UplodPhotoData?

}
struct UplodPhotoData : Codable {
    let file_path : String?
}
