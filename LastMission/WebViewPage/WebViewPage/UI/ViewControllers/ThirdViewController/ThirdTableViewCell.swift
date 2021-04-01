//
//  ThirdTableViewCell.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import WebKit

class ThirdTableViewCell: UITableViewCell {
    @IBOutlet weak var webView: WKWebView!
    
    var tableView: UITableView!
    var height: CGFloat = 100.0
    var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadWebView() {
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        guard let defaultURL = URL(string: "https://m.etoos.com") else { return }
        let request = URLRequest(url: defaultURL)
        webView.load(request)
    }
    
    @objc func updateCellHeight() {
        height = webView.scrollView.contentSize.height
        
        heightConstraint = webView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true
        
        tableView.reloadData()
    }
}

extension ThirdTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebViewSize: \(webView.scrollView.contentSize.height)")
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCellHeight), userInfo: nil, repeats: false)
    }
}
