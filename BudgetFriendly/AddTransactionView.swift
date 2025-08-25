//
//  AddTransactionView.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/24/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var isExpense: Bool = true
    
    // Callback to send the new transaction back
    var onSave: (Transaction) -> Void
    
    var body: some View {
        NavigationView {
            // Form to add a new transaction to the list
            Form {
                Section(header: Text("Details")) {
                    TextField("Description", text: $description)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textInputAutocapitalization(.never)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Type", selection: $isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amountValue = Double(amount) {
                            // If expense, make it negative
                            let finalAmount = isExpense ? -amountValue : amountValue
                            
                            let newTransaction = Transaction(
                                description: description,
                                amount: finalAmount,
                                date: date
                            )
                            onSave(newTransaction)
                            dismiss()
                        }
                    }
                    .disabled(description.isEmpty || amount.isEmpty)
                }
            }
        }
    }
}
