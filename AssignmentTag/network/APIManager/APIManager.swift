//
//  APIManager.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

public enum ErrorType: Error {
    case noInternet
    case authRequired
    case badRequest
    case outdatedRequest
    case requestFailed
    case invalidResponse
    case noData

    static func errorViewModel(_ errorType: ErrorType) -> ErrorViewModel {
        let genereicErrorViewModel = ErrorViewModel(title: Strings.Error.genericErrorTitle, message: Strings.Error.genericErrorMessage, buttonTitles: [Strings.Error.okButtonTitle])
        switch errorType {
        case .noInternet: return ErrorViewModel(title: Strings.Error.genericErrorTitle, message: Strings.Error.noNetworkMessage, buttonTitles: [Strings.Error.okButtonTitle])
        case .authRequired: return genereicErrorViewModel
        case .badRequest: return genereicErrorViewModel
        case .outdatedRequest: return genereicErrorViewModel
        case .requestFailed: return genereicErrorViewModel
        case .invalidResponse: return genereicErrorViewModel
        case .noData: return ErrorViewModel(title: Strings.Error.genericErrorTitle, message: Strings.Error.noDataMessage, buttonTitles: [Strings.Error.okButtonTitle])
        }
    }
}

enum Result {
    case success(APIResponse)
    case failure(ErrorType)
}

struct APIManager {
    let manager = Manager<UserApi>()
    func login(_ username: String,_ password: String, completion: @escaping DataTaskResponse) {
        let endPoint = UserApi.login(username: username,
                                     password: password)
        manager.request(endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func signUp(_ username: String,_ password: String, completion: @escaping DataTaskResponse) {
        let endPoint = UserApi.signup(username: username,
                                      password: password)
        manager.request(endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func transfer(completion: @escaping DataTaskResponse) {
        let endPoint = UserApi.payees
        manager.request(endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
