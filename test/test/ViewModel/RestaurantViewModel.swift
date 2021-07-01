//
//  RestaurantViewModel.swift
//  test
//
//  Created by 김기현 on 2021/07/01.
//

import Foundation

struct RestaurantViewModel {
    private let restaurant: Restaurant
    
    var displayText: String {
        return restaurant.name + " - " + restaurant.cuisine.rawValue.capitalized
    }
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}
