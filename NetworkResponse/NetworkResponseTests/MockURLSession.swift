//
//  MockURLSession.swift
//  NetworkRequestTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import UIKit
import XCTest
@testable import NetworkResponse

class MockURLSession: URLSessionProtocol {
    
    var dataTaskCallCount = 0
    var dataTaskArgsRequest = [URLRequest]()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)
        
        return DummyURLsessionDataTask()
    }
    
    func verifyDataTask(with request: URLRequest,file: StaticString = #filePath,line: UInt = #line) {
        guard dataTaskWasCalledOnce(file: file,line: line) else { return }
        
        XCTAssertEqual(dataTaskCallCount,1, "call count",file: file,line: line)
        XCTAssertEqual(dataTaskArgsRequest.first,request, "request",file: file,line: line)
    }
    
    private func dataTaskWasCalledOnce(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "dataTask(with:completionHandler:)",
            callCount: dataTaskCallCount,
            describeArguments: "request: \(dataTaskArgsRequest)",
            file: file,
            line: line
        )
    }
}

private class DummyURLsessionDataTask: URLSessionDataTask {
    override func resume() {}
}
