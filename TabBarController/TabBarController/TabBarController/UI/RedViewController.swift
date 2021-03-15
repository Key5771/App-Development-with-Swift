//
//  ViewController.swift
//  TabBarController
//
//  Created by 김기현 on 2021/03/15.
//

import UIKit

class RedViewController: UIViewController {
    @IBOutlet weak var redBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redBarItem.badgeValue = "!"
    }
    
    
    
}

