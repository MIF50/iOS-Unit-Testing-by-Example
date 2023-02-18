//
//  ViewController.swift
//  Alert
//
//  Created by Mohamed Ibrahim on 17/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private(set) var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonTap() {
        let alert = UIAlertController(title: "Do the Thing?",message: "Let us know if you want to do the thing.",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print(">> Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print(">> OK")
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true)
    }
}

