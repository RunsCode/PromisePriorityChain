//
//  ContentView.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    public let priority: PromisePriorityTest = {
        return PromisePriorityTest()
    }()

    fileprivate func priorityTestButton(_ title: String) -> some View {
        return Button(action: {
            self.priority.test()
        }) {
            Text(title)
                .foregroundColor(Color.white)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }

    var body: some View {
        VStack {
            Text("Hello World")
                .font(.title)
                .multilineTextAlignment(.center)
                .animation(.easeInOut)

            Spacer()
            priorityTestButton("PromisePriorityTest")
            Spacer()
            priorityTestButton("PromisePriorityTest0")
            Spacer()

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
