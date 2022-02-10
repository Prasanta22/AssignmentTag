//
//  DashboardCellTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 10/02/22.
//

import XCTest
@testable import AssignmentTag

class DashboardCellTests: XCTestCase {

    var cellTest: DashboardCell!
    
    override func setUp() {
        super.setUp()
        cellTest = DashboardCell()
        cellTest.awakeFromNib()
        cellTest.name = "hh"
        cellTest.amount = "44"
        cellTest.amountTextColor = true
        cellTest.transactionId = "6778"
    }
    
    override func tearDownWithError() throws {
        cellTest = nil
    }
    
    func testDataCheck() {
        cellTest.nameLabel?.text = "hhc"
        cellTest.amountLabel?.text = "33"
        cellTest.idLabel?.text = "1212"
        cellTest.setSelected(true, animated: true)
    }

}
