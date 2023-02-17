//
//  PropertyViewController.swift
//  HardDependencies
//
//  Created by Mohamed Ibrahim on 14/02/2023.
//

import UIKit

class InstancePropertyViewController: UIViewController {
    
    lazy var analytics: Analytics = Analytics.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analytics.track(event: "viewDidAppear - \(type(of: self))")
    }
}
