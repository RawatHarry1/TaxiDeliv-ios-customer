//
//  WalletHistoryViewModal.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 19/06/24.
//

import Foundation
class WalletHistoryViewModal: NSObject {

    var objWalletModal: WalletHistoryModal?

   
    override init() {
        super.init()
    }
}


extension WalletHistoryViewModal {

    func walletHistoryApi(completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["start_from"] = "0"
            return att
        }
        WebServices.transactionHistory(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? WalletHistoryModal else { return }
                print(dataModel)
                self?.objWalletModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    func addAmountApi(cardID: String,amount:String,currency:String,completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["stripe_3d_enabled"] = "1"
            att["card_id"] = cardID
            att["amount"] = amount
            att["currency"] = currency
            return att
        }
        WebServices.addMoney(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
//                guard let dataModel = data as? WalletHistoryModal else { return }
//                print(dataModel)
//                self?.objWalletModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
