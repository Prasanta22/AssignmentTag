//
//  HTTPMethod.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

struct ErrorMessage {
    static let kInvalidURL = "Invalid URL"
    static let kInvalidHeaderValue = "Header value is not string"
    static let kNoData = "No Data available"
    static let kConversionFailed = "Conversion Failed"
    static let kInvalidJSON = "Invalid JSON"
    static let kInvalidResponse = "Invalid Response"
    static let kAuthenticationError = "You need to be authenticated first."
    static let kBadRequest = "Bad request"
    static let kOutdatedRequest = "The url you requested is outdated."
    static let kRequestFailed = "Network request failed."
}
