//
//  ViewControllerTests.swift
//  NetworkResponseTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import NetworkResponse

final class ViewControllerTests: XCTestCase {
    
    private var alertVerifier: AlertVerifier!
    
    @MainActor
    override func setUp() {
        super.setUp()
        
        alertVerifier = AlertVerifier()
    }
    
    override func tearDown() {
        super.tearDown()
        
        alertVerifier = nil
    }

    func test_searchForBookNetworkCall_withSuccessResponse_shouldSaveDataInResults() {
        let (sut,sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        let exp = expectation(description: "wait for result")
        sut.handlerResults = { _ in
            exp.fulfill()
        }
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)
        
        wait(for: [exp], timeout: 0.01)
        
        XCTAssertEqual(sut.results, [.init(artistName: "Artist", trackName: "Track", averageUserRating: 2.5, genres: ["Foo","Bar"])])
    }
    
    func test_searchForBookNetworkCall_withSuccessBeforeAsync_shouldNotSaveDataInResults() {
        let (sut, sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)
                
        XCTAssertEqual(sut.results, [])
    }
    
    @MainActor
    func test_searchForBookNetworkCall_withError_showAlert() {
        let (sut, sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        let exp = expectation(description: "wait for error")
        alertVerifier.testCompletion = {
            exp.fulfill()
        }
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(nil,nil,TestError(message: "Oh no error"))
        
        wait(for: [exp], timeout: 0.01)
        
        verifierErrorAlert(in: sut, message: "Oh no error")
    }
    
    @MainActor
    func test_searchForBookNetworkCall_withErrorPreAsyc_shouldNotShowAlert() {
        let (sut, sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(nil,nil,TestError(message: "Oh no error"))
        
        XCTAssertEqual(alertVerifier.presentedCount, 0)
    }
    
    @MainActor
    func test_searchForBookNetworkCall_withInvalidJson_showAlert() {
        let (sut, sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        let exp = expectation(description: "wait for error")
        alertVerifier.testCompletion = {
            exp.fulfill()
        }
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(invalidJsonData(),response(statusCode: 200),nil)
        
        wait(for: [exp], timeout: 0.01)
        
        verifierErrorAlert(in: sut, message: "The data couldn’t be read because it is missing.")
    }
    
    @MainActor
    func test_searchForBookNetworkCall_withNot200HTTPResponse_showAlert() {
        let (sut, sessionSpy) = makeSUT()
        
        tap(sut.button)
        
        let exp = expectation(description: "wait for error")
        alertVerifier.testCompletion = {
            exp.fulfill()
        }
        
        sessionSpy.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 500),nil)
        
        wait(for: [exp], timeout: 0.01)
        
        XCTAssertEqual(alertVerifier.presentedCount, 1)
    }
    
    func test_searchForBookNetworkCall_disableButtonWhileCallApi_enableAfterFinish() {
        let (sut,sessionSpy) = makeSUT()
        
        XCTAssertEqual(sut.button.isEnabled, true,"precondidtion")
        tap(sut.button)
        
        XCTAssertEqual(sut.button.isEnabled, false)

        let exp = expectation(description: "wait for result")
        sut.handlerResults = { _ in
            exp.fulfill()
        }

        sessionSpy.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)

        wait(for: [exp], timeout: 0.01)

        XCTAssertEqual(sut.button.isEnabled, true)
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> (sut: ViewController,session: SpyURLSession) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        let sessionSpy = SpyURLSession()
        sut.session = sessionSpy
        sut.loadViewIfNeeded()
        
        return (sut,sessionSpy)
    }
    
    private func response(statusCode: Int) -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "http://dummy.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
    
    private func invalidJsonData() -> Data {
    """
    {
        "results": [
            {
                "artistName": "Artist",
                "trackName": "Track",
                "genres": ["Foo","Bar"]
            }
       ]
    }
    """.data(using: .utf8)!
    }
    
    private func jsonData() -> Data {
    """
    {
        "results": [
            {
                "artistName": "Artist",
                "trackName": "Track",
                "averageUserRating": 2.5,
                "genres": ["Foo","Bar"]
            }
       ]
    }
    """.data(using: .utf8)!
    }
    
    @MainActor
    private func verifierErrorAlert(
        in sut: ViewController,
        message: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        alertVerifier.verify(
            title: "Network Problem",
            message: message,
            animated: true,
            actions: [.default("OK")],
            presentingViewController: sut,
            file: file,
            line: line
        )
        
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK","preferred action",file: file,line: line)
    }

}

