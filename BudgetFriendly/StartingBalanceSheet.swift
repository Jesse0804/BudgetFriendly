//
//  StartingBalanceSheet.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/29/25.
//

import SwiftUI

struct StartingBalanceSheet: View {
    @ObservedObject var payPeriodManager: PayPeriodManager
    @Binding var isPresented: Bool
    @State private var tempStartingBalance: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Starting Balance")
                    .font(.headline)
                
                TextField("Amount", text: $tempStartingBalance)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                
                Button("Save") {
                    guard let startingAmount = Double(tempStartingBalance) else { return }
                    
                    if payPeriodManager.currentPayPeriod == nil {
                            let newPeriod = PayPeriod(
                                startDate: Date(),
                                endDate: nil,
                                startingBalance: startingAmount,
                                transactions: []
                            )
                            payPeriodManager.currentPayPeriod = newPeriod
                        } else {
                            var period = payPeriodManager.currentPayPeriod!
                            period.startingBalance = startingAmount
                            payPeriodManager.currentPayPeriod = period
                        }
                        isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Starting Balance")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
