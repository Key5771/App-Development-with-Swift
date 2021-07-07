//
//  ContentView.swift
//  SwiftUI Test
//
//  Created by 김기현 on 2021/07/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            VStack {
                Text("Hello, World!")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                Text("Hello, SwiftUI!")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                Button("Button") {
                    print("Button")
                }
                .font(.largeTitle)
                .foregroundColor(.blue)
            }
            
            HStack {
                Text("TEST")
                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                
                Text("TEST 2")
                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text("TEST 3")
                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
