/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxSwift-OSX** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 ## Table of Contents:
 1. [Introduction](Introduction)
 1. [Creating and Subscribing to Observables](Creating_and_Subscribing_to_Observables)
 1. [Working with Subjects](Working_with_Subjects)
 1. [Combining Operators](Combining_Operators)
 1. [Transforming Operators](Transforming_Operators)
 1. [Filtering and Conditional Operators](Filtering_and_Conditional_Operators)
 1. [Mathematical and Aggregate Operators](Mathematical_and_Aggregate_Operators)
 1. [Connectable Operators](Connectable_Operators)
 1. [Error Handling Operators](Error_Handling_Operators)
 1. [Debugging Operators](Debugging_Operators)
 */

//: [Next](@next)

import Foundation
import PlaygroundSupport
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(
    label: "Test",
    attributes: .concurrent // commenting this to use a serial queue remove the issue
)

let scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(queue: queue)

func makeSequence(label: String, period: RxTimeInterval) -> Observable<Int> {
    return Observable<Int>
        .interval(period, scheduler: scheduler)

        // note in this simplifed snippet, share is useless
        .shareReplay(1) // commenting this remove the issue,
}

let _ = makeSequence(label: "main", period: 1.0)
    .flatMapLatest { (index: Int) -> Observable<(Int, Int)> in
        return makeSequence(label: "nested", period: 0.2).map { (index, $0) }
    }
    .take(10)
    .mapWithIndex { ($1, $0.0, $0.1) }
    .subscribe(
        onNext: { print("\($0.0) emit (main: v\($0.1), nested: v\($0.2))") },
        onCompleted: { print("completed") }
)