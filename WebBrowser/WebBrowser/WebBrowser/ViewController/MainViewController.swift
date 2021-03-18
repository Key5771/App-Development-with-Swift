//
//  ViewController.swift
//  WebBrowser
//
//  Created by 김기현 on 2021/03/18.
//

import UIKit
import WebKit

class MainViewController: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var wkWebView: WKWebView!
    
    private let defaultUrl = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView(urlStr: defaultUrl)
    }
    
    private func loadWebView(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        wkWebView.load(request)
        urlTextField.text = urlStr
    }
}

