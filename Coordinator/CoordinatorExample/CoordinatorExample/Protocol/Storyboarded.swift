//
//  Storyboarded.swift
//  CoordinatorExample
//
//  Created by 김기현 on 2021/04/19.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // ex) "CoordinatorExample(프로젝트 이름).ViewController"
        let fullName = NSStringFromClass(self)
        
        // .을 기준으로 split해서 ViewController만 추출
        let className = fullName.components(separatedBy: ".")[1]
        
        // Bundle.main에서 Main.storyboard 가져오기
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
