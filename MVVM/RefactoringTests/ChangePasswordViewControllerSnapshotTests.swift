//
//  ChangePasswordViewControllerSnapshotTests.swift
//  RefactoringTests
//
//  Created by Mohamed Ibrahim on 06/03/2023.
//

import XCTest
@testable import Refactoring

final class ChangePasswordViewControllerSnapshotTests: XCTestCase {
    
    func test_viewController_inLightAndDark() {
        let sut = makeSUT()
        
        let changePasswordViewContoller_light = sut.snapshot(for: .iPhone13(style: .light))
        let changePasswordViewContoller_dark = sut.snapshot(for: .iPhone13(style: .dark))
        
        assert(snapshot: changePasswordViewContoller_light, named: "ChangePasswordViewController_light")
        assert(snapshot: changePasswordViewContoller_dark, named: "ChangePasswordViewController_dark")
    }
    
    func test_viewController_inBlur() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        
        tap(sut.submitButton)
        
        let blur_light = sut.snapshot(for: .iPhone13(style: .light))
        let blur_dark = sut.snapshot(for: .iPhone13(style: .dark))
        
        assert(snapshot: blur_light, named: "loading_blur_light")
        assert(snapshot: blur_dark, named: "loading_blur_dark")
    }
    
    //MARK: - Helpers

    private func makeSUT() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        sut.loadViewIfNeeded()
        return sut
    }
    
    private func setUpValidPasswordEntries(_ sut: ChangePasswordViewController) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
}

