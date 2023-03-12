//
//  ChangePasswordViewCommands.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 09/03/2023.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func resetNewPassword()
    func clearNewPasswordFields()
    func clearAllPasswordFields()
    func updateInputFocus(_ inputFoucs: InputFocus)
    func setCancelButtonEnabled(_ enabled: Bool)
    func hideBlurView()
    func showBlurView()
    func dismissModal()
    func showActivityIndicator()
    func hideActivityIndicator()
    func showAlert(message: String,action: @escaping () -> Void)
}

enum InputFocus {
    case noKeyboard
    case oldPassword
    case newPassword
    case confirmPassword
}
