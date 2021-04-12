import UIKit
import RxSwift
import RxCocoa

// MARK: - Buffer

class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
    static func make() -> TimelineView<E> {
        let view = TimelineView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        view.setup()
        return view
    }
    
    public func on(_ event: Event<E>) {
        switch event {
        case .next(let value):
            add(.next(String(describing: value)))
        case .completed:
            add(.completed())
        case .error(_):
            add(.error())
        }
    }
}

let elementsPerSecond = 1
let maxElements = 5
let replayedElemets = 1
let replayDelay: TimeInterval = 3

let sourceObservable = Observable<Int>.create { observer in
    var value = 1
    let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
        if value <= maxElements {
            observer.onNext(value)
            value += 1
        }
    }

    return Disposables.create {
        timer.suspend()
    }
}
.replay(replayedElemets)

let sourceTimeline = TimelineView<Int>.make()
let replayedTimeline = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("replay"),
    UILabel.make("Emit \(elementsPerSecond) per second:"),
    sourceTimeline,
    UILabel.make("Replay \(replayedElemets) after \(replayDelay) sec:"),
    replayedTimeline
])

_ = sourceObservable.subscribe(sourceTimeline)

DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
    _ = sourceObservable.subscribe(replayedTimeline)
}

_ = sourceObservable.connect()

let hostView = setupHostView()
hostView.addSubview(stack)
hostView
