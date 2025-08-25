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
    @State private var showingAddTransaction = false
    @State private var startingBalance: String = ""
    
    // Sum of all transaction amounts
    var netTransactions: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    // Remaining balance = starting - spent
    var remainingBalance: Double {
        if let start = Double(startingBalance) {
            return start + netTransactions
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Starting Balance input
                HStack {
                    Text("Starting Balance: ")
                    TextField("Enter Amount", text: $startingBalance)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)
                }
                .padding()
                
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
                            .foregroundColor(transaction.amount < 0 ? .red : .green)
                    }
                }
                // Remaining balance at bottom
                VStack{
                    Divider()
                    Text("Remaining Balance: $\(remainingBalance, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                        .padding(.top, 5)
                }
                .padding(.bottom)
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView { newTransaction in
                    transactions.append(newTransaction)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
