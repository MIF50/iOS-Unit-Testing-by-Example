//
//  UIReturnKeyType+XCTestCaseHelper.swift
//  TextFieldTests
//
//  Created by Mohamed Ibrahim on 02/03/2023.
//

import UIKit

extension UIReturnKeyType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .go:
            return "go"
        case .next:
            return "next"
        case .continue:
            return "continue"
        case .done:
            return "done"
        case .google:
            return "google"
        case .join:
            return "join"
        case .route:
            return "route"
        case .search:
            return "search"
        case .send:
            return "send"
        case .yahoo:
            return"yahoo"
        case .emergencyCall:
            return "emergencyCall"
        @unknown default:
            fatalError("Unknown UIReturnKeyType")
        }
    }
}
