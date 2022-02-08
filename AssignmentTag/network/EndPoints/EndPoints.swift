//
//  EndPoints.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

protocol BaseURL {
    static var baseURL: String { get }
}

enum APIBuilder {
    struct APIBuilderConstants {
        static let ApiScheme = "https"
        static let ApiHost = "green-thumb-64168.uc.r.appspot.com"
    }
}

extension APIBuilder: BaseURL {
    static var baseURL: String {
        return "\(APIBuilder.APIBuilderConstants.ApiScheme)://\(APIBuilder.APIBuilderConstants.ApiHost)"
    }
}

enum ReuestType: String {
    case post = "POST"
    case get = "GET"
}

public enum UserApi {
    case login(username: String,
               password: String)
    case signup(username: String,
                  password: String)
    case transfer(receipient: String,
                  amount: Int,
                  description: String)
    case payees
}

extension UserApi: EndPointType {
    var body: [String : Any]? {
        switch self {
        case .login(let username, let password):
            return [Constants.username.lowercased(): username,
                    Constants.password.lowercased() : password]
        case .signup(let username, let password):
            return [Constants.username.lowercased(): username,
                    Constants.password.lowercased() : password]
        case .transfer(let receipient, let amount, let description):
            return [Constants.receipient: receipient,
                    Constants.amountText.lowercased() : amount,
                    Constants.description : description]
        case .payees:
            return nil
        }
    }
    

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/register"
        case .payees:
            return "/payees"
        case .transfer:
            return "/transfer"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .signup:
            return .post
        case .payees:
            return .get
        case .transfer:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .login:
            return .request
        case .signup:
            return .request
        case .payees:
            return .getRequest
        case .transfer:
            return .getRequest
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

