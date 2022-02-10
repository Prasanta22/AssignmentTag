//
//  LoginViewControllerTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 09/02/22.
//

import XCTest
@testable import AssignmentTag

class LoginViewControllerTests: XCTestCase {
    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        loginViewController = LoginViewController()
        loginViewController.viewDidLoad()
        loginViewController.viewWillAppear(true)
        loginViewController.userNameTextfield?.textField.text = "love66"
        loginViewController.passwordTextField?.textField.text = "12345678"
    }
    override func tearDownWithError() throws {
        loginViewController = nil
    }
    
    func testSetupUI() {
        loginViewController.setupUI()
    }
    
    func testClearErrorMessage() {
        loginViewController.clearErrorMessage()
    }
    
    func testNavigateToDashBoard() {
        loginViewController.navigateToDashBoard()
    }
    
    func testLoginButtonAction() {
        loginViewController.loginButtonAction(UIButton())
    }
    
    func testRegisterButtonAction() {
        loginViewController.registerButtonAction(UIButton())
    }
    
    func testTextFieldShouldReturn() {
        let sampleTextField = UITextField()
        let flag = loginViewController.textFieldShouldReturn(sampleTextField)
        XCTAssertTrue(flag)
    }
}
