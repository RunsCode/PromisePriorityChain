//
//  ContentView.swift
//  PromisePriorityChain
//
//  Created by RunsCode on 2020/3/21.
//  Copyright © 2020 RunsCode. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Hello World")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 100)
                .animation(.easeInOut)

            Button(action: {
                _ = PromisePriorityTest()
            }) {
                Text("PromisePriorityTest")
                .foregroundColor(Color.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
