//
//  HomePageViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import SideMenu

class HomePageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("First"),
                self.newViewController("Second"),
                self.newViewController("Third"),
                self.newViewController("Forth")]
    }()
    
    private func newViewController(_ name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(name)ViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.title = "LastMission"
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func sideMenuClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenu")
        
        guard let root = vc as? SideMenuViewController else { return }
        root.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
        root.navigationItem.title = "Menu"
        
        let menu = SideMenuNavigationController(rootViewController: root)
        menu.presentationStyle = .menuSlideIn
        menu.leftSide = true
        menu.statusBarEndAlpha = 0.0
        
        self.present(menu, animated: true, completion: nil)
    }
    
    @objc func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }
}
