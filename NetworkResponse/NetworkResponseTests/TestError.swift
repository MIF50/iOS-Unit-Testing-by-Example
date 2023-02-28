//
//  TestError.swift
//  NetworkResponseTests
//
//  Created by Mohamed Ibrahim on 26/02/2023.
//

import Foundation

struct TestError: LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
