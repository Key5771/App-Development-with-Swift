//
//  Restaurant.swift
//  test
//
//  Created by 김기현 on 2021/07/01.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let cuisine: Cuisine
}

enum Cuisine: String, Decodable {
    case european
    case indian
    case mexican
    case french
    case english
}
