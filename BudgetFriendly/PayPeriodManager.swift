//
//  PayPeriodManager.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/28/25.
//

import Foundation

class PayPeriodManager: ObservableObject {
    @Published var currentPayPeriod: PayPeriod? {
        didSet {
            Self.save(currentPayPeriod)
        }
    }
    
    init() {
        currentPayPeriod = Self.load()
    }
    
    // MARK: - Transaction Methods
    func addTransaction(_ transaction: Transaction) {
        currentPayPeriod?.transactions.append(transaction)
        save()
    }
    
    // MARK: - Pay Period Methods
    func startNewPayPeriod() {
        let newPayPeriod = PayPeriod(
            startDate: Date(),
            endDate: nil,
            startingBalance: nil,
            transactions: []
        )
        currentPayPeriod = newPayPeriod
        save()
    }
    
    // MARK: - Persistence
    private func save() {
        Self.save(currentPayPeriod)
    }
    
    static private func save(_ payPeriod: PayPeriod?) {
        guard let payPeriod = payPeriod else { return }
        if let data = try? JSONEncoder().encode(payPeriod) {
            UserDefaults.standard.set(data, forKey: "currentPayPeriod")
        }
    }
    
    static private func load() -> PayPeriod? {
        if let data = UserDefaults.standard.data(forKey: "currentPayPeriod"),
           let decoded = try? JSONDecoder().decode(PayPeriod.self, from: data) {
            return decoded
        }
        return nil
    }
}
