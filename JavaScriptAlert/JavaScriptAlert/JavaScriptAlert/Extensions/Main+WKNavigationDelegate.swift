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
    /*
        WKWebView Load가 끝났을 때
    */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            webView.evaluateJavaScript("showMessageOnLoad()") { (result, error) in
                print("end")
            }
        }
    }
    
    /*
        WKWebView 내부의 버튼이 클릭된 경우
    */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer {
            decisionHandler(.allow)
        }
        
        guard navigationAction.navigationType == .linkActivated,
              let url = navigationAction.request.url,
              let scheme = url.scheme else {
            return
        }
        
        print("url: \(url)")
        print("scheme: \(scheme)")
        
        if scheme == "myapp"{
            if let data = url.params {
                let alertController = UIAlertController(title: data["message"], message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension URL {
    var params: [String: String]? {
        if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
           let queryItem = urlComponents.queryItems {
            var params: [String: String] = [:]
            queryItem.forEach {
                params[$0.name] = $0.value
            }
            
            return params
        }
        
        return nil
    }
}
