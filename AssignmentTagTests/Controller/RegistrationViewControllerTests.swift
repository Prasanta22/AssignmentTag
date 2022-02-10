//
//  RegistrationViewControllerTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 09/02/22.
//

import XCTest
@testable import AssignmentTag

class RegistrationViewControllerTests: XCTestCase {
    var regViewController: RegistrationViewController!
    
    override func setUp() {
        super.setUp()
        regViewController = RegistrationViewController()
        regViewController.viewDidLoad()
        regViewController.viewWillAppear(true)
        regViewController.userNameTextfield?.textField.text = "love66"
        regViewController.passwordTextField?.textField.text = "12345678"
        regViewController.confirmPasswordTextfield?.textField.text = "12345678"
    }
    override func tearDownWithError() throws {
        regViewController = nil
    }
    
    func testSetupUI() {
        regViewController.setupUI()
    }
    
    func testClearErrorMessage() {
        regViewController.clearErrorMessage()
    }
    
    func testBackButtonAction() {
        regViewController.backButtonAction(UIButton())
    }
    
    func testRegisterButtonAction() {
        regViewController.registrationButtonAction(UIButton())
    }
    
    func testTextFieldShouldReturn() {
        let sampleTextField = UITextField()
        let flag = regViewController.textFieldShouldReturn(sampleTextField)
        XCTAssertTrue(flag)
    }
}
