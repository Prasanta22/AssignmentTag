//
//  TransferViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

struct TransferViewModel {
    
    func validateInput(_ payee: String?, amount: String?, completion: (Bool, String?) -> Void) {
        if let payeeName = payee {
            if payeeName.isEmpty {
                completion(false, Constants.payeeEmptyMessage)
            }
        } else {
            completion(false, Constants.payeeEmptyMessage)
        }
        if let amountCount = amount {
            if amountCount.isEmpty {
                completion(false, Constants.amountEmptyMessage)
                return
            }
        } else {
            completion(false, Constants.amountEmptyMessage)
        }
        // Validated successfully.
        completion(true, nil)
    }
    
    /// Fetch Payee List Api
    func payeeList(completion: @escaping (PayeesResponseModel?) -> Void) {
        APIManager().payeeList { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let payeeData = try JSONDecoder().decode(PayeesResponseModel.self,
                                                             from: data)
                    if payeeData.status == "success" {
                        completion(payeeData)
                    } else {
                        completion(payeeData)
                    }
                } catch _ {
                    completion(nil)
                }
            }
            
        }
        
    }
    
    /// Transfer Api
    func makeTransfer(_ requestModel: TransferRequestModel, completion: @escaping (TransferResponseModel?) -> Void) {
        APIManager().makeTransfer(requestModel.payeeName, requestModel.amount, requestModel.description) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let transferData = try JSONDecoder().decode(TransferResponseModel.self,
                                                                from: data)
                    if transferData.status == "success" {
                        completion(transferData)
                    } else {
                        completion(transferData)
                    }
                } catch _ {
                    completion(nil)
                }
            }
            
        }
        
    }
}

// MARK: - PayeesModel
struct PayeesResponseModel: Decodable {
    let status: String
    let data: [PayeeData]?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status, data, error
    }
}

// MARK: - PayeeData
struct PayeeData: Decodable {
    let id, name, accountNo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, accountNo
    }
}

struct TransferRequestModel {
    var payeeName: String
    var amount: Int
    var description: String
    
    init(payeeName: String, amount: Int, description: String) {
        self.payeeName = payeeName
        self.amount = amount
        self.description = description
    }
}

// MARK: - TransferModel
struct TransferResponseModel: Codable {
    let status, transactionID, recipientAccount, welcomeDescription: String?
    let amount: Int?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case status, amount, recipientAccount, error
        case transactionID = "transactionId"
        case welcomeDescription = "description"
    }
}

