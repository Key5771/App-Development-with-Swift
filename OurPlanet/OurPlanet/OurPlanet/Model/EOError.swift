//
//  EOError.swift
//  OurPlanet
//
//  Created by 김기현 on 2021/04/07.
//

import Foundation

enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
}
