//
//  TransferViewControllerTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 09/02/22.
//

import XCTest
@testable import AssignmentTag

class TransferViewControllerTests: XCTestCase {
    var transViewController: TransferViewController!
    
    override func setUp() {
        super.setUp()
        transViewController = TransferViewController()
        transViewController.viewDidLoad()
        transViewController.viewWillAppear(true)
        transViewController.payeeTextField?.textField.text = "Andy"
        transViewController.amountTextField?.textField.text = "22"
        transViewController.descriptionTextView?.text = "hello"
        transViewController.accountNo = "876"
    }
    override func tearDownWithError() throws {
        transViewController = nil
    }
    
    func testSetupUI() {
        transViewController.setupUI()
    }
    
    func testClearErrorMessage() {
        transViewController.clearErrorMessage()
    }
    
    func testBackButtonAction() {
        transViewController.backButtonAction(UIButton())
    }
    
    func testTransferButtonAction() {
        transViewController.transferButtonAction(UIButton())
    }
    
    func testTextFieldShouldReturn() {
        let sampleTextField = UITextField()
        let flag = transViewController.textFieldShouldReturn(sampleTextField)
        XCTAssertTrue(flag)
    }
    
    func testDoneTapped() {
        transViewController.doneTapped()
        transViewController.cancelTapped()
    }
}
