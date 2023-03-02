//
//  UITextAutocorrectionType+XCTestCaseHelper.swift
//  TextFieldTests
//
//  Created by Mohamed Ibrahim on 02/03/2023.
//

import UIKit

extension UITextAutocorrectionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .yes:
            return "yes"
        case .no:
            return "no"
        @unknown default:
            fatalError("Unknown UITextAutocorrectionType")
        }
    }
}
