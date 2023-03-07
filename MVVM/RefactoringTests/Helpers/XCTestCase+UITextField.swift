//
//  XCTestCase+UITextField.swift
//  RefactoringTests
//
//  Created by Mohamed Ibrahim on 07/03/2023.
//

import UIKit

@discardableResult
func shouldReturn(in textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}
