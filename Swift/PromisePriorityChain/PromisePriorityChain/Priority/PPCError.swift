//
//  PPCError.swift
//  PromisePriorityChain
//
//  Created by WangYajun on 2020/3/21.
//  Copyright © 2020 Runs. All rights reserved.
//

import Foundation

var dateFormatter: DateFormatter = {
    let fromatter = DateFormatter()
    fromatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
    return fromatter
}()

func Println(_ string: String?) {
    let time = dateFormatter.string(from: Date())
    print("\(time)  \(string ?? "")")
}

struct PromisePrioriyError : Error {

    enum PriorityErrorEnum : Int {
        case validated = 100000
        case loopValidated = 110000
    }


    let kind: PriorityErrorEnum
    let desc: String
}
