//
//  ViewController.swift
//  Working with the Web
//
//  Created by 김기현 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: www.apple.com으로 변경해서 커밋
    let url = URL(string: "https://www.apple.com")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               let string = String(data: data, encoding: .utf8) {
                print(string)
            }
        }
        
        task.resume()
    }


}

