//
//  SecondViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import WebKit

class SecondViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var items: [String] = []
    private let defaultURL: String = "http://ec2-18-191-254-2.us-east-2.compute.amazonaws.com/test/ks/m2.jsp"
    
    var loaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tableView.frame.height / 2))
//
//        let webView = WKWebView(frame: header.bounds)
//        guard let url = URL(string: defaultURL) else { return }
//        let request = URLRequest(url: url)
//        webView.load(request)
//        header.addSubview(webView)
//
//        tableView.tableHeaderView = header
    }

    @IBAction func sendClick(_ sender: Any) {
        if let text = textField.text {
            items.append(text)
            tableView.reloadData()
            textField.text = ""
            
            self.view.endEditing(true)
        }
    }
    
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SecondViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as? SecondTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            if !loaded {
                cell.loadWebView(urlString: defaultURL)
                cell.tableView = tableView
            }
            
            loaded = true
        } else {
            cell.textLabel?.text = items[indexPath.row]
        }
        
        return cell
    }
}
