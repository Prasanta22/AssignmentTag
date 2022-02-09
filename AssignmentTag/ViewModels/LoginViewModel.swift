//
//  LoginViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 06/02/22.
//

import Foundation
import UIKit

struct LoginViewModel {
    let passwordLengthRange = (6, 20) // (minimum length, maximum length)
    func validateInput(_ username: String?, password: String?, completion: (Bool, String?) -> Void) {
        if let username = username {
            if username.isEmpty {
                completion(false, Constants.usernameEmptyMessage)
            }
        } else {
            completion(false, Constants.usernameEmptyMessage)
        }
        if let password = password {
            if password.isEmpty {
                completion(false, Constants.passwordEmptyMessage)
                return
            } else if !validateTextLength(password, range: passwordLengthRange) {
                completion(false, Constants.passwordErrorMessage)
                return
            }
        } else {
            completion(false, Constants.passwordEmptyMessage)
        }
        // Validated successfully.
        completion(true, nil)
    }
    
    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }
    
    func login(_ requestModel: LoginRequestModel, completion: @escaping (LoginResponseModel?, String?) -> Void) {
        APIManager().login(requestModel.username, requestModel.password) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let loginData = try JSONDecoder().decode(LoginResponseModel.self,
                                                             from: data)
                    if loginData.status == "success" {
                        completion(loginData, nil)
                    } else {
                        completion(nil, loginData.error)
                    }
                } catch _ {
                    completion(nil, error?.localizedDescription)
                }
            } else {
                guard let err = error else { return }
                completion(nil, err.localizedDescription)
            }
            
        }

    }
}

struct LoginRequestModel {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

}

struct LoginResponseModel: Decodable {
    var status: String?
    var token: String?
    var username: String?
    var accountNo: String?
    var error: String?
}
