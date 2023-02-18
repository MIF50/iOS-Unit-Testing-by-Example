//
//  SegueNextViewController.swift
//  Navigation
//
//  Created by Mohamed Ibrahim on 18/02/2023.
//

import UIKit

class SegueNextViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private(set) var label: UILabel!
    
    var labelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = labelText
    }
    
    deinit {
        print(">> SegueNextViewController.deinit")
    }
}
