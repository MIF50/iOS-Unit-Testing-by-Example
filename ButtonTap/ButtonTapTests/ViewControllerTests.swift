//
//  ViewControllerTests.swift
//  ButtonTapTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
@testable import ButtonTap

final class ViewControllerTests: XCTestCase {

    func test_outlets_shouldBeConnected() {
       let sut = makeSUT()
        
        XCTAssertNotNil(sut.button)
    }
    
    func test_tappingButton() {
        let sut = makeSUT()
        
        tap(sut.button)
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        return sut
    }

}

