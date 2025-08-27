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
    @State private var selectedCategory: Category = .other
    
    // Callback to send the new transaction back
    var onSave: (Transaction) -> Void
    
    var body: some View {
        NavigationView {
            // Form to add a new transaction to the list
            Form {
                Section(header: Text("Details")) {
                    // Category picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    // Optional description
                    TextField("Description", text: $description)
                    
                    // Amount
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textInputAutocapitalization(.never)
                    
                    // Date
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    // Expense/Income toggle
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
                                date: date,
                                category: selectedCategory
                            )
                            onSave(newTransaction)
                            dismiss()
                        }
                    }
                    .disabled(amount.isEmpty)
                }
            }
        }
    }
}
