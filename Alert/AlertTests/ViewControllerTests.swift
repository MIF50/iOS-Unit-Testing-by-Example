//
//  ViewControllerTests.swift
//  AlertTests
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Alert

typealias AlertHandler = (UIAlertAction) -> Void

class AlertPresenter {
    private var actionHandlers = [UIAlertAction: AlertHandler]()
    
    func addAction(titled title: String,
                   style: UIAlertAction.Style,
                   handler: AlertHandler?) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        actionHandlers[action] = handler
    }
    
    func present(title: String, message: String, on controller: UIViewController) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        actionHandlers.keys.forEach({ alert.addAction($0) })
        controller.present(alert, animated: false, completion: nil)
    }
    
    func handler(for action: UIAlertAction) -> AlertHandler? {
        return actionHandlers[action]
    }
}

@MainActor
final class ViewControllerTests: XCTestCase {
    
    private var alertVerifier: AlertVerifier!
    
    override func setUp() {
        super.setUp()
        
        alertVerifier = AlertVerifier()
    }
    
    override func tearDown() {
        super.tearDown()
        
        alertVerifier = nil
    }
    
    func test_outlets_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.button, "button")
    }

    func test_tappingButton_shouldShowAlert() {
        let sut = makeSUT()
        
        tap(sut.button)
        
        alertVerifier.verify(title: "Do the Thing?",
                             message: "Let us know if you want to do the thing.",
                             animated: true,
                             actions: [
                                .cancel("Cancel"),
                                .default("OK")
                             ]
                             ,presentingViewController: sut
        )
        
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK","prefered actions")
    }
    
    func test_executeAlertButton_withOkButton() throws {
        let sut = makeSUT()
        
        tap(sut.button)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        //Normally, assert something
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        
        return sut
    }
}

