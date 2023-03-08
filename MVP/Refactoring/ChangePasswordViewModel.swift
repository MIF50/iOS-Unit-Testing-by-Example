//
//  ChangePasswordViewModel.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 07/03/2023.
//

import Foundation

struct ChangePasswordViewModel {
    
    var okButtonLabel: String {
        "OK"
    }
    
    var enterNewPasswordMessage: String {
        "Please enter a new password."
    }
    
    var newPasswordTooShortMessage: String {
        "The new password should have at least 6 characters."
    }
    
    var confirmationPasswordDoesNotMatchMessage: String {
        "The new password and the confirmation password don’t match. Please try again."
    }
    
    var successMessage: String {
        "Your password has been successfully changed."
    }
    
    var title: String {
        "Change Password"
    }
    
    var oldPasswordPlaceholder: String {
        "Current Password"
    }
    
    var newPasswordPlaceholder: String {
        "New Password"
    }
    
    var confirmPasswordPlaceholder: String {
        "Confirm New Password"
    }
    
    var submitButtonLabel: String {
        "Submit"
    }
    
    var isCancelButtonEnabled = true
    
    var inputFocus: InputFocus = .noKeyboard
    
    var isBlurViewShowing = false
    
    var isActivityIndicatorShowing = false
    
    var oldPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    
    var isOldPasswordEmpty: Bool {
        oldPassword.isEmpty
    }
    
    var isNewPasswordEmpty: Bool {
        newPassword.isEmpty
    }
    
    var isNewPasswordTooShort: Bool {
        newPassword.count < 6
    }
    
    var isConfirmationPasswordMismatch: Bool {
        newPassword != confirmPassword
    }
    
    enum InputFocus {
        case noKeyboard
        case oldPassword
        case newPassword
        case confirmPassword
    }
}
