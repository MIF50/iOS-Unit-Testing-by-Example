//
//  MySingletonViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Mohamed Ibrahim on 14/02/2023.
//

import XCTest
@testable import HardDependencies

class MySingletonViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        MySingletonAnalytics.stubbedInstance = MySingletonAnalytics()
    }
    
    override func tearDown() {
        super.tearDown()
        
        MySingletonAnalytics.stubbedInstance = nil
    }
    
    func test_viewDidAppear() {
        let sut = MySingletonViewController()
        sut.loadViewIfNeeded()
        
        
        sut.viewDidAppear(false)
        
        //Normally, assert something
    }
}
