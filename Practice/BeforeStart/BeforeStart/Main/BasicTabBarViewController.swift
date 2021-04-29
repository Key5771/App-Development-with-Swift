//
//  BasicViewController.swift
//  BeforeStart
//
//  Created by 김기현 on 2021/04/29.
//

import UIKit

class BasicTabBarViewController: UITabBarController {

    enum BarType: Int {
        case home = 0
        case myclass
        case download
        case mypage
    }
    
    var currentType = BarType.home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .white
        
        replaceImage()
    }
    
    func replaceImage() {
        self.tabBar.items?[0].image = selectedIndex == 0 ? UIImage(named: "home") : UIImage(named: "download")
        self.tabBar.items?[1].image = selectedIndex == 1 ? UIImage(named: "play") : UIImage(named: "mypage")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        replaceImage()
    }
}
