import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: !!!!!!!!!!!!!! api_key 있으니까 커밋할 때 ignore 시킬 것 !!!!!!!!!!!!!!!!!
// MARK: www.apple.com으로 변경
let url = URL(string: "https://www.apple.com")!
let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let data = data,
       let string = String(data: data, encoding: .utf8) {
        print(string)
    }
    
    PlaygroundPage.current.finishExecution()
}

task.resume()
