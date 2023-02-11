//
//  XIBBasedViewControllerTests.swift
//  LoadViewControllersTests
//
//  Created by Mohamed Ibrahim on 11/02/2023.
//

import XCTest
@testable import LoadViewControllers

class XIBBasedViewControllerTests: XCTestCase {
    
    func test_loading() {
        let sut = XIBBasedViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.label)
    }
}
