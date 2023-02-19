//
//  ViewControllerTests.swift
//  NavigationTests
//
//  Created by Mohamed Ibrahim on 18/02/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Navigation


final class ViewControllerTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        executeRunLoop()
    }

    func test_outlets_shouldBeConnected() {
        let sut = makeSUT()

        XCTAssertNotNil(sut.codePushButton,"codePushButton")
        XCTAssertNotNil(sut.codeModalButton,"codeModalButton")
        XCTAssertNotNil(sut.seguePushButton,"seguePushButton")
        XCTAssertNotNil(sut.segueModalButton,"segueModalButton")
    }

    func test_tappingCodePushButton_shouldPushCodeNextViewController() {
        let sut = makeSUT()
        let navigtaion = NavigationControllerSpy(rootViewController: sut)

        tap(sut.codePushButton)
        executeRunLoop()

        XCTAssertEqual(navigtaion.viewControllers.count, 2,"navigation stack")
        XCTAssertEqual(navigtaion.pushViewControllersArgsAnimated.last,true)
        let pushedVC = navigtaion.topViewController
        guard let codeNextVC = pushedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController ,got \(String(describing: pushedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
    }

    func test_INCORRECT_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let sut = makeSUT()
        UIApplication.shared.mainWindow?.rootViewController = sut

        tap(sut.codeModalButton)

        let presentedVC = sut.presentedViewController
        guard let codeNextVC = presentedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, got \(String(describing: presentedVC))")
            return
        }

        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }

    @MainActor
    func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()

        tap(sut.codeModalButton)

        let presentedVC = presentationVerifier.verify(animated: true,presentingViewController: sut)
        guard let codeNextVC = presentedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, got \(String(describing: presentedVC))")
            return
        }

        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }

    @MainActor
    func test_tappingSeguePushButton_shouldShowSegueNextViewController() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()
        putInWindow(sut)

        tap(sut.seguePushButton)

        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true,presentingViewController: sut)
        XCTAssertEqual(segueNextVC?.label.text, "Pushed from segue")
    }
    
    
    /// Unfortunately, by peering into the console output, we can see that both view controllers still exist
    @MainActor
    func test_tappingSegueModalButton_shouldShowSegueNextViewController() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()
        
        tap(sut.segueModalButton)
        
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true,presentingViewController: sut)
        XCTAssertEqual(segueNextVC?.label.text, "Modal from segue")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        
        return sut
    }
    
    private class NavigationControllerSpy: UINavigationController {
        
        private(set) var pushViewControllersArgsAnimated = [Bool]()
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: animated)
            
            pushViewControllersArgsAnimated.append(animated)
            
        }
    }
    
    // We can't use this for a view controller that comes from a storyboard.
    private class TestableViewController: ViewController {
        
        var presentCallCount = 0
        var presentArgsViewController: [UIViewController] = []
        var presentArgsAnimated: [Bool] = []
        var presentArgsClosure: [(() -> Void)?] = []
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCallCount += 1
            presentArgsViewController.append(viewControllerToPresent)
            presentArgsAnimated.append(flag)
            presentArgsClosure.append(completion)
        }
    }

}

private extension UIApplication {
    
    var mainWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
}
