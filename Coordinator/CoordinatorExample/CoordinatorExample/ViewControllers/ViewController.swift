//
//  ViewController.swift
//  CoordinatorExample
//
//  Created by 김기현 on 2021/04/20.
//

import UIKit

class ViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        self.coordinator?.buySubscription()
    }
    
    @IBAction func createAccount(_ sender: Any) {
        self.coordinator?.createAccount()
    }
}
