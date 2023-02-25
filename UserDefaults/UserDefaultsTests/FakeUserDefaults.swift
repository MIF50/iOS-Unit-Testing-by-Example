//
//  FakeUserDefaults.swift
//  UserDefaultsTests
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import Foundation
@testable import UserDefaults

class FakeUserDefaults: UserDefaultsProtocol {
   
    var integers = [String: Int]()
    
    func set(_ value: Int, forKey defaultName: String) {
        integers[defaultName] = value
    }
    
    func integer(forKey defaultName: String) -> Int {
        integers[defaultName] ?? 0
    }
}
