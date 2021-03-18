//
//  ViewController.swift
//  WebBrowser
//
//  Created by 김기현 on 2021/03/18.
//

import UIKit
import WebKit

class MainViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    // MARK: Variable
    private let defaultUrl = "https://www.google.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.navigationDelegate = self
        
        loadWebView(urlStr: defaultUrl)
        toolBarButtonSetup()
    }
    
    private func loadWebView(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        wkWebView.load(request)
        urlTextField.text = urlStr
    }
    
    private func toolBarButtonSetup() {
        backButton.isEnabled = wkWebView.canGoBack ? true : false
        forwardButton.isEnabled = wkWebView.canGoForward ? true : false
        homeButton.isEnabled = true
    }
    
    // MARK: - IBAction
    
    @IBAction func backButtonClick(_ sender: Any) {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    
    @IBAction func forwardButtonClick(_ sender: Any) {
        if wkWebView.canGoForward {
            wkWebView.goForward()
        }
    }
    
    @IBAction func homeButtonClick(_ sender: Any) {
        loadWebView(urlStr: defaultUrl)
    }
    
}

// MARK: - Extension WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        urlTextField.text = webView.url?.absoluteString
        toolBarButtonSetup()
    }
}

// MARK: - Extension UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
}
