//
//  DashboardViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 08/02/22.
//

import Foundation

class DashboardViewModel {
    
    /// Variable used
    private var transactionData: [TransactionData] = []
    private var userTransactions: [UserTransaction] = []
    
    /// Get Balance Api
    func getBalance(completion: @escaping (BalanceResponseModel?) -> Void) {
        APIManager().getBalance { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let balanceData = try JSONDecoder().decode(BalanceResponseModel.self,
                                                             from: data)
                    if balanceData.status == "success" {
                        completion(balanceData)
                    } else {
                        completion(balanceData)
                    }
                } catch _ {
                    completion(nil)
                }
            }
            
        }
        
    }
    
    /// Get Transaction Api
    func getTransaction(completion: @escaping ([UserTransaction]) -> Void) {
        APIManager().getTransaction { [weak self] data, response, error in
            if error == nil {
                guard let self = self else { return }
                guard let data = data else { return }
                do {
                    let transactionData = try JSONDecoder().decode(TransactionResponseModel.self,
                                                             from: data)
                    if transactionData.status == "success" {
                        let transactionArray = self.filterTransactionByDate(transactionArray: transactionData.data)
                        completion(transactionArray)
                    } else {
                        debugPrint(Constants.dateErrorMeesage)
                    }
                } catch _ {
                    debugPrint(Constants.dateErrorMeesage)
                }
            }
            
        }
        
    }
    
    private func filterTransactionByDate(transactionArray: [TransactionData]?) -> [UserTransaction] {
        userTransactions.removeAll()
        transactionData.removeAll()
        if let transactions = transactionArray, transactions.count > 0 {
            _ = transactions.map { trans in
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = Constants.dateFormat1
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = Constants.dateFormat2
                
                if let date = dateFormatterGet.date(from: trans.transactionDate) {
                    let transactiondate = dateFormatterPrint.string(from: date)
                    let transaction = TransactionData(transactionID: trans.transactionID,
                                                  amount: trans.amount,
                                                  transactionDate: transactiondate,
                                                      transactionType: trans.transactionType, description: trans.description,
                                                  receipient: trans.receipient,
                                                  sender: trans.sender)
                    transactionData.append(transaction)
                } else {
                    debugPrint(Constants.dateErrorMeesage)
                }
            }
            if transactionData.count > 0 {
                let groupBydate = Dictionary(grouping: transactionData) { (transaction) -> String in
                    return transaction.transactionDate
                }
                _ = groupBydate.map({ data in
                    userTransactions.append(UserTransaction(title: data.key,
                                                            data: data.value))
                })
                return userTransactions
            }
        }
        return []
    }
}

// MARK: - BalanceModel
struct BalanceResponseModel: Decodable {
    let status: String
    let accountNo: String?
    let balance: Double?
    let error: BalanceError?
    
    enum CodingKeys: String, CodingKey {
        case status, accountNo, balance, error
    }
}

// MARK: - BalanceError
struct BalanceError: Decodable {
    let name, message, expiredAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, message, expiredAt
    }
}


// MARK: - Transaction
struct TransactionResponseModel: Decodable {
    let status: String
    let data: [TransactionData]?
    let error: TransactionError?
    
    enum CodingKeys: String, CodingKey {
        case status, data, error
    }
}

// MARK: - TransactionError
struct TransactionError: Decodable {
    let name: String
    let message: String
    let expireTime: String
    
    enum CodingKeys: String, CodingKey {
        case name, message
        case expireTime = "expiredAt"
    }
}

// MARK: - Transaction
struct TransactionData: Decodable {
    let transactionID: String
    let amount: Int
    let transactionDate, transactionType: String
    let description : String?
    let receipient: Receipient?
    let sender: Receipient?
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case amount, transactionDate, description, transactionType, receipient, sender
    }
}

// MARK: - Receipient
struct Receipient: Decodable {
    let accountNo, accountHolder: String
}

struct UserTransaction {
    let title: String
    let data: [TransactionData]
}
