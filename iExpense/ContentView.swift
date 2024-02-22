//
//  ContentView.swift
//  iExpense
//
//  Created by Raouf on 20/02/2024.
//

import SwiftUI
import Observation

@Observable
class User {
    var firstName = "Bilbo" {
        didSet {
            print("Firstname changed to: '\(firstName)'")
        }
    }
    
    
    var lastName = "Baggins" {
        didSet {
            print("Lastname changed to '\(lastName)'")
        }
    }
}

struct ContentView: View {
    @State private var user = User()
    
    var body: some View {
        VStack {
            Text("\(user.firstName) \(user.lastName)")
          
            TextField("First Name", text: $user.firstName)
            TextField("Last Name", text: $user.lastName)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
