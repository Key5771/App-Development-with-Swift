import UIKit
import RxSwift
import RxCocoa

example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes
        .ignoreElements()
        .subscribe { _ in
            print("You're out!")
        }
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    
    strikes.onCompleted()
}

example(of: "elementAt") {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes
        .element(at: 2)
        .subscribe { (_) in
            print("You're out!")
        }.disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .filter { $0 % 2 == 0 }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skip") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 2, 3, 4, 4)
        .skip(while: { $0 % 2 == 0})
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject
        .skip(until: trigger)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    trigger.onNext("X")
    
    subject.onNext("C")
}

example(of: "take") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .take(3)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "takeWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 2, 4, 4, 6, 6)
        .enumerated()
        .take(while: { (index, integer) -> Bool in
            integer % 2 == 0 && index < 3
        })
        .map { $0.element }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "takeUntil") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject
        .take(until: trigger)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("1")
    subject.onNext("2")
    
    trigger.onNext("X")
    subject.onNext("3")
}

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "A", "B", "B", "A")
        .distinctUntilChanged()
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "distinctUntilChanged(_:)") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
        .distinctUntilChanged { (a, b) -> Bool in
            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                  let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
            
            var containsMatch = false
            
            for aWord in aWords where bWords.contains(aWord) {
                containsMatch = true
                break
            }
            
            return containsMatch
        }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}


example(of: "toArray") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C")
        .toArray()
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "map") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<Int>.of(123, 4, 56)
        .map {
            formatter.string(from: NSNumber(value: $0)) ?? ""
        }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "enumerated and map") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { index, integer in
            index > 2 ? integer * 2 : integer
        }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}
