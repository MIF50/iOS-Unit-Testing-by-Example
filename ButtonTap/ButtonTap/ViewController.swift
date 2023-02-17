//
//  ViewController.swift
//  ButtonTap
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Oulets
    @IBOutlet private(set) var button: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func buttonTap() {
        print(">> Button was tapped")
    }
}

