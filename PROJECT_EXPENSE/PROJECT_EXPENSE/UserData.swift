//
//  UserData.swift
//  PROJECT_EXPENSE
//
//  Created by ARUN KUMAR YADAV on 30/04/25.
//

import Foundation

// Define a struct for transactions without date, and with amount as Int
struct Transaction {
    var description: String
    var amount: Int  // Amount is now an Int
}

class UserData {
    
    // The shared instance that can be accessed globally
    static let shared = UserData()
    var shouldResetData = false

    // Properties to store user data and transactions
    var userName: String?
    var userPass: String?
    var transactions: [Transaction] = []  // Store transactions as objects
    var income: Int = 0  // Store income as Int
    
    // Private initializer to prevent creating new instances of UserData
    private init() {}
    
    // Method to add a new transaction with an Int amount
    func addTransaction(description: String, amount: Int) {
        let transaction = Transaction(description: description, amount: amount)
        transactions.append(transaction)
    }
}

