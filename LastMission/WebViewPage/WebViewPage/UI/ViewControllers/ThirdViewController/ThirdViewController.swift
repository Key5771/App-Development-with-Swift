//
//  ThirdViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import WebKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var items: [String] = []
    private let defaultURL: String = "https://m.etoos.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tableView.frame.height / 2))
        
        let webView = WKWebView(frame: header.bounds)
        guard let url = URL(string: defaultURL) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        header.addSubview(webView)
        
        tableView.tableHeaderView = header
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

extension ThirdViewController: UITableViewDelegate {
    
}

extension ThirdViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath) as? ThirdTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}
