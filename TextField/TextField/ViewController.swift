//
//  ViewController.swift
//  TextField
//
//  Created by Mohamed Ibrahim on 28/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private(set) var usernameField: UITextField!
    @IBOutlet private(set) var passworodField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func performLogin(username: String,password: String) {
        print("Username: \(username)")
        print("Password: \(password)")
    }
    
    deinit {
        print("ViewController.deinit")
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === usernameField {
            return !string.contains(" ")
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameField {
            passworodField.becomeFirstResponder()
        } else {
            guard let username = usernameField.text,let password = passworodField.text else {
                return false
            }
            passworodField.resignFirstResponder()
            performLogin(username: username,password: password)
        }
        
        return false
    }
}

