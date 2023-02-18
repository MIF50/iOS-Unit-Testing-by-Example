//
//  CodeNextViewController.swift
//  Navigation
//
//  Created by Mohamed Ibrahim on 18/02/2023.
//

import UIKit

class CodeNextViewController: UIViewController {
    
    let label = UILabel()
    
    init(labelText: String){
        label.text = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

    }
    
    deinit {
        print(">> CodeNextViewController.deinit")
    }
}
