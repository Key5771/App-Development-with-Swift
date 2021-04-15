//
//  ForthViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import WebKit

class ForthViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    private var items: [String] = []
    private let defaultURL: String = "http://ec2-18-191-254-2.us-east-2.compute.amazonaws.com/test/ks/m4.jsp"
    
    var loaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        textField.delegate = self
        
        registerForKeyboardNotification()
    }
    
    @IBAction func sendClick(_ sender: Any) {
        if let text = textField.text {
            items.append(text)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.textField.text = ""
            }
            
            self.view.endEditing(true)
        }
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        self.view.frame.origin.y = -keyboardSize.height + stackView.frame.height / 2
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension ForthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ForthViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForthCell", for: indexPath) as? ForthTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            cell.textLabel?.text = ""
            if !loaded {
                cell.loadWebView(urlString: defaultURL)
                cell.tableView = tableView
            }
            
            loaded = true
        } else {
            tableView.separatorStyle = .singleLine
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = items[indexPath.row]
        }
        
        return cell
    }
}

extension ForthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField,
           let text = textField.text {
            items.append(text)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.textField.text = ""
            }
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        DispatchQueue.main.async {
            let endIndex = IndexPath(row: self.items.count - 1, section: 1)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
        }
    }
}
