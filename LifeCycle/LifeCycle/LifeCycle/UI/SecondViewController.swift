//
//  SecondViewController.swift
//  LifeCycle
//
//  Created by 김기현 on 2021/03/15.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("SecondViewController - viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SecondViewController - viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("SecondViewController - viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SecondViewController - viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("SecondViewController - viewDidDisappear")
    }
    
    // 할당 해제 체크
    deinit {
        print("SecondViewController - deinit")
    }
}
