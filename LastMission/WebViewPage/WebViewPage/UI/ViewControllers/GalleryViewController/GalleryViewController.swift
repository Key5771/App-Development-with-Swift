//
//  GalleryViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var items: [DataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        items = appDelegate.galleryData
        
        idLabel.text = items[0].id
        typeLabel.text = items[0].type
        urlLabel.text = items[0].url
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("items: \(items)")
    }
}
