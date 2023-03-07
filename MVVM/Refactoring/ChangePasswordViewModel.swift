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
    
}
