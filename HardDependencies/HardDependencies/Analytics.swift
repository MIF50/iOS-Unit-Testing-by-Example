//
//  Analytics.swift
//  HardDependencies
//
//  Created by Mohamed Ibrahim on 14/02/2023.
//

import Foundation

class Analytics {
    
    static let shared = Analytics()
    
    func track(event: String) {
        print(">> " + event)
        if self !== Analytics.shared {
            print(">> ...Not the Analytics singleton")
        }
    }
}
