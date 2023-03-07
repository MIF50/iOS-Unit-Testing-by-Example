//
//  TestHelpers.swift
//  RefactoringTests
//
//  Created by Mohamed Ibrahim on 05/03/2023.
//

import XCTest


func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func putInViewHierarchy(_ vc: UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
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

func verifyMethodNeverCalled(
    methodName: String,
    callCount: Int,
    describeArguments: @autoclosure () -> String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let times = callCount == 1 ? "time" : "times"
    if callCount > 0 {
        XCTFail("Never wanted but was called \(callCount) \(times). \(methodName) with \(describeArguments())",file: file, line: line)
    }
}
