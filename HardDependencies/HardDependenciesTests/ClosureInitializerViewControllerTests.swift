//
//  ClosureInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import HardDependencies

final class ClosureInitializerViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = ClosureInitializerViewController(makeAnalytics: { Analytics() })
        sut.loadViewIfNeeded()
        
        sut.viewDidAppear(false)
        
        //Normally, assert something
    }
}

