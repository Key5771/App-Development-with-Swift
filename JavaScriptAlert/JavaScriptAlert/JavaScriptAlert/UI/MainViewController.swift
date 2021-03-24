//
//  MainViewController.swift
//  JavaScriptAlert
//
//  Created by 김기현 on 2021/03/24.
//

import UIKit
import WebKit

class MainViewController: UIViewController {
    var mainWebView: WKWebView!
    
    private let defaultUrl = "https://dive-etoos.github.io/pub/test.html"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "iOSHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        mainWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        
        mainWebView.navigationDelegate = self
        mainWebView.uiDelegate = self
        
        view.addSubview(mainWebView)

        loadWebView(urlStr: defaultUrl)
    }
    
    private func loadWebView(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        mainWebView.load(request)
    }
}
