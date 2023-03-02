//
//  ViewControllerTests.swift
//  TextFieldTests
//
//  Created by Mohamed Ibrahim on 28/02/2023.
//

import XCTest
@testable import TextField

final class ViewControllerTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        executeRunLoop()
    }

    func test_outlets_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.usernameField,"usernameField")
        XCTAssertNotNil(sut.passworodField,"passworodField")
    }
    
    func test_usernameField_attributesShouldBeSet() {
        let sut = makeSUT()
        
        let textField = sut.usernameField!
        
        XCTAssertEqual(textField.textContentType, .username,"textConentType")
        XCTAssertEqual(textField.autocorrectionType, .no,"autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .next,"returnKeyType")
    }
    
    func test_passwordField_attributesShouldBeSet() {
        let sut = makeSUT()
        
        let textField = sut.passworodField!
        
        XCTAssertEqual(textField.textContentType, .password,"textConentType")
        XCTAssertEqual(textField.autocorrectionType, .no,"autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .go,"returnKeyType")
        XCTAssertEqual(textField.isSecureTextEntry, true,"isSecureTextEnty")
    }
    
    func test_textFieldDelegates_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.usernameField.delegate, "usernameField delegate")
        XCTAssertNotNil(sut.passworodField.delegate,"passwordField delegate")
    }
    
    func test_shouldChangeCharacters_usernameWithSpaces_shouldPreventChange() {
        let sut = makeSUT()
        
        let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "a b")
        
        XCTAssertEqual(allowChange, false)
    }
    
    func test_shouldChangeCharacters_usernameWithoutSpaces_shouldAllowChange() {
        let sut = makeSUT()
        
        let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "acb")
        
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldChangeCharacters_passwordWithSpaces_shouldAllowChange() {
        let sut = makeSUT()
        
        let allowChange = shouldChangeCharacters(in: sut.passworodField, replacement: "a b")
        
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldChangeCharacters_passwordWithoutSpaces_shouldAllowChange() {
        let sut = makeSUT()
        
        let allowChange = shouldChangeCharacters(in: sut.passworodField, replacement: "acb")
        
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldReturn_withPassword_performLogin() {
        let sut = makeSUT()
        sut.usernameField.text = "USERNAME"
        sut.passworodField.text = "PASSWORD"
        
        shouldReturn(sut.passworodField)
        
        // Normally, assert something
    }
    
    func test_shouldReturn_withUsername_shouldMoveInputFocusToPassword() {
        let sut = makeSUT()
        putInViewHierarchy(sut)
        
        shouldReturn(sut.usernameField)
        
        XCTAssertTrue(sut.passworodField.becomeFirstResponder())
    }
    
    
    func test_shouldReturn_withPassword_shouldDismissKeyboard() {
        let sut = makeSUT()
        putInViewHierarchy(sut)
        sut.passworodField.becomeFirstResponder()
        XCTAssertTrue(sut.passworodField.isFirstResponder,"precondition")
        
        shouldReturn(sut.passworodField)
        
        XCTAssertFalse(sut.passworodField.isFirstResponder)
    }

    //MARK: - Helpers
    
    private func makeSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        
        return sut
    }
}

