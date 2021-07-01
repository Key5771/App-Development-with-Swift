//
//  RestaurantListViewModel.swift
//  test
//
//  Created by 김기현 on 2021/07/01.
//

import Foundation
import RxSwift

final class RestaurantListViewModel {
    let title = "Restaurants"
    
    private let restaurantService: RestaurantServiceProtocol
    
    init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
        self.restaurantService = restaurantService
    }
    
    func fetchRestaurantViewModels() -> Observable<[RestaurantViewModel]> {
        restaurantService.fetchRestaurants().map { $0.map { RestaurantViewModel(restaurant: $0)}}
    }
}
