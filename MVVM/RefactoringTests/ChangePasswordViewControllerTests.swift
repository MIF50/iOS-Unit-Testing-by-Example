//
//  ChangePasswordViewControllerTests.swift
//  RefactoringTests
//
//  Created by Mohamed Ibrahim on 05/03/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Refactoring

final class ChangePasswordViewControllerTests: XCTestCase {
    
    private var passwordChanger: MockPasswordChanger!
    private var alertVerifier: AlertVerifier!
    
    @MainActor
    override func setUp() {
        super.setUp()
        
        passwordChanger = MockPasswordChanger()
        alertVerifier = AlertVerifier()
    }
    
    override func tearDown() {
        super.tearDown()
        
        cleanOutUIWindow()
        passwordChanger = nil
        alertVerifier = nil
    }
    
    private func cleanOutUIWindow() {
        executeRunLoop()
    }

    //MARK: - Testing Configration of UI
    
    func test_outlets_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.navigationBar,"navigationBar")
        XCTAssertNotNil(sut.cancelBarButton,"cancelBarButton")
        XCTAssertNotNil(sut.oldPasswordTextField,"oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField,"newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField,"confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton,"submitButton")
    }
    
    func test_navigationBar_shouldHaveTitle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }
    
    func test_cancelBarButton_shouldBeSystemItemCancel() {
        let sut = makeSUT()
        
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }
    
    func test_oldPasswordTextField_shouldHavePlaceholder() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceholder() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceholder() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }
    
    func test_submitButton_shouldHaveTitle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.submitButton.titleLabel?.text, "Submit")
    }
    
    func test_oldPasswordTextField_shouldHavePasswordAttributes() {
        let sut = makeSUT()
        
        let textField = sut.oldPasswordTextField!
        
        XCTAssertEqual(textField.textContentType, .password,"textContentType")
        XCTAssertTrue(textField.isSecureTextEntry,"isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically,"enablesReturnKeyAutomatically")
    }
    
    func test_newPasswordTextField_shouldHavePasswordAttributes() {
        let sut = makeSUT()
        
        let textField = sut.newPasswordTextField!
        
        XCTAssertEqual(textField.textContentType, .newPassword,"textContentType")
        XCTAssertTrue(textField.isSecureTextEntry,"isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically,"enablesReturnKeyAutomatically")
    }
    
    func test_confirmPasswordTextField_shouldHavePasswordAttributes() {
        let sut = makeSUT()
        
        let textField = sut.confirmPasswordTextField!
        
        XCTAssertEqual(textField.textContentType, .newPassword,"textContentType")
        XCTAssertTrue(textField.isSecureTextEntry,"isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically,"enablesReturnKeyAutomatically")
    }
    
    //MARK: - Testing behavior
    
    /// Cancel Bar Button
    
    func test_tapingCancel_withFocusInOldPassword_shouldResingThatFocus() {
        let sut = makeSUT()
        putFocusOn(textField: sut.oldPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder,"precondition")
        
        tap(sut.cancelBarButton)
        
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tapingCancel_withFocusInNewPassword_shouldResingThatFocus() {
        let sut = makeSUT()
        putFocusOn(textField: sut.newPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder,"precondition")
        
        tap(sut.cancelBarButton)
        
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tapingCancel_withFocusInConfirmPassword_shouldResingThatFocus() {
        let sut = makeSUT()
        putFocusOn(textField: sut.confirmPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder,"precondition")
        
        tap(sut.cancelBarButton)
        
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    @MainActor
    func test_tappingCancel_shouldDismissModal() {
        let dismissalVerifier = DismissalVerifier()
        let sut = makeSUT()
        
        tap(sut.cancelBarButton)
        
        dismissalVerifier.verify(animated: true,dismissedViewController: sut)
    }
    
    /// Submit Button
    
    func test_tappingSubmit_withEmptyOldPassword_shouldNotChangePassword() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        sut.oldPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withEmptyOldPassword_shouldPutFocusOnOldPassword() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        sut.oldPasswordTextField.text = ""
        putInViewHierarchy(sut)
        
        tap(sut.submitButton)
        
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withEmptyNewPassword_shouldNotChangePassword() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        sut.newPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor
    func test_tappingSubmit_withEmptyNewPassword_shouldShowPasswordBlankAlert() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        sut.newPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        verifyAlertPresented(in: sut, message: "Please enter a new password.")
    }
    
    @MainActor
    func test_tappingOkPasswordBlankAlert_shouldPutFocusOnNewPassword() throws {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        sut.newPasswordTextField.text = ""
        putInViewHierarchy(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordTooShort_shouldNotChangePassword() {
        let sut = makeSUT()
        setUpEntriesNewPasswordTooShort(sut)
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor
    func test_tappingSubmit_withNewPasswordTooShort_shouldShowTooShortAlert() {
        let sut = makeSUT()
        setUpEntriesNewPasswordTooShort(sut)
        
        tap(sut.submitButton)
        
        verifyAlertPresented(in: sut, message: "The new password should have at least 6 characters.")
    }
    
    @MainActor
    func test_tappingOkInTooShortAlert_shouldCleanNewAndConfirmation() throws {
        let sut = makeSUT()
        setUpEntriesNewPasswordTooShort(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "newPasswordTextField")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmPasswordTextField")
    }
    
    @MainActor
    func test_tappingOkInTooShortAlert_shouldNotCleanOldPassword() throws {
        let sut = makeSUT()
        setUpEntriesNewPasswordTooShort(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }
    
    @MainActor
    func test_tappingOkInTooShortAlert_shouldPutFocusOnNewPassword() throws {
        let sut = makeSUT()
        setUpEntriesNewPasswordTooShort(sut)
        putInViewHierarchy(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.isFirstResponder, true)
    }
    
    func test_tappingSumit_withMismatchConfirmation_shouldNotChangePassword() {
        let sut = makeSUT()
        setUpMismatchConfirmationEntry(sut)
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor
    func test_tappingSumit_withMismatchConfirmation_shouldShowMismatchAlert() {
        let sut = makeSUT()
        setUpMismatchConfirmationEntry(sut)
        
        tap(sut.submitButton)
        
        verifyAlertPresented(in: sut, message: "The new password and the confirmation password don’t match. Please try again.")
    }
    
    @MainActor
    func test_tappingOkInMismatchAlert_shouldCleanNewAndConfirmation() throws {
        let sut = makeSUT()
        setUpMismatchConfirmationEntry(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "newPasswordTextField")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmPasswordTextField")
    }
    
    @MainActor
    func test_tappingOkInMismatchAlert_shouldNotCleanOldPassword() throws {
        let sut = makeSUT()
        setUpMismatchConfirmationEntry(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }
    
    @MainActor
    func test_tappingOkInMismatchAlert_shouldPutFocusOnNewPassword() throws {
        let sut = makeSUT()
        setUpMismatchConfirmationEntry(sut)
        putInViewHierarchy(sut)
        
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.isFirstResponder, true)
    }
    
    /// UI Appearance
    
    func test_tappingSubmit_withValidFieldFocusedInOldPassword_resignFocus() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        putFocusOn(textField: sut.oldPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldFocusedInNewPassword_resignFocus() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        putFocusOn(textField: sut.newPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldFocusedInConfirmPassword_resignFocus() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        putFocusOn(textField: sut.confirmPasswordTextField, in: sut)
        
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFields_shouldDisableCancelBar() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        XCTAssertTrue(sut.cancelBarButton.isEnabled, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertFalse(sut.cancelBarButton.isEnabled)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowBlueView() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        XCTAssertNil(sut.blurView.superview, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertNotNil(sut.blurView.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldActivityIndicator() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        XCTAssertNil(sut.activityIndicator.superview, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertNotNil(sut.activityIndicator.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldStartActivityAnimation() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        XCTAssertFalse(sut.activityIndicator.isAnimating, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func test_tappingSubmit_withValidFields_shouldClearBackgroundColorForBlur() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        XCTAssertNotEqual(sut.view.backgroundColor,.clear, "precondition")
        
        tap(sut.submitButton)
        
        XCTAssertEqual(sut.view.backgroundColor,.clear)
    }
    
    /// password changer
    
    func test_tappingSubmit_withValidFields_shouldRequstChangePassword() {
        let sut = makeSUT()
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChange(securityToken: "TOKEN", oldPassword: "OLD456", newPassword: "NEW456")
    }
    
    func test_changePasswordSuccess_shouldStopActivityIndicator() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating,"precondition")
    
        passwordChanger.changeCallSuccess()
        
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_changePasswordSuccess_shouldHideActivityIndicator() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview,"precondition")
    
        passwordChanger.changeCallSuccess()
        
        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    func test_changePasswordFailure_shouldStopActivityIndicator() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating,"precondition")
    
        passwordChanger.changeCallFailure(message: "DUMMY")
        
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_changePasswordFailure_shouldHideActivityIndicator() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview,"precondition")
    
        passwordChanger.changeCallFailure(message: "DUMMY")

        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    @MainActor
    func test_changePasswordSuccess_shouldSuccessAlert() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
    
        passwordChanger.changeCallSuccess()
        
        verifyAlertPresented(in: sut, message: "Your password has been successfully changed.")
    }
    
    @MainActor
    func test_tappingOkInSuccessAlert_shouldDismissModal() throws {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        let dismissalVerifier = DismissalVerifier()

        try alertVerifier.executeAction(forButton: "OK")
        
        dismissalVerifier.verify(animated: true,dismissedViewController: sut)
    }
    
    @MainActor
    func test_changePasswordFailure_shouldShowFailureAlertWithGivenMessage() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        
        passwordChanger.changeCallFailure(message: "MESSAGE")
        
        verifyAlertPresented(in: sut, message: "MESSAGE")
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldClearAllFieldsToStartOver() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, true,"old password")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true,"new password")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true,"confirm password")
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldPutFocusOnOldPassword() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        putInViewHierarchy(sut)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldSetBackgroundBackToWhite() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        XCTAssertNotEqual(sut.view.backgroundColor, .white,"precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldHideBlur() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        XCTAssertNotNil(sut.blurView.superview,"precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertNil(sut.blurView.superview)
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldEnableCancelButton() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        XCTAssertFalse(sut.cancelBarButton.isEnabled,"precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertTrue(sut.cancelBarButton.isEnabled)
    }
    
    @MainActor
    func test_tappingOKInFailureAlert_shouldNotDismissModal() throws {
        let sut = makeSUT()
        showPasswordChangeFailureAlert(sut)
        let dismissalVerifier = DismissalVerifier()
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(dismissalVerifier.dismissedCount, 0)
    }
    
    
    /// UI TextField Delegate
    
    func test_textFieldDelegates_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.oldPasswordTextField.delegate, "old password delegate")
        XCTAssertNotNil(sut.newPasswordTextField.delegate,"new password delegate")
        XCTAssertNotNil(sut.confirmPasswordTextField.delegate,"confirm password delegate")
    }
    
    func test_hittingReturnFromOldPassword_shouldPutFocusOnNewPassword() {
        let sut = makeSUT()
        putInViewHierarchy(sut)
        
        shouldReturn(in: sut.oldPasswordTextField)
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_hittingReturnFromNewPassword_shouldPutFocusOnConfirmPassword() {
        let sut = makeSUT()
        putInViewHierarchy(sut)
        
        shouldReturn(in: sut.newPasswordTextField)
        
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_hittingReturnFromConfirmPassword_shouldRequestPasswordChange() {
        let sut = makeSUT()
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        
        shouldReturn(in: sut.confirmPasswordTextField)
        
        passwordChanger.verifyChange(securityToken: "TOKEN", oldPassword: "OLD456", newPassword: "NEW456")
    }
    
    func test_hittingReturnFromOldPassword_shouldNotRequestPasswordChange() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        
        shouldReturn(in: sut.oldPasswordTextField)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_hittingReturnFromNewPassword_shouldNotRequestPasswordChange() {
        let sut = makeSUT()
        setUpValidPasswordEntries(sut)
        
        shouldReturn(in: sut.newPasswordTextField)
        
        passwordChanger.verifyChangeNeverCalled()
    }
        
    
    //MARK: - Helpers
    
    private func makeSUT() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        sut.passwordChanger = passwordChanger
        sut.viewModel = ChangePasswordViewModel()
        sut.loadViewIfNeeded()
        return sut
    }
    
    private func showPasswordChangeFailureAlert(_ sut: ChangePasswordViewController) {
        setUpValidPasswordEntries(sut)
        tap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "DUMMY")
    }
    
    private func setUpMismatchConfirmationEntry(_ sut: ChangePasswordViewController) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123455"
        sut.confirmPasswordTextField.text = "abcdef"
    }
    
    private func setUpEntriesNewPasswordTooShort(_ sut: ChangePasswordViewController) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "12345"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func setUpValidPasswordEntries(_ sut: ChangePasswordViewController) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func putFocusOn(textField: UITextField,in sut: ChangePasswordViewController) {
        putInViewHierarchy(sut)
        textField.becomeFirstResponder()
    }
    
    @MainActor
    private func verifyAlertPresented(in sut: ChangePasswordViewController,message: String,file: StaticString = #filePath,line: UInt = #line) {
        alertVerifier.verify(
            title: "",
            message: message,
            animated: true,
            actions: [.default("OK")],
            presentingViewController: sut,
            file: file,
            line: line
        )
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK","preffered action",file: file,line: line)
    }
}

