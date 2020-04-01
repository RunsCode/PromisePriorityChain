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

    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}

extension PriorityPromiseProtocol {

    public func `break`(_ err: Error?) {
        self.element.break(with: err)
    }

    public func next(_ o: Output) {
        self.element.execute(next: o)
    }

    public func validated(_ isValid: Bool) {
        if isValid {
            self.element.execute(next: self.output)
            return
        }

        let err = PriorityError(kind: .validated, desc: "validated failure")
        self.element.break(with: err)
    }

    public func loop(validated isValid: Bool, t interval: TimeInterval) {
        if isValid {
            self.element.execute(next: self.output)
            return
        }

        if 0 > interval {
            let err = PriorityError(kind: .loopValidated, desc: "loop validated failure")
            self.element.break(with: err)
            return
        }

        self.delay(interval) { _ in
            self.element.execute(with: self.input)
        }
    }

    public func condition(_ isOk: Bool, delay interval: TimeInterval) {
        guard isOk else {
            self.element.execute(next: self.output)
            return
        }

        self.delay(interval) {  _ in
            self.element.execute(next: self.output)
        }
    }
}

class PriorityPromise<Input, Output> : PriorityPromiseProtocol {

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
    }

}
