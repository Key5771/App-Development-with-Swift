//
//  MainViewController.swift
//  TabBarController
//
//  Created by 김기현 on 2021/05/12.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "test", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController else {
            fatalError("vc is nil")
        }
        
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
