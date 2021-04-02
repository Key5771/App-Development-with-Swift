//
//  FirstTableViewCell.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import WebKit

class FirstTableViewCell: UITableViewCell {
    @IBOutlet weak var webView: WKWebView!
    
    var tableView: UITableView!
    var height: CGFloat = 100.0
    var heightConstraint: NSLayoutConstraint!
    let dataInfoController = DataInfoController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let defaultURL: String = "http://ec2-18-191-254-2.us-east-2.compute.amazonaws.com"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadWebView(urlString: String) {
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = true
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func updateCellHeight() {
        height = webView.scrollView.contentSize.height
        
        heightConstraint = webView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true
        
        tableView.reloadData()
    }
}

extension FirstTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebViewSize: \(webView.scrollView.contentSize.height)")
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCellHeight), userInfo: nil, repeats: false)
    }
    
    
    // MARK: - 사용자가 웹뷰 내 링크를 눌렀을 때 해당 URL의 컨텐츠 높이만큼 높이를 업데이트
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer {
            decisionHandler(.allow)
        }
        
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else { return }
            
            dataInfoController.fetchData(url: url) { [weak self] (data) in
                guard let data = data,
                      let id = data.id,
                      let type = data.type,
                      let url = data.url else { return }
                
                self?.appDelegate.galleryData.append(DataModel(defaultURL: self?.defaultURL, id: id, type: type, url: url))
            }
            
            DispatchQueue.main.async {
                webView.go(to: webView.backForwardList.item(at: 0)!)
            }
        }
    }
}
