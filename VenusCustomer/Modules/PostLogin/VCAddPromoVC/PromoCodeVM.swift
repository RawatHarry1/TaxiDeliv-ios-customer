//
//  PromoCodeVM.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 20/06/24.
//

import Foundation

class promoCodeVM: NSObject {

    var objPromocodeModal: PromoCodeModal?

   
    override init() {
        super.init()
    }
}


extension promoCodeVM {

    func promoCodeAPi(lat:Double,long:Double,completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["latitude"] = lat
            att["longitude"] = long
            return att
        }
        WebServices.getpromocode(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? PromoCodeModal else { return }
                print(dataModel)
                self?.objPromocodeModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
