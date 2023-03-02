//
//  TestHelpers.swift
//  TextFieldTests
//
//  Created by Mohamed Ibrahim on 01/03/2023.
//

import UIKit

func putInViewHierarchy(_ vc: UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
