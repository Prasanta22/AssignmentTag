//
//  DashboardViewControllerTests.swift
//  AssignmentTagTests
//
//  Created by Prasanta Santikari on 10/02/22.
//

import XCTest
@testable import AssignmentTag

class DashboardViewControllerTests: XCTestCase {
    
    var dashViewController: DashboardViewController!
    
    override func setUp() {
        super.setUp()
        dashViewController = DashboardViewController()
        dashViewController.viewDidLoad()
        dashViewController.viewWillAppear(true)
        dashViewController.viewWillDisappear(true)
    }
    
    override func tearDownWithError() throws {
        dashViewController = nil
    }
    
    func testPullToRefresh() {
        dashViewController.pullToRefresh()
        dashViewController.pullRefresh()
    }
    
    func testlogOut() {
        dashViewController.logOut(sender: UIButton())
    }
    
    func testNavigateToTransferVC() {
        dashViewController.navigateToTransferVC()
    }
    
    func testtransferButtonAction() {
        dashViewController.transferButtonAction(UIButton())
    }
}
