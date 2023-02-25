//
//  ViewControllerTests.swift
//  NetworkRequestTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import XCTest
@testable import NetworkRequest

final class ViewControllerTests: XCTestCase {

    func test_tappingButton_shouldMakeDataTaskToSearchForEBookOutFromBoneville() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        let mockSession = MockURLSession()
        
        sut.session = mockSession
        sut.loadViewIfNeeded()
        
        tap(sut.button)
        
        mockSession.verifyDataTask(with: URLRequest(url: URL(string: "https://itunes.apple.com/search?media=ebook&term=out%20from%20boneville")!))
    }
}

