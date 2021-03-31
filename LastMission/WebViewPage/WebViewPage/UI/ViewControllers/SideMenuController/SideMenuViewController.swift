//
//  SideMenuViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let item = ["Gallery"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewController = storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideCell", for: indexPath) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = item[indexPath.row]
        
        return cell
    }
    
    
}
