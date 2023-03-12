//
//  PasswordInputs.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 11/03/2023.
//

import Foundation

struct PasswordInputs {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String

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
        newPassword !=  confirmPassword
    }
}
