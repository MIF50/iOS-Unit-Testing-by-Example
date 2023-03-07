//
//  ViewController.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 05/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "changePassword" {
            let changePasswordVC = segue.destination as? ChangePasswordViewController
            changePasswordVC?.securityToken = "TOKEN"
        }
    }
}

