//
//  ContentView.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    // Tracking transactions
    @State private var transactions: [Transaction] = []
    
    var totalBalance: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Balance Display
                Text("💰 BudgetFriendly")
                    .font(.largeTitle)
                    .bold()
                
                Text("Balance: $\(totalBalance, specifier: "%.2f")")
                    .font(.title)
                    .padding(.bottom, 20)
                
                // Transaction List
                List(transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                                .font(.headline)
                            Text(transaction.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.amount >= 0 ? .green : .red)
                    }
                }
            }
            .padding()
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addDummyTransaction) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
    // Temporary function to add a text transaction
    func addDummyTransaction() {
        let newTransaction = Transaction(
            description: "Test Item",
            amount: Double.random(in: -50...100),
            date: Date()
        )
        transactions.append(newTransaction)
    }
}

#Preview {
    ContentView()
}
