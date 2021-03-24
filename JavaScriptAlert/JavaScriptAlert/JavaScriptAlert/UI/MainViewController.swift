//
//  MainViewController.swift
//  JavaScriptAlert
//
//  Created by 김기현 on 2021/03/24.
//

import UIKit
import WebKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainWebView: WKWebView!
    
    private let defaultUrl = "https://github.com/dive-etoos/pub/blob/main/test.html"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView(urlStr: defaultUrl)
    }
    
    func loadWebView(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        mainWebView.load(request)
    }
}
