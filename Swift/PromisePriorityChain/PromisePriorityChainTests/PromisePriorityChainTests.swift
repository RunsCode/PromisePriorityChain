//
//  PromisePriorityChainTests.swift
//  PromisePriorityChainTests
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import XCTest
@testable import PromisePriorityChain

class PromisePriorityChainTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        func heart() -> PriorityElement<String, String> {
            return PriorityElement {

                Println("heart input : \($0.input ?? "-1")")
                //
                $0.output = "I am Heart"
//                $0.condition(self.count > 5, delay: 2)

            }.subscribe { i in

                Println("heart subscribe : \(i ?? "-1")")

            }.catch { err in

                Println("heart catch : \(String(describing: err))")

            }.dispose { Println("heart dispose") }.identifier("heart")
        }

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
