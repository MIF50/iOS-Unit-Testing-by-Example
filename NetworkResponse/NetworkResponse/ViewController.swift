//
//  ViewController.swift
//  NetworkResponse
//
//  Created by Mohamed Ibrahim on 25/02/2023.
//

import UIKit

struct Search: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable, Equatable {
    let artistName: String
    let trackName: String
    let averageUserRating: Float
    let genres: [String]
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class ViewController: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet private(set) var button: UIButton!
    
    private var dataTask: URLSessionDataTask?
    
    var session: URLSessionProtocol = URLSession.shared
    
    var handlerResults: (([SearchResult]) -> Void) = { print($0) }
    
    private(set) var results: [SearchResult] = [] {
        didSet {
            handlerResults(results)
        }
    }

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
            
            var decoded: Search?
            var errorMessage: String?
            
            if let error {
                errorMessage = error.localizedDescription
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                errorMessage = "response: " + HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            } else if let data {
                do {
                    decoded = try JSONDecoder().decode(Search.self, from: data)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            
            DispatchQueue.main.async { [weak self,decoded,errorMessage] in
                guard let self = self else { return }
                
                if let decoded {
                    self.results = decoded.results
                }
                
                if let errorMessage {
                    self.showError(errorMessage)
                }
                
                self.dataTask = nil
                self.button.isEnabled = true
            }
            
        })
        
        button.isEnabled = false
        dataTask?.resume()
    }
    
    private func showError(_ message: String) {
        let title = "Network Problem"
        print("\(title): \(message)")
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true)
    }
}

