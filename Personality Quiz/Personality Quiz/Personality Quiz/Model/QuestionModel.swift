//
//  DataModel.swift
//  Personality Quiz
//
//  Created by 김기현 on 2021/03/15.
//

import Foundation

struct Question {
    var text: String
    var type: ResponseType
    var answer: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}
