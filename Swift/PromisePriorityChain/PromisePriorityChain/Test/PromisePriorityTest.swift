//
//  PromisePriorityTest.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/22.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import Foundation

class PromisePriorityTest {

    private var count: Int = 0

    init() {

        let head: PriorityElement<String, Int> = self.head()
        head.then(neck())
            .then(lung())
            .then(heart())
            .then(liver())
            .then(over())
        head.execute(with: "head->")
    }

    func delay(_ interval: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            block()
        }
    }

    private func head() -> PriorityElement<String, Int> {
        return PriorityElement(id: "Head") { (_ promise: PriorityPromise<String, Int>) in

            Println("head input : \(promise.input ?? "")")
            self.delay(1) {
                promise.next(1)
            }

        }.subscribe { i in

            Println("head subscribe : \(i ?? -1)")

        }.catch { err in

            Println("head catch : \(String(describing: err))")

        }.dispose {

            Println("head dispose")
        }
    }

    private func neck() -> PriorityElement<Int, String> {
        return PriorityElement {

            Println("neck input : \($0.input ?? -1)")
            $0.output = "I am Neck"
            $0.validated($0.input == 1)

        }.subscribe { i in

            Println("neck subscribe : \(i ?? "-1")")

        }.catch { err in

            Println("neck catch : \(String(describing: err))")

        }.dispose {

            Println("neck dispose")
        }
    }

    private func lung() -> PriorityElement<String, String> {
        return PriorityElement {

            Println("lung input : \($0.input ?? "-1")")
            self.count += 1
            //
            $0.output = "I am Lung"
            $0.loop(validated: self.count >= 5, t: 1)

        }.subscribe { i in

            Println("lung subscribe : \(i ?? "-1")")

        }.catch { err in

            Println("lung catch : \(String(describing: err))")

        }.dispose {

            Println("lung dispose")
        }
    }

    private func heart() -> PriorityElement<String, String> {
        return PriorityElement {

            Println("heart input : \($0.input ?? "-1")")
            //
            $0.output = "I am Heart"
            $0.condition(self.count > 5, delay: 2)

        }.subscribe { i in

            Println("heart subscribe : \(i ?? "-1")")

        }.catch { err in

            Println("heart catch : \(String(describing: err))")

        }.dispose {

            Println("heart dispose")
        }
    }


    private func liver() -> PriorityElement<String, String> {
        return PriorityElement { promise in

            Println("liver input : \(promise.input ?? "-1")")
            //
            self.delay(1) {
                promise.break(nil)
            }

        }.subscribe { i in

            Println("liver subscribe : \(i ?? "-1")")

        }.catch { err in

            Println("liver catch : \(String(describing: err))")

        }.dispose {

            Println("liver dispose")
        }
    }

    private func over() -> PriorityElement<String, String> {
        return PriorityElement {

            Println("over input : \($0.input ?? "-1")")
            $0.next("Finished Release")

        }.subscribe { i in

            Println("over subscribe : \(i ?? "-1")")

        }.catch { err in

            Println("over catch : \(String(describing: err))")

        }.dispose {

            Println("over dispose")
        }
    }

}
