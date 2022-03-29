//
//  NavigationViewController.swift
//  Caravel
//
//  Created by Idwall Go Dev 003 on 28/03/22.
//

import UIKit
import WebKit

class NavigationViewController: UIViewController {

    let baseUrl = "http://www.google.com/search?q="
    var search: String?
    
    lazy var searchBar: UISearchBar! = {
        let searchBar = UISearchBar(frame: .zero)
        
        searchBar.layer.borderColor = UIColor.label.cgColor
        searchBar.searchBarStyle = .minimal
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.tintColor = .systemRed
        searchBar.searchTextField.returnKeyType = .search
        searchBar.searchTextField.enablesReturnKeyAutomatically = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var webView: WKWebView = {
        let webViewConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        setupDelegates()
        loadWebView(search: search)
    }
    
    private func configUI() {
        title = "ASD"
        view.backgroundColor = .systemBackground
        
        configSearchBar()
        configWebView()
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    private func loadWebView(search: String?) {
        
        if let url = search {
            
            let prefix = String("www")
            if url.lowercased().hasPrefix(prefix) {
                let newUrl = "https:/\(url)"
                if verifyUrl(urlString: newUrl) {
                    goToUrl(urlString: newUrl)
                    return
                }
            }
             else {
                goToUrl(urlString: "\(baseUrl)\(url)")
                return
            }
        }
        
        goToUrl(urlString: baseUrl)
    }
    
    private func goToUrl(urlString: String) {
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    private func configSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.85)
        ])
    }
    
    private func configWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            webView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

extension NavigationViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

}

extension NavigationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.resignFirstResponder()
        let searchText = searchBar.searchTextField.text ?? baseUrl

        loadWebView(search: searchText)
        
        return true
    }
}
