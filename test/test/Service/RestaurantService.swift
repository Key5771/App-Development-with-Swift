//
//  RestaurantService.swift
//  test
//
//  Created by 김기현 on 2021/07/01.
//

import Foundation
import RxSwift

protocol RestaurantServiceProtocol {
    func fetchRestaurants() -> Observable<[Restaurant]>
}

class RestaurantService: RestaurantServiceProtocol {
    func fetchRestaurants() -> Observable<[Restaurant]> {
        return Observable.create { observer -> Disposable in
            guard let path = Bundle.main.path(forResource: "restaurants", ofType: "json") else {
                print("json is nil")
                return Disposables.create { }
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let restaurant = try JSONDecoder().decode([Restaurant].self, from: data)
                observer.onNext(restaurant)
            } catch(let error) {
                observer.onError(error)
            }
            
            return Disposables.create { }
        }
    }
}
