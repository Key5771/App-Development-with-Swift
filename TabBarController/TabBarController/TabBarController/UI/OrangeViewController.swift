//
//  OrangeViewController.swift
//  TabBarController
//
//  Created by 김기현 on 2021/03/15.
//

import UIKit

class OrangeViewController: UIViewController {
    @IBOutlet weak var orangeTabItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orangeTabItem.badgeValue = "O"
    }

}
