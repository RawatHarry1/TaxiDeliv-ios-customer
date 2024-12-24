//
//  VCSplashVC.swift
//  VenusCustomer
//
//  Created by Amit on 05/06/23.
//

import UIKit

class VCSplashVC: VCBaseVC {
    //  To create ViewModel
    static func create() -> VCSplashVC {
        let obj = VCSplashVC.instantiate(fromAppStoryboard: .main)
        return obj
    }
}

// MARK: - Lifecycle fuction
extension VCSplashVC {
    override func initialSetup() {
        addObservers()
        apiClientConfigure()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccessTokenAPI(notification:)), name: .updateAccessTokenAPI, object: nil)
    }
    
    @objc func updateAccessTokenAPI( notification: Notification) {
        self.loginWithAccessToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserModel.currentUser.login?.is_customer_profile_complete == 1 {
            loginWithAccessToken()
           
        } else {
            let showIntroScreens = VCUserDefaults.value(forKey: .showIntroScreens)
            if showIntroScreens == true{
                VCRouter.loadPreloginScreen()
            }else{
                self.navigationController?.pushViewController(SIIntroScreensVC.create(), animated: true)
            }
            
            
           // VCUserDefaults.save(value: deviceToken, forKey:.deviceToken)
           
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.navigationController?.pushViewController(SIIntroScreensVC.create(), animated: true)
//        }
    }
}

// MARK: - APIs
extension VCSplashVC {
    // TODO: - Configure client
    private func apiClientConfigure() {
        var paramToModifyVehicleDetails: JSONDictionary {
            let param = [
                "packageName": "com.venus.customer"//"com.venus.customer",
            ] as [String: Any]
            return param
        }

        WebServices.getClientConfig(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                print("success")
//                if whiteLabelProperties.packageName == bundleIdentifiers.venus.rawValue {
//                    self?.navigationController?.pushViewController(VDIntroVC.create(), animated: true)
//                } else {
                  //
//                }
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    
    // TODO: - Login with access token
    private func loginWithAccessToken() {
        if let _ = LocationTracker.shared.lastLocation {
        } else {
            failedToFetchLocation = true
            SKToast.show(withMessage: "Not able to fetch your location")
            return
        }
        var paramToModifyVehicleDetails: JSONDictionary {
            if let location = LocationTracker.shared.lastLocation {
                let param = [
                    "latitude": location.coordinate.latitude ,
                    "longitude": location.coordinate.longitude
                ] as [String: Any]
                return param
            } else {
                return [String:Any]()
            }
        }

        WebServices.loginWithAccessToken(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success( _):
                let obj = UserModel.currentUser.login?.popup
                if obj?.download_link == nil || obj?.force_to_version == nil || obj?.is_force == nil || obj?.popup_text == nil{
                    VCRouter.goToSaveUserVC()
                }else{
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VersionUpdateVC") as! VersionUpdateVC
                    self?.present(vc, animated: true)
                }
                
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
