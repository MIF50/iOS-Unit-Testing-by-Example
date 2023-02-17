//
//  OverrideViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import HardDependencies

private class TestableOverrideViewController: OverrideViewController {
    
    override func analytics() -> Analytics { Analytics() }
}

final class OverrideViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = TestableOverrideViewController()
        sut.loadViewIfNeeded()
        
        sut.viewDidAppear(false)
        
        // Normally, assert something
    }
}

