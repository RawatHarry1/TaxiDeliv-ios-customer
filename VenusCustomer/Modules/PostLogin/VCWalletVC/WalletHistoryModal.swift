

import Foundation
struct WalletHistoryModal : Codable {
	let flag : Int?
	let message : String?
	let data : HistoryData?

	enum CodingKeys: String, CodingKey {

		case flag = "flag"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		flag = try values.decodeIfPresent(Int.self, forKey: .flag)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(HistoryData.self, forKey: .data)
	}

}
struct HistoryData : Codable {
    let banner : String?
    let balance : Int?
    let num_txns : Int?
    let page_size : Int?
    let transactions : [Transactions]?
    let user_name : String?
    let currency : String?

    enum CodingKeys: String, CodingKey {

        case banner = "banner"
        case balance = "balance"
        case num_txns = "num_txns"
        case page_size = "page_size"
        case transactions = "transactions"
        case user_name = "user_name"
        case currency = "currency"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banner = try values.decodeIfPresent(String.self, forKey: .banner)
        balance = try values.decodeIfPresent(Int.self, forKey: .balance)
        num_txns = try values.decodeIfPresent(Int.self, forKey: .num_txns)
        page_size = try values.decodeIfPresent(Int.self, forKey: .page_size)
        transactions = try values.decodeIfPresent([Transactions].self, forKey: .transactions)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
    }

}
struct Transactions : Codable {
    let txn_id : Int?
    let txn_type : String?
    let amount : Int?
    let txn_date : String?
    let txn_time : String?
    let logged_on : String?
    let wallet_txn : Int?
    let paytm : Int?
    let mobikwik : Int?
    let freecharge : Int?
    let reference_id : Int?
    let event : Int?

    enum CodingKeys: String, CodingKey {

        case txn_id = "txn_id"
        case txn_type = "txn_type"
        case amount = "amount"
        case txn_date = "txn_date"
        case txn_time = "txn_time"
        case logged_on = "logged_on"
        case wallet_txn = "wallet_txn"
        case paytm = "paytm"
        case mobikwik = "mobikwik"
        case freecharge = "freecharge"
        case reference_id = "reference_id"
        case event = "event"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        txn_id = try values.decodeIfPresent(Int.self, forKey: .txn_id)
        txn_type = try values.decodeIfPresent(String.self, forKey: .txn_type)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        txn_date = try values.decodeIfPresent(String.self, forKey: .txn_date)
        txn_time = try values.decodeIfPresent(String.self, forKey: .txn_time)
        logged_on = try values.decodeIfPresent(String.self, forKey: .logged_on)
        wallet_txn = try values.decodeIfPresent(Int.self, forKey: .wallet_txn)
        paytm = try values.decodeIfPresent(Int.self, forKey: .paytm)
        mobikwik = try values.decodeIfPresent(Int.self, forKey: .mobikwik)
        freecharge = try values.decodeIfPresent(Int.self, forKey: .freecharge)
        reference_id = try values.decodeIfPresent(Int.self, forKey: .reference_id)
        event = try values.decodeIfPresent(Int.self, forKey: .event)
    }
}
