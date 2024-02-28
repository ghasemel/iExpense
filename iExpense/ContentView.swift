//
//  ContentView.swift
//  iExpense
//
//  Created by Raouf on 20/02/2024.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expences {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expences()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(groupedItems, id: \.0) { type, items in
                    Section(type) {
                        ForEach(items, id:\.id) { item in
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .background {
                                        switch item.amount {
                                            case 0..<10:
                                                Color.green
                                            case 10..<99:
                                                Color.orange
                                            case 1000...:
                                                Color.red
                                            default:
                                                Color.blue
                                        }
                                    }
                            }
                        }.onDelete { indices in
                            self.deleteItems(indices, fromCategory: type)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus.circle") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            .listStyle(.grouped)
        }
    }
    
    var groupedItems: [(String, [ExpenseItem])] {
        Dictionary(grouping: expenses.items, by: { $0.type }).sorted { $0.key < $1.key }
    }
    
    private func deleteItems(_ indices: IndexSet, fromCategory category: String) {
        if let categoryIndex = groupedItems.firstIndex(where: { $0.0 == category }) {
            expenses.items.removeAll { item in
                return groupedItems[categoryIndex].1.contains { $0.id == item.id } && indices.contains(groupedItems[categoryIndex].1.firstIndex(where: { $0.id == item.id })!)
            }
        }
    }

}

#Preview {
    ContentView()
}
