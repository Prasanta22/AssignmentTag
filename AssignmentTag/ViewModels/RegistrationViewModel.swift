//
//  RegistrationViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

typealias ValidationCompletion = (Bool, String?) -> Void
struct SignUpModel {
    var username: String?
    var password: String?
    var confirmPassword: String?
}
struct RegistrationViewModel {
    let passwordLengthRange = (6, 20) // (minimum length, maximum length)
    
    func validateInput(_ signupModel: SignUpModel, completion: ValidationCompletion) {
        
        guard self.validateUsername(signupModel, completion: completion) else { return }
        guard self.validatePasswordAndConfirmPassword(signupModel, completion: completion) else { return }
        
        // Validated successfully.
        completion(true, nil)
    }
    
    private func validatePasswordAndConfirmPassword(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool {
        if let password = signupModel.password {
            if password.isEmpty {
                completion(false, Constants.passwordEmptyMessage)
            } else if !validateTextLength(password, range: passwordLengthRange) {
                completion(false, Constants.passwordErrorMessage)
            }
        } else {
            completion(false, Constants.passwordEmptyMessage)
        }
        
        
        if let confirmPassword = signupModel.confirmPassword {
            if confirmPassword.isEmpty {
                completion(false, Constants.confirmPasswordEmptyMessage)
                return false
            } else if !validateTextLength(confirmPassword, range: passwordLengthRange) {
                completion(false, Constants.passwordErrorMessage)
                return false
            } else if signupModel.password != confirmPassword {
                completion(false, Constants.passwordMismatchErrorMessage)
                return false
            }
        } else {
            completion(false, Constants.confirmPasswordEmptyMessage)
        }
        return true
    }
    
    private func validateUsername(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool {
        if let username = signupModel.username {
            if username.isEmpty {
                completion(false, Constants.usernameEmptyMessage)
            }
        } else {
            completion(false, Constants.usernameEmptyMessage)
        }
        return true
    }
    
    /// Validate Password Length
    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }
    
    func signup(_ requestModel: SignUpRequestModel, completion: @escaping (SignUpResponseModel?) -> Void) {
        APIManager().signUp(requestModel.username, requestModel.password) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let signUpData = try JSONDecoder().decode(SignUpResponseModel.self,
                                                              from: data)
                    if signUpData.status == StatusReponse.success {
                        completion(signUpData)
                    } else {
                        completion(signUpData)
                    }
                } catch _ {
                    completion(nil)
                }
            }
            
        }
        
    }
}

struct SignUpRequestModel {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

}

struct SignUpResponseModel: Decodable {
    var status: String?
    var token: String?
    var error: String?
}
