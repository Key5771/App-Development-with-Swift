//
//  ContentViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/04/02.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var items: [DataModel] = []
    var imageArray: [String] = []
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageView()
    }
    
    override func viewWillLayoutSubviews() {
        loadImageView()
    }
    
    func loadImageView() {
        DispatchQueue.global().async {
            guard let index = self.currentIndex,
                  let url = URL(string: self.imageArray[index]) else { return }
            
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
