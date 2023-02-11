//
//  CodeBasedViewControllerTests.swift
//  LoadViewControllersTests
//
//  Created by Mohamed Ibrahim on 11/02/2023.
//

import XCTest
@testable import LoadViewControllers

class CodeBasedViewControllerTests: XCTestCase {
    
    func test_loading() {
        let sut = CodeBasedViewController(data: "dummy")
        
        sut.loadViewIfNeeded()
        
        // Normally, assert something
    }
}
