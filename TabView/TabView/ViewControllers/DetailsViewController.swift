//
//  DetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController, WKNavigationDelegate {

    // UI outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Holds the sent artile.
    var receivedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityIndicator()
    }
    
    fileprivate func setUpActivityIndicator() {
        // Setting the Activity Indicator
        activityIndicator.center = view.center
        // Setting the artile URL, to load in a Web view.
        let url = URL(string: receivedArticle!.url)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.navigationDelegate = self
        // Starts animation when website is loading.
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
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
}
