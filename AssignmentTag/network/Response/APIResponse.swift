//
//  APIResponse.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

struct APIResponse {
    var body: [String: Any]?
    var header: [String: Any]?
    var statusCode: Int?
    var errorMessage: String?
}
