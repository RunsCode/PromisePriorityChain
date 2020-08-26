//
//  PriorityElementProtocol.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import Foundation

public protocol PublicPriorityChainProtocol : class {

    var next: PublicPriorityChainProtocol? { get set }
    func execute(with data: Any?)

    @discardableResult
    func then(_ ele: PublicPriorityChainProtocol) -> PublicPriorityChainProtocol
}

extension PublicPriorityChainProtocol {

    @discardableResult
    public func then(_ ele: PublicPriorityChainProtocol) -> PublicPriorityChainProtocol {
        next = ele
        return ele
    }
}

protocol PublicPriorityPromiseProtocol :class {
    associatedtype Input
    associatedtype Output

    var promise: PriorityPromise<Input, Output>? { get set }
    func invalidate()
}

extension PublicPriorityPromiseProtocol {
    func invalidate() {
        promise?.invalidate()
        promise = nil
    }
}

protocol PriorityElementProtocol : class {
    
    var id: String? { get set }
    var subscribeClosure: ((Any?)->())? { get set }
    var catchClosure: ((Error?) -> Void)? { get set }
    var disposeClosure: (() -> Void)? { get set }

    func execute()
    func execute(with data: Any?)
    func execute(next data: Any?)

    func onSubscribe(_ data: Any?)
    func onCatch(_ err: PriorityError?)
    func invalidate()
}

extension PriorityElementProtocol {

    public func onSubscribe(_ data: Any?) {
        invalidate()
        //
        subscribeClosure?(data)
        disposeClosure?()
    }

    public func onCatch(_ err: PriorityError?) {
        invalidate()
        //
        catchClosure?(err)
        disposeClosure?()
    }
}

public protocol PublicPriorityElementProtocol : class {
    associatedtype Input
    associatedtype Output

    /// Implementation of subclass for external module customization
    /// - Parameter promise: promise
    func execute(promise: PriorityPromise<Input, Output>)
}


typealias IPriorityElement = PriorityElementProtocol & PublicPriorityChainProtocol & PublicPriorityElementProtocol & PublicPriorityPromiseProtocol

open class PriorityElement<Input, Output> : IPriorityElement  {

    typealias ExecuteClosure = (PriorityPromise<Input, Output>) -> Void

    public var id: String?

    public var next: PublicPriorityChainProtocol?

    var promise: PriorityPromise<Input, Output>?

    var executeClosure: ExecuteClosure?

    var subscribeClosure: ((Any?) -> ())?

    var catchClosure: ((Error?) -> Void)?

    var disposeClosure: (() -> Void)?


#if DEBUG
    deinit {
        Println("PriorityElement \(#function) id : \(id ?? "PriorityElement-id")")
    }
#endif

    init(id: String? = "", _ closure: ExecuteClosure? = nil) {
        self.id = id
        self.executeClosure = closure
    }

    public func identifier(_ identifier: String) -> Self {
        self.id = identifier
        return self
    }

    public final func execute(with data: Any?) {
        if !(promise != nil) {
            promise = PriorityPromise<Input, Output>(input: data , ele: self)
        } else {
            promise?.input = data as? Input
        }
        execute(promise: promise!)
    }

    /// Implementation of subclass for external module customization
    open func execute(promise: PriorityPromise<Input, Output>) {
        // maybe implementation by customized subclass
        executeClosure?(promise)
    }

}

extension PriorityElement {

    @discardableResult
    public final func subscribe(_ closure: @escaping (Any?) -> Void) -> Self {
        subscribeClosure = closure
        return self
    }

    @discardableResult
    public final func `catch`(_ closure: @escaping (Error?) -> Void) -> Self {
        catchClosure = closure
        return self
    }

    @discardableResult
    public final func dispose(_ closure: @escaping () -> Void) -> Self {
        disposeClosure = closure
        return self
    }

    public final func execute(next data: Any?) {
        next?.execute(with: data)
    }

    public final func execute() {
        self.execute(with: nil)
    }

}
