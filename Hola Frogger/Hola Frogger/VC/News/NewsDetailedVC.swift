//
//  NewsDetailedVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 14/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailedVC: UIViewController {

    var articleLink: String?
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        webView.navigationDelegate = self
        
        configureViews()
        loadWebPage()
    }
    
    private func configureViews() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        addViewConstrians()
        
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.raspberryPieTint()
        activityIndicator.style = .large
    }
    
    private func addViewConstrians() {
        webView.addAnchor(top: view.topAnchor, paddingTop: 0,
                          left: view.leftAnchor, paddingLeft: 0,
                          bottom: view.bottomAnchor, paddingBottom: 0,
                          right: view.rightAnchor, paddingRight: 0,
                          width: 0, height: 0, enableInsets: true)
    
        webView.backgroundColor = .raspberryPieTint()
        
        activityIndicator.addAnchor(top: webView.topAnchor, paddingTop: 400,
                                    left: webView.leftAnchor, paddingLeft: 100,
                                    bottom: webView.bottomAnchor, paddingBottom: 400,
                                    right: webView.rightAnchor, paddingRight: 100,
                                    width: 0, height: 0, enableInsets: true)
    
    }
    
    private func loadWebPage() {
                
        guard let url = URL(string: articleLink ?? "https://www.google.com/?client=safari") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Starts animation when website is loading.
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }

}

extension NewsDetailedVC: WKNavigationDelegate {
    
    // When it finishes loading, the animation is stopepd.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    // When it fails loading, the animation is stopepd.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    // When it starts loading again, the animation is started.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    #warning("Remove this test method")
//    private func testWeb() {
//        let url = URL(string: "https://www.google.com/?client=safari")
//        let request = URLRequest(url: url!)
//        webView.load(request)
//        webView.navigationDelegate = self
//        // Starts animation when website is loading.
//        activityIndicator.startAnimating()
//        activityIndicator.hidesWhenStopped = true
//    }
}
