//
//  LocalOnlyQsTask.swift
//  RealmProject
//
//  Created by 김기현 on 2021/04/19.
//

import Foundation
import RealmSwift

class LocalOnlyQsTask: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String?
    @objc dynamic var status: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
