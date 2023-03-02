//
//  UITextField+XCTestCaseHelper.swift
//  TextFieldTests
//
//  Created by Mohamed Ibrahim on 02/03/2023.
//

import UIKit

func shouldChangeCharacters(in textField: UITextField,range: NSRange = NSRange(),replacement: String) -> Bool? {
    textField.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: replacement)
}

@discardableResult
func shouldReturn(_ textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}
