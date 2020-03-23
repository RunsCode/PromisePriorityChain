//
//  PriorityElementProtocol.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import Foundation

protocol PriorityElementProtocol : class {

    var id: String? { get set }
    var next: PriorityElementProtocol? { get set }

    func execute(with data: Any?)
    func execute(next data: Any?)
    func `break`(with error: Error?)

    func invalidate()
}

extension PriorityElementProtocol {

    @discardableResult
    public func then(_ ele: PriorityElementProtocol) -> PriorityElementProtocol {
        next = ele
        return ele
    }
}


typealias IPriorityElement = PriorityElementProtocol

class PriorityElement<Input, Output> : IPriorityElement  {

    var id: String?
    
    var next: PriorityElementProtocol?

    var promise: PriorityPromise<Input, Output>?

    var executeClosure: (PriorityPromise<Input, Output>) -> Void?

    var subscribeClosure: ((Output?)->())?

    var catchClosure: ((Error?) -> Void)?

    var disposeClosure: (() -> Void)?


#if DEBUG
    deinit {
        Println("PriorityElement \(#function) id : \(id ?? "PriorityElement-id")")
    }
#endif

    init(id: String? = "", _ closure: @escaping (PriorityPromise<Input, Output>) -> Void ) {
        self.id = id
        self.executeClosure = closure
    }

    public func invalidate() {
        promise?.invalidate()
        promise = nil
    }
}

extension PriorityElement {

    @discardableResult
    public func subscribe(_ closure: @escaping (Output?) -> Void) -> Self {
        subscribeClosure = closure
        return self
    }

    @discardableResult
    public func `catch`(_ closure: @escaping (Error?) -> Void) -> Self {
        catchClosure = closure
        return self
    }

    @discardableResult
    public func dispose(_ closure: @escaping () -> Void) -> Self {
        disposeClosure = closure
        return self
    }

    func execute(with data: Any?) {
        if !(promise != nil) {
            promise = PriorityPromise<Input, Output>(input: data , ele: self)
        } else {
            promise?.input = data as? Input
        }
        executeClosure(promise!)
    }

    func execute(next data: Any?) {
        handleCompleted(with: data as Any)
        //
        next?.execute(with: data)
    }

    func `break`(with error: Error?) {
        invalidate()
        //
        catchClosure?(error)
        disposeClosure?()
    }

    private func handleCompleted(with value: Any) {
        invalidate()
        //
        subscribeClosure?(value as? Output)
        disposeClosure?()
    }
}
