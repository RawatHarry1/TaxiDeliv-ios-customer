

import Foundation
struct GetScheduleModal : Codable {
	let flag : Int?
	let data : [ScheduledData]?

}
struct ScheduledData : Codable {
    let pickup_id : Int?
    let latitude : Double?
    let longitude : Double?
    let op_drop_latitude : Double?
    let op_drop_longitude : Double?
    let preferred_payment_mode : Int?
    let pickup_location_address : String?
    let drop_location_address : String?
    let pickup_time : String?
    let status : Int?
    let modifiable : Int?
    let vehicle_name : String?
    let ride_type : Int?
}
