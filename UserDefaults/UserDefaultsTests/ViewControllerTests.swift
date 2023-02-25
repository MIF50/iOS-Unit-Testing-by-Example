//
//  ViewControllerTests.swift
//  UserDefaultsTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import XCTest
@testable import UserDefaults

final class ViewControllerTests: XCTestCase {

    func test_viewDidLoad_withEmptyUserDefaults_shouldShow0InCounterLabel() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.counterLabel.text, "0")
    }
    
    func test_viewDidLoad_with7InUserDefaults_shouldShow7InCounterLabel() {
        let (sut, _) = makeSUT(count: 7)
                
        XCTAssertEqual(sut.counterLabel.text, "7")
    }
    
    func test_tappingButton_with12InUserDefaults_shouldWrite13ToUserDefaults() {
        let (sut, defaults) = makeSUT(count: 12)
        
        tap(sut.incrementButton)
        
        XCTAssertEqual(defaults.integers["count"], 13)
    }
    
    func test_tappingButton_with42InUserDefaults_shouldShow43InCounterLabel() {
        let (sut, _) = makeSUT(count: 42)
        
        tap(sut.incrementButton)
        
        XCTAssertEqual(sut.counterLabel.text, "43")
    }
    
    //MARK: - Helper
    
    private func makeSUT(count: Int = 0) ->  (sut: ViewController,defaults: FakeUserDefaults) {
        let defaultFake = FakeUserDefaults()
        defaultFake.integers = ["count":count]
        
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storybaord.instantiateViewController(identifier: String(describing: ViewController.self))
        
        sut.userDefaults = defaultFake
        sut.loadViewIfNeeded()
        
        return (sut,defaultFake)
    }
}

