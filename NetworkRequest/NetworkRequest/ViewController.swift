//
//  ViewController.swift
//  NetworkRequest
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import UIKit

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class ViewController: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet private(set) var button: UIButton!
    
    private var dataTask: URLSessionDataTask?
    
    var session: URLSessionProtocol = URLSession.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonTapped() {
        searchForBook(terms: "out from boneville")
    }
    
    private func searchForBook(terms: String) {
        guard let encodedTerms = terms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?" + "media=ebook&term=\(encodedTerms)") else { return }
        
        let request = URLRequest(url: url)
        
        dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            
            let decoded = String(data: data ?? Data(), encoding: .utf8)
            
            print("response: \(String(describing: response))")
            print("data: \(String(describing: decoded))")
            print("error: \(String(describing: error))")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.dataTask = nil
                self.button.isEnabled = true
            }
        })
        
        button.isEnabled = false
        dataTask?.resume()
    }
}

