//
//  MainViewController+UITextFieldDelegate.swift
//  WebBrowser
//
//  Created by 김기현 on 2021/03/18.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        self.urlTextField.resignFirstResponder()
        
        var url = "https://"
        guard var text = textField.text else { return false }
        
//        if !text.contains(url) {
//            url += text
//        } else {
//            url = text
//        }
        
        if text.contains("http://") {
            for _ in 0..<7 {
                text.removeFirst()
            }
        }
        
        !text.contains(url) ? (url += text) : (url = text)
        
        DispatchQueue.main.async {
            self.loadWebView(urlStr: url)
        }
        
        return true
    }
}
