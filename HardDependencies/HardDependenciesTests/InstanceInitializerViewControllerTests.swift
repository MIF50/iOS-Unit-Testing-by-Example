//
//  InstanceInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import HardDependencies

final class InstanceInitializerViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = InstanceInitializerViewController(analytics: Analytics())
        sut.loadViewIfNeeded()
        
        sut.viewDidAppear(false)
        
        //Normall, assert something
    }
}

