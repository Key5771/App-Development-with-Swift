//
//  RestaurantViewController.swift
//  test
//
//  Created by 김기현 on 2021/07/01.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel: RestaurantListViewModel!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = RestaurantListViewModel()
        tableView.tableFooterView = UIView()
        
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        viewModel.fetchRestaurantViewModels()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, viewModel, cell in
                cell.textLabel?.text = viewModel.displayText
            }
            .disposed(by: disposeBag)
        
    }
}
