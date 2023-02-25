//
//  TestHelpers.swift
//  NetworkRequestTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import UIKit
import XCTest

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func verifyMethodCalledOnce(
    methodName: String,
    callCount: Int,
    describeArguments: @autoclosure () -> String,
    file: StaticString = #filePath,
    line: UInt = #line
) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)",file: file, line: line)
        return false
    }
    
    if callCount > 1 {
        XCTFail("Wanted 1 time but was called \(callCount) times. " + "\(methodName) with \(describeArguments())",file: file, line: line)
        return false
    }
    
    return true
}
