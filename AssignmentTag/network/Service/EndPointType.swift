//
//  EndPointType.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}
