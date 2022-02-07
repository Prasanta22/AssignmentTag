//
//  LoginViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 06/02/22.
//

import Foundation
import UIKit

struct LoginViewModel {
    let passwordLengthRange = (6, 14) // (minimum length, maximum length)
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
            } else if !validateTextLength(password, range: passwordLengthRange) {
                completion(false, Constants.passwordErrorMessage)
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
    
    func login(_ requestModel: LoginRequestModel, completion: @escaping (LoginResponseModel) -> Void) {
        let params = requestModel.getParams()
        print("Input:\(params)")
        var responseModel = LoginResponseModel()
        responseModel.success = true
        responseModel.successMessage = "User logged in successfully"
        completion(responseModel)
        
        //        APIManager().login(params) { (results) in
        //            print(results)
        //        }
        
    }
}

struct LoginRequestModel {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func getParams() -> [String: Any] {
        return ["username": username, "password": password]
    }
}

struct LoginResponseModel {
    var success = false
    var errorMessage: String?
    var successMessage: String?
    var data: Any?
}
