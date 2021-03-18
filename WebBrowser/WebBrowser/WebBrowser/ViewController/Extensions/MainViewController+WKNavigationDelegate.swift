//
//  MainViewController+WKNavigationDelegate.swift
//  WebBrowser
//
//  Created by 김기현 on 2021/03/18.
//

import UIKit
import WebKit

extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.urlTextField.text = webView.url?.absoluteString
        toolBarButtonSetup()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.urlTextField.text = webView.url?.absoluteString
        
        let alertController = UIAlertController(title: "도메인 에러", message: "주소를 확인해주세요.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okButton)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
