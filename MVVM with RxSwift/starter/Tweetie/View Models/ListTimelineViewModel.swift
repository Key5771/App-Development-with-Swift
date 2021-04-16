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

import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

class ListTimelineViewModel {
  private let bag = DisposeBag()
  private let fetcher: TimelineFetcher
  
  let list: ListIdentifier
  let account: Driver<TwitterAccount.AccountStatus>

  // MARK: - Input -> 일반 변수 또는 RxSwift의 Subject와 같은 공용 속성을 포함. ViewController가 입력을 제공할 수 있도록 하는 Relay
  
  var paused: Bool = false {                    // fetcher 클래스에서 paused 값을 설정하는 프록시
    didSet {
      fetcher.paused.accept(paused)
    }
  }

  // MARK: - Output -> ViewModel의 출력을 제공하는 공용 속성을 포함.
  
  private(set) var tweets: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)>!    // Realm에서 로드된 Observable 트윗 객체
  private(set) var loggedIn: Driver<Bool>!                                              // 로그인을 했는지 여부를 나타내는 Boolean value

  // MARK: - Init
  init(account: Driver<TwitterAccount.AccountStatus>,
       list: ListIdentifier,
       apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {

    self.list = list
    self.account = account
    
    // fetch and store tweets
    fetcher = TimelineFetcher(account: account, list: list, apiType: apiType)
    
    fetcher.timeline
      .subscribe(Realm.rx.add(update: .all))      // Realm 데이터베이스에 저장
      .disposed(by: bag)
    
    bindOutput()

  }

  // MARK: - Methods
  private func bindOutput() {
    // Bind tweets
    
    guard let realm = try? Realm() else { return }
    tweets = Observable.changeset(from: realm.objects(Tweet.self))    // 변경 사항을 구독

    // Bind if an account is available
    
    loggedIn = account
      .map { status in
        switch status {
        case .unavailable: return false
        case .authorized: return true
        }
      }
      .asDriver(onErrorJustReturn: false)
  }
}
