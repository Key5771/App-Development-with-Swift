//
//  DataInfoController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/04/02.
//

import Foundation

class DataInfoController {
    func fetchData(url: URL, completion: @escaping (DataModel?) -> Void) {
        
        DispatchQueue.global().sync {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                
                if let data = data,
                   let dataInfo = try? jsonDecoder.decode(DataModel.self, from: data) {
                    completion(dataInfo)
                } else {
                    print("Error: data in nil || decode fail")
                    completion(nil)
                }
            }
            
            task.resume()
        }
    }
}
