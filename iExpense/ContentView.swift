//
//  ContentView.swift
//  iExpense
//
//  Created by Raouf on 20/02/2024.
//

import SwiftUI

struct SecondView: View {
    let name: String
    
    var body: some View {
        Text("Hello, \(name)")
    }
}

struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Button("Show Sheet") {
                showingSheet.toggle()
            }
        }
        .padding()
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "@raoufel")            
        }
    }
}

#Preview {
    ContentView()
}
