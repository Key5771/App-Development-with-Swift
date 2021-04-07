//
//  CategoriesViewController.swift
//  OurPlanet
//
//  Created by 김기현 on 2021/04/07.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let categories = BehaviorRelay<[EOCategory]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoriesTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
