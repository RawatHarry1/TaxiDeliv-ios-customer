//
//  VCAccountViewModel.swift
//  VenusCustomer
//
//  Created by AB on 24/10/23.
//

import Foundation

class VCAccountViewModel: NSObject {
    
    var objPromoModal: PromoModal?
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((UserProfileModel) -> ()) = { _ in }
    var informationUrlsCallback : ((InformationURLModel) -> ()) = { _ in }
    var pageType = 0
    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var accountDetails : UserProfileModel! {
        didSet {
            self.successCallBack(accountDetails)
        }
    }
    
    private(set) var informationUrls : InformationURLModel! {
        didSet {
            self.informationUrlsCallback(informationUrls)
        }
    }

    override init() {
        super.init()
    }
}

// MARK: - API's
extension VCAccountViewModel {

    func getAccountDetail() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.getAccountDetails(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                if let obj = data as? UserProfileModel {
                    self?.accountDetails = obj
                }
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func fetchUrlInformation(type: Int) {
        var paramToModifyVehicleDetails: JSONDictionary {
            var attributes = [String: Any]()
            attributes["cityId"] = UserModel.currentUser.login?.city ?? 0
            attributes["operatorId"] = ClientModel.currentClientData.operator_id ?? 0
            attributes["pageType"] = type
            return attributes
        }

        WebServices.getInformationUrls(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.pageType = type
                guard let urls = data as? InformationURLModel else { return }
                self?.informationUrls = urls
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    func deleteAccount(parms : [String:Any],completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            let att = parms
            return att
        }
        WebServices.deleteAccount(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? PromoModal else { return }
                print(dataModel)
                self!.objPromoModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
