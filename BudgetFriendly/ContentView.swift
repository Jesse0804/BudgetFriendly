//
//  ContentView.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var payPeriodManager = PayPeriodManager()
    @State private var showingAddTransaction = false
    @State private var showingStartingBalanceSheet = false
    
    // MARK: - Computed Properties
    
    private var netTransactions: Double {
        payPeriodManager.currentPayPeriod?.transactions.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    private var remainingBalance: Double {
        if let payPeriod = payPeriodManager.currentPayPeriod,
           let start = payPeriod.startingBalance {
            return start + netTransactions
        } else {
            return 0.0
        }
    }
    
    private var transactions: [Transaction] {
        payPeriodManager.currentPayPeriod?.transactions ?? []
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    
                    // Starting Balance Section
                    if let startingBalance = payPeriodManager.currentPayPeriod?.startingBalance {
                        HStack {
                            Text("Starting Balance:")
                                .font(.headline)
                            Text("$\(startingBalance, specifier: "%.2f")")
                                .font(.title3)
                                .bold()
                        }
                        .padding()
                    } else {
                        Button("Set Starting Balance") {
                            showingStartingBalanceSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    
                    // Transaction List
                    if transactions.isEmpty {
                        Spacer()
                        Text("No transactions yet")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        List(transactions) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.description.isEmpty ? transaction.category.rawValue : transaction.description)
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
                    }
                    
                    // Remaining Balance at bottom
                    VStack {
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
                    // Start New Pay Period button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("New Pay Period") {
                            payPeriodManager.startNewPayPeriod()
                        }
                    }
                    
                    // Add Transaction button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddTransaction = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                }
                .sheet(isPresented: $showingAddTransaction) {
                    AddTransactionView { newTransaction in
                        payPeriodManager.addTransaction(newTransaction)
                    }
                }
                // Starting Balance Sheet
                .sheet(isPresented: $showingStartingBalanceSheet) {
                    StartingBalanceSheet(
                        payPeriodManager: payPeriodManager,
                        isPresented: $showingStartingBalanceSheet
                    )
                }
            }
            .tabItem {
                Label("Transactions", systemImage: "list.bullet")
            }
            
            // Analytics Page
            AnalyticsView(transactions: transactions)
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
