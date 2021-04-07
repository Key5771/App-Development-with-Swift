//
//  EOCategory.swift
//  OurPlanet
//
//  Created by 김기현 on 2021/04/07.
//

import Foundation

struct EOCategory: Equatable {
    let id: Int
    let name: String
    let description: String
    let endpoint: String
    var events = [EOEvent]()
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String,
              let description = json["description"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.description = description
        self.endpoint = "\(EONET.categoriesEndpoint)/\(id)"
    }
    
    
    // MARK: - Equatable
    static func ==(lhs: EOCategory, rhs: EOCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
