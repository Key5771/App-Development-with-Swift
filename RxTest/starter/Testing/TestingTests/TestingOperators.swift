/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import RxSwift
import RxTest

class TestingOperators : XCTestCase {
    var scheduler: TestScheduler!               // 각 테스트에서 사용할 TestScheduler의 인스턴스
    var subscription: Disposable!               // 각 테스트에서 구독을 유지
    
    /*
     각 테스트 케이스가 시작되기 전에 호출
     */
    override func setUp() {
        super.setUp()
        
        scheduler = TestScheduler(initialClock: 0)
    }
    
    /*
     각 테스트가 완료될 때 호출
     */
    override func tearDown() {
        scheduler.scheduleAt(1000) {            // 1000개의 가상 시간 단위로 테스트 구독 폐기를 예약
            self.subscription.dispose()
        }
        
        super.tearDown()
    }
    
    /*
     XCTest를 사용하는 모든 테스트와 마찬가지로 메소드 이름은 test로 시작
     */
    func testAmb() {
        let observer = scheduler.createObserver(String.self)        // createObserver(_:) 메소드를 사용하여 observer를 생성
        
        // TestableObservable
        let observableA = scheduler.createHotObservable([
            Recorded.next(100, "a"),
            Recorded.next(200, "b"),
            Recorded.next(300, "c")
        ])
        
        // TestableObservable
        let observableB = scheduler.createHotObservable([
            Recorded.next(90, "1"),
            Recorded.next(200, "2"),
            Recorded.next(300, "3")
        ])
        
        let ambObservable = observableA.amb(observableB)
        self.subscription = ambObservable.subscribe(observer)
        scheduler.start()
        
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        XCTAssertEqual(results, ["1", "2", "3"])
    }
    
    func testFilter() {
        let observer = scheduler.createObserver(Int.self)
        
        let observable = scheduler.createHotObservable([
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 2),
            Recorded.next(500, 1)
        ])
        
        let filterObservable = observable.filter {
            $0 < 3
        }
        
        scheduler.scheduleAt(0) {
            self.subscription = filterObservable.subscribe(observer)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {
            $0.value.element
        }
        
        XCTAssertEqual(results, [1, 2, 2, 1])
    }
}
