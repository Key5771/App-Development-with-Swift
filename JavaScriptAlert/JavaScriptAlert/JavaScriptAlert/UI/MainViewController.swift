//
//  MainViewController.swift
//  JavaScriptAlert
//
//  Created by 김기현 on 2021/03/24.
//

import UIKit
import WebKit

class MainViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var contentController: WKUserContentController?
    
    let defaultUrl = "http://ec2-18-191-254-2.us-east-2.compute.amazonaws.com"
    private let defaultPath = "/examples/jsp/test.jsp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentController = webView.configuration.userContentController
        contentController?.add(self, name: "iOSHandler")
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        loadWebView(urlStr: defaultUrl + defaultPath)
    }
    
    private func loadWebView(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.addValue("myapp", forHTTPHeaderField: "x-app-key")
        webView.load(request)
    }
}
