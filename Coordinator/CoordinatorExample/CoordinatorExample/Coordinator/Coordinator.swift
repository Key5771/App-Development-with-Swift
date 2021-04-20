//
//  Coordinator.swift
//  CoordinatorExample
//
//  Created by 김기현 on 2021/04/19.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
