//
//  AnalyticsView.swift
//  BudgetFriendly
//
//  Created by Jesse Erwin on 8/26/25.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    var transactions: [Transaction]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Pie Chart
                CategoryPieChart(transactions: transactions)
                    .frame(height: 250)
                
                // Bar Chart
                CategoryBarChart(transactions: transactions)
                    .frame(height: 250)
                // Line Chart
                SpendingLineChart(transactions: transactions)
                    .frame(height: 250)
            }
            .padding()
        }
        .navigationTitle("Analytics")
    }
}

struct CategoryPieChart: View {
    var transactions: [Transaction]
    
    var body: some View {
        Chart {
            ForEach(Category.allCases) { category in
                let total = transactions
                    .filter { $0.category == category }
                    .map { $0.amount }
                    .reduce(0, +)
                
                if total != 0 {
                    SectorMark(
                        angle: .value("Total", abs(total)),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(by: .value("Category", category.rawValue))
                }
            }
        }
        .chartLegend(.visible)
    }
}

struct CategoryBarChart: View {
    var transactions: [Transaction]
    
    var body: some View {
        Chart {
            ForEach(Category.allCases) { category in
                let total = transactions
                    .filter { $0.category == category }
                    .map { $0.amount }
                    .reduce(0, +)
                
                if total != 0 {
                    BarMark(
                        x: .value("Category", category.rawValue),
                        y: .value("Total", abs(total))
                    )
                    .foregroundStyle(by: .value("Category", category.rawValue))
                }
            }
        }
    }
}

struct SpendingLineChart: View {
    var transactions: [Transaction]
    
    var body: some View {
        Chart {
            ForEach(transactions) { transaction in
                LineMark(
                    x: .value("Date", transaction.date),
                    y: .value("Amount", transaction.amount)
                )
            }
        }
    }
}
