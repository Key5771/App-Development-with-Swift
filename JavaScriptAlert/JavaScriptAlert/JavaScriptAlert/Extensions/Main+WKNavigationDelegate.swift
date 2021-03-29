//
//  Main+WKNavigationDelegate.swift
//  JavaScriptAlert
//
//  Created by 김기현 on 2021/03/24.
//

import Foundation
import UIKit
import WebKit
import QuickLook

extension MainViewController: WKNavigationDelegate {
    /*
        WKWebView Load가 시작될 때
    */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    /*
        WKWebView Load가 끝났을 때
    */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            webView.evaluateJavaScript("showMessageOnLoad()") { (result, error) in
                print("end")
            }
        }
        
        progressView.isHidden = true
    }
    
    /*
        WKWebView 내부의 버튼이 클릭된 경우
    */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Header
        guard let header = navigationAction.request.allHTTPHeaderFields else {
            print("Header is empty")
            decisionHandler(.allow)
            return
        }
        
        print("header: \(header)")
        
        // Click Event
        guard let url = navigationAction.request.url,
              let scheme = url.scheme else {
            decisionHandler(.allow)
            return
        }
        
        print("url: \(url)")
        print("scheme: \(scheme)")
        
        if navigationAction.navigationType == .linkActivated {
            if scheme == "myapp"{
                if let data = url.params {
                    print("data: \(data)")
                    
                    if let message = data["message"] {              // 3번 - JavaScript 함수 내 메시지 호출
                        showAlert(message: message)
                    } else if let dataUrl = data["url"] {           // 6번 - 외부 브라우저로 실행
                        print("newURL: \(dataUrl)")
                        
                        guard let externalUrl = URL(string: defaultUrl + dataUrl),
                              let host = externalUrl.host,
                              UIApplication.shared.canOpenURL(externalUrl) else { return }
                        
                        UIApplication.shared.open(externalUrl, options: [.universalLinksOnly : host], completionHandler: nil)
                    }
                }
                decisionHandler(.cancel)
            } else if scheme == "http" && url.absoluteString.contains(".zip") {     // 5번 - 파일 다운로드
                let downloadUrl = url
                print("downloadUrl: \(downloadUrl)")
                DispatchQueue.main.async {
                    let fileManager = FileManager.default
                    let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let dataPath = documentsDir
                    
                    let fileName = downloadUrl.lastPathComponent
                    print("FILE NAME: \(fileName)")
                    let destination = dataPath.appendingPathComponent("/" + fileName)
                    
                    print("Destination: \(destination)")
//                    Downloaderr.load(url: downloadUrl, to: destination)
                    
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    let url = NSURL(fileURLWithPath: path)
                    
                    print("PATH: \(path)")
                    
                    if let pathComponent = url.appendingPathComponent(fileName) {
                        let filePath = pathComponent.path
                        if fileManager.fileExists(atPath: filePath) {
                            print("File is Exist")
                        } else {
                            Downloaderr.load(url: downloadUrl, to: destination)
                        }
                        
                        guard let documentUrl = URL(string: "file://" + path) else {
                            print("documentUrl is nil")
                            return
                        }
                        
                        print("DocumentURL: \(documentUrl)")
                    } else {
                        print("File path not Available")
                    }
                    
                    
                    // TODO: 다운로드 후 자동으로 Files 앱이 실행되도록 구현
//                    let activityViewController = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
//                    activityViewController.popoverPresentationController?.sourceView = self.view
//
//                    self.present(activityViewController, animated: true, completion: nil)
                }
                
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    class Downloaderr {
        class func load(url: URL, to localUrl: URL) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.downloadTask(with: request) { (tempUrl, response, error) in
                if let tempUrl = tempUrl, error == nil {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return
                    }
                    
                    print("Success: \(httpResponse.statusCode)")
                    
                    do {
                        try FileManager.default.copyItem(at: tempUrl, to: localUrl)
                    } catch (let writeError) {
                        print("error writing file: \(writeError)")
                    }
                } else {
                    print("FAIL: \(error?.localizedDescription as Any)")
                }
            }
            
            task.resume()
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
