//
//  Webservices+Login.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation
var messgaeReferal = ""
var isReferee = false

extension WebServices {
    // MARK: - To Get OTP For Login
    static func generateOtpWithLogin(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .generateLoginOtp, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(ClientModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Verify OTP
    static func verifyLoginOTP(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .login, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                UserModel.currentUser = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Verify OTP
    static func addAddress(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addAddress, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(AddAddressModal.self, from: data)
               // AddAddressModal = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    // MARK: - To Verify OTP
    static func getAddress(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .getAddress, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try? json["data"].rawData()
                let model = try! JSONDecoder().decode(GetAddData.self, from: data!)

                response(.success(model))
                
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Login Via Access tokem
    static func loginWithAccessToken(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .loginViaAccessToken, loader: true) { (result) in
            switch result {
            case .success(let json):
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                UserModel.currentUser = model
               
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Create profile
    static func createProfileWithImage(parameters: [String: Any], image: [String : UIImage], response: @escaping ((Result<(Any?), Error>) -> Void)) {

        commonPUTAPIWithImage(endPoint: .accountDetail, parameters: parameters, image: image) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(ProfileModel.self, from: data)
                ProfileModel.currentUserProfile = model
                isReferee = model.is_referee ?? false
                messgaeReferal = model.message ?? ""
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

//    // MARK: - Add BANK Account API
//    static func addAccountApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
//        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addAccount, loader: true) { (result) in
//            switch result {
//            case .success(let json):
//                printDebug(json)
////                let data = try! json[APIKeys.data.rawValue].rawData()
////                let model = try! JSONDecoder().decode(UserModel.self, from: data)
//                response(.success(json))
//            case .failure(let error):
//                response(.failure(error))
//            }
//        }
//    }
//
    // MARK: - To Logout
    static func logoutDriver(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonDeleteRawJsonAPI(parameters: parameters, endPoint: .logout_driver) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                UserModel.currentUser = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    // MARK: - To Get User Profile detail
    static func getAccountDetails(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .accountDetail, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(UserProfileModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}

