//
//  PriorityCustomElement.swift
//  PromisePriorityChain
//
//  Created by WangYajun on 2020/7/28.
//  Copyright © 2020 Runs. All rights reserved.
//

import UIKit

class PriorityCustomElement: PriorityElement<Int, String> {

#if DEBUG
    deinit {
        Println("PriorityCustomElement \(#function) id : \(id ?? "PriorityCustomElement-id")")
    }
#endif

    override var id: String? {
        set { }
        get {
            return "PriorityCustomElement"
        }
    }


    override func execute(promise: PriorityPromise<Int, String>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Println("PriorityCustomElement execute  ss")
            promise.break(nil)
//            promise.next("HELLO NEW")
        }
    }

 
}

struct AccountModel {
    init(_ json: Any) {

    }
}

extension PriorityCustomElement  {

    func loadUser() -> AccountModel? {
        guard let json = UserDefaults.standard.object(forKey: "user_key_id") else { return nil }
        return AccountModel(json)
    }

}
