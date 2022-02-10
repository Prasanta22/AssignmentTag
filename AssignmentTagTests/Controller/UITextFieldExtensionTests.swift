//
//  UITextFieldExtensionTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 10/02/22.
//

import XCTest
@testable import AssignmentTag

class UITextFieldExtensionTests: XCTestCase {

    var text: UITextField!
    
    override func setUp() {
        super.setUp()
        text = UITextField()
    }
    
    override func tearDownWithError() throws {
        text = nil
    }
    
    func testSetRightImage() {
        text.setRightImage(imageName: "DownArrow")
    }
    

}
