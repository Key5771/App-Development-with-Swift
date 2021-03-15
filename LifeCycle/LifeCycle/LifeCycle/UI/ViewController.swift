//
//  ViewController.swift
//  LifeCycle
//
//  Created by 김기현 on 2021/03/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewController - viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController - viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController - viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ViewController - viewDidDisappear")
    }
    
    deinit {
        print("ViewController - deinit")
    }

}

