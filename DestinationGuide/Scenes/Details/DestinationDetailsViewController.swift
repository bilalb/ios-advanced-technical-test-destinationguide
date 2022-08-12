//
//  DestinationDetailsViewController.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 18/07/2022.
//

import UIKit
import WebKit

class DestinationDetailsController: UIViewController {
    
    private let name: String
    private let webviewUrl: URL
    
    init(title: String, webviewUrl: URL) {
        self.name = title
        self.webviewUrl = webviewUrl
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.evaneos(color: .veraneos)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.webView.navigationDelegate = self
        
        self.addView()
        
        self.navigationItem.title = name
        
        let request = URLRequest(url: self.webviewUrl)
        self.webView.load(request)
        
    }
    
    //  MARK: - Functions
    
    private func addView() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.activityIndicator)
        self.constraintInit()
    }
    
    private func constraintInit() {
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        ])
        
        self.activityIndicator.center = self.view.center
    }
}

//  MARK: - WKWebView delegate

extension DestinationDetailsController: WKNavigationDelegate {
    
    private func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
