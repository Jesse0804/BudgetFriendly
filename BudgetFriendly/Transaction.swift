//
//  Transaction.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/23/25.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case groceries = "Groceries"
    case food = "Food"
    case gas = "Gas"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case utilities = "Utilities"
    case bills = "Bills"
    case savings = "Savings"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
    let category: Category
}
