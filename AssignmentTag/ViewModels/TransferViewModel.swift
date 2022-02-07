//
//  TransferViewModel.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

struct TransferViewModel {
    
    func transfer(completion: @escaping (LoginResponseModel?) -> Void) {
        APIManager().transfer { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let loginData = try JSONDecoder().decode(LoginResponseModel.self,
                                                             from: data)
                    if loginData.status == "success" {
                        completion(loginData)
                    } else {
                        completion(loginData)
                    }
                } catch _ {
                    completion(nil)
                }
            }

        }

    }
}
