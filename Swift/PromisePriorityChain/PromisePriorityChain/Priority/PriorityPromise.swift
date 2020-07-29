//
//  PriorityPromise.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import Foundation

protocol PriorityPromiseProtocol : AnyObject {
    associatedtype Input
    associatedtype Output

    var id: String? { get set }
    var input: Input? { get set }
    var output: Output? { get set }
    var timer: Timer? { get set }

    var element: PriorityElementProtocol { get }

    func invalidate()
}

extension PriorityPromiseProtocol {

    private func delay(_ interval: TimeInterval, block: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: block)
        RunLoop.current.add(timer!, forMode: .common)
    }

    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}

extension PriorityPromiseProtocol {

    public func `break`(_ err: PriorityError?) {
        element.onCatch(err)
    }

    public func next(_ o: Output?) {
        element.onSubscribe(o)
        element.execute(next: o)
    }

    public func validated(_ isValid: Bool) {
        if isValid {
            next(output)
            return
        }

        let err = PriorityError(kind: .validated, desc: "validated failure")
        element.onCatch(err)
    }

    public func loop(validated isValid: Bool, t interval: TimeInterval) {
        if isValid {
            next(output)
            return
        }

        if 0 > interval {
            let err = PriorityError(kind: .loopValidated, desc: "loop validated failure")
            element.onCatch(err)
            return
        }

        self.delay(interval) { _ in
            self.next(self.output)
        }
    }

    public func condition(_ isOk: Bool, delay interval: TimeInterval) {
        guard isOk else {
            next(output)
            return
        }

        self.delay(interval) { _ in
            self.next(self.output)
        }
    }
}

open class PriorityPromise<Input, Output> : PriorityPromiseProtocol {

    var id: String?

    var input: Input?

    var output: Output?

    var timer: Timer?

    var element: PriorityElementProtocol

#if DEBUG
    deinit {
        Println("PriorityPromise \(#function) id : \(id ?? "PriorityPromise-id"), element : \(element.id ?? "unknown")")
    }
#endif

    init(id: String? = "PriorityPromise", input: Any? = nil, ele: PriorityElementProtocol) {
        self.id = id ?? ele.id
        self.input = input as? Input
        self.element = ele
#if DEBUG
        Println("create promise id: \(String(describing: id))")
#endif
    }

    open func identifier(_ identifier: String) -> Self {
        id = identifier
        return self
    }
}
