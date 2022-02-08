//
//  Constants.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 06/02/22.
//

import Foundation

struct Constants {
    
    static let username = "Username"
    static let password = "Password"
    static let confirmPassword = "Confirm Password"
    static let userKey = "username"
    static let tokenKey = "HomeAssignmentIOSKey"
    static let passwordKey = "HomeAssignmentPassKey"
    
    
    static let textInputView = "CustomTextField"
    
    static let usernameEmptyMessage = "Username is required"
    static let passwordEmptyMessage = "Password is required"
    static let payeeEmptyMessage = "Payee is required"
    static let amountEmptyMessage = "Amount is required"
    static let usernameErrorMessage = "Username is invalid"
    static let passwordErrorMessage = "Password length must be in range 6-10 characters."
    static let confirmPasswordEmptyMessage = "Please Enter Confirm Password"
    static let passwordMismatchErrorMessage = "Not matching password and confirm password"
    static let errorMessage = "both error"
    
    static let payeeText = "Payee"
    static let amountText = "Amount"
    static let downButtonImage = "DownArrow"
    
    static let done = "Done"
    static let cancel = "Cancel"
    static let ok = "Ok"
    
    static let receipient = "receipientAccountNo"
    static let description = "description"
}

struct StatusReponse {
    static let success = "success"
    static let failure = "failed"
}
