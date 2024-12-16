

import Foundation
struct AddAddressModal : Codable {
	let data : AddressData?
	let flag : Int?
	let message : String?

}
struct AddressData : Codable {
    let id : Int?
    let address : [Address]?
}
struct Address : Codable {
    let id : Int?
    let address : String?
    let google_place_id : String?
    let type : String?
    let latitude : Double?
    let longitude : Double?
   // let is_confirmed : Int?
    let instructions : String?
}
