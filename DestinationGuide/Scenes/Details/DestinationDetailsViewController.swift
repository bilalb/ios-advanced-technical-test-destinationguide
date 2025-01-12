//
//  DestinationDetailsViewController.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 18/07/2022.
//

import Combine
import UIKit
import WebKit

final class DestinationDetailsViewController: UIViewController {
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    private weak var coordinator: Coordinator?

    init(viewModel: ViewModel,
         coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
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

        bindViewModel()
        viewModel.getDestinationDetails()
    }
}

//  MARK: - Private Binding Methods

extension DestinationDetailsViewController {
    func bindViewModel() {
        viewModel.presentError
            .sink { [activityIndicator, coordinator] error in
                activityIndicator.stopAnimating()
                coordinator?.showError(error)
            }
            .store(in: &cancellables)

        viewModel.$title
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)

        viewModel.$webViewURLRequest
            .compactMap { $0 }
            .sink { [webView] in webView.load($0) }
            .store(in: &cancellables)
    }
}

//  MARK: - Private UI Methods

extension DestinationDetailsViewController {
    func addView() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.activityIndicator)
        self.constraintInit()
    }

    func constraintInit() {
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        ])

        self.activityIndicator.center = self.view.center
    }
}

//  MARK: - WKNavigationDelegate

extension DestinationDetailsViewController: WKNavigationDelegate {
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
