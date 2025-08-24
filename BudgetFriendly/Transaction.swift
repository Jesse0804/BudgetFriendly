//
//  Transaction.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/23/25.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
}
