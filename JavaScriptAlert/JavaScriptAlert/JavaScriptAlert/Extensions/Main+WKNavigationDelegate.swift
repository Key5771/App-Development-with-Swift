//
//  Main+WKNavigationDelegate.swift
//  JavaScriptAlert
//
//  Created by 김기현 on 2021/03/24.
//

import Foundation
import UIKit
import WebKit

extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            webView.evaluateJavaScript("showMessageOnLoad()") { (result, error) in
                print("end")
            }
        }
    }
}
