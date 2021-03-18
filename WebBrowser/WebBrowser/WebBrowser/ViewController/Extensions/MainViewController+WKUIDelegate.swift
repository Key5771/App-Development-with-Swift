//
//  MainViewController+WKUIDelegate.swift
//  WebBrowser
//
//  Created by 김기현 on 2021/03/18.
//

import UIKit
import WebKit

extension MainViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        
        alertController.addAction(okButton)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive) { _ in
            completionHandler(false)
        }
        let okButton = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
