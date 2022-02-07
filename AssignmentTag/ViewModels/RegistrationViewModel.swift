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
    let passwordLengthRange = (6, 14) // (minimum length, maximum length)
    
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
            } else if !validateTextLength(confirmPassword, range: passwordLengthRange) {
                completion(false, Constants.passwordErrorMessage)
            } else if signupModel.password != confirmPassword {
                completion(false, Constants.passwordMismatchErrorMessage)
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
    
    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }
    
}
