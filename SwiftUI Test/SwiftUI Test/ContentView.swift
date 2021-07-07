//
//  ContentView.swift
//  SwiftUI Test
//
//  Created by 김기현 on 2021/07/07.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: ContentView(),
                label: {
                    Text("이걸 누르면")
                })
                .navigationBarTitle("TEST")
        }
    }
}

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
                Text("HStack")
                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.pink)
                
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
        .navigationBarTitle("이게 나온다")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
        ContentView()
    }
}
