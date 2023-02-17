//
//  ClosurePropertyViewController.swift
//  HardDependencies
//
//  Created by Mohamed Ibrahim on 14/02/2023.
//

import UIKit

class ClosurePropertyViewController: UIViewController {
    
    var makeAnalaytics: () -> Analytics = { .shared }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        makeAnalaytics().track(event: "viewDidAppear - \(type(of: self))")
    }
}
