//
//  StoryboardBasedViewControllerTests.swift
//  LoadViewControllersTests
//
//  Created by Mohamed Ibrahim on 11/02/2023.
//

import XCTest
@testable import LoadViewControllers

class StoryboardBasedViewControllerTests: XCTestCase {
    
    func test_loading() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: StoryboardBasedViewController = storyboard.instantiateViewController(identifier: String(describing: StoryboardBasedViewController.self))
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.label)
    }
}
