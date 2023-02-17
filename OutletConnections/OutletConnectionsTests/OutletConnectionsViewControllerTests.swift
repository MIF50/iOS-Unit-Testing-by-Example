//
//  OutletConnectionsViewControllerTests.swift
//  OutletConnectionsTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import OutletConnections

final class OutletConnectionsViewControllerTests: XCTestCase {

    func test_outlets_shouldBeConnected() {
        let sut = OutletConnectionsViewController()
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.label,"lable")
        XCTAssertNotNil(sut.button, "button")
    }
}

