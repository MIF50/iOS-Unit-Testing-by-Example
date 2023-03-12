//
//  ChangePasswordPresenter.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 11/03/2023.
//

import Foundation

class ChangePasswordPresenter {
    
    private unowned var view: ChangePasswordViewCommands
    private let labels: ChangePasswordLabels
    private let securityToken: String
    private let passwordChanger: PasswordChanging
    
    init(view: ChangePasswordViewCommands, labels: ChangePasswordLabels, securityToken: String, passwordChanger: PasswordChanging) {
        self.view = view
        self.labels = labels
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
    
    func changePassword(passwordInputs: PasswordInputs) {
        guard validateInputs(passwordInputs) else {
            return
        }
        setupWaitingAppearance()
        attemptToChangePassword(passwordInputs: passwordInputs)
    }
    
    func cancel() {
        view.updateInputFocus(.noKeyboard)
        view.dismissModal()
    }
    
    private func validateInputs(_ passwordInputs: PasswordInputs) -> Bool {
        if passwordInputs.isOldPasswordEmpty {
            view.updateInputFocus(.oldPassword)
            return false
        }
        
        if passwordInputs.isNewPasswordEmpty {
            view.showAlert(message: labels.enterNewPasswordMessage) { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            }
            return false
        }
        
        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: labels.newPasswordTooShortMessage) { [weak self] in
                self?.view.resetNewPassword()
            }
            return false
        }
        
        if passwordInputs.isConfirmationPasswordMismatch {
            view.showAlert(message: labels.confirmationPasswordDoesNotMatchMessage) { [weak self] in
                self?.view.resetNewPassword()
            }
            return false
        }
        return true
    }
    
    private func setupWaitingAppearance() {
        view.updateInputFocus(.noKeyboard)
        view.setCancelButtonEnabled(false)
        view.showBlurView()
        view.showActivityIndicator()
    }
    
    private func attemptToChangePassword(passwordInputs: PasswordInputs) {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: passwordInputs.oldPassword,
            newPassword: passwordInputs.newPassword,
            onSuccess: handleOnSuccess,
            onFailure: handleOnFailure(message:)
        )
    }
    
    private func handleOnFailure(message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }
    
    private func handleOnSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: labels.successMessage) { [weak self] in
            self?.view.dismissModal()
        }
    }
    
    private func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.hideBlurView()
        view.setCancelButtonEnabled(true)
    }
}
