//
//  ClosurePropertyViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import HardDependencies

final class ClosurePropertyViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ClosurePropertyViewController = storyboard.instantiateViewController(identifier: String(describing: ClosurePropertyViewController.self))
        sut.makeAnalaytics = { Analytics() }
        sut.loadViewIfNeeded()
        
        sut.viewDidAppear(false)
        
        //Normally, assert something
    }
}

