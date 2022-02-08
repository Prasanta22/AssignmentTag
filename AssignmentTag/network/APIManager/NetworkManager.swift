//
//  NetworkManager.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation

typealias APICompletion = (Result) -> Void
typealias DataTaskResponse = (Data?, URLResponse?, Error?) -> Void

protocol RequestManager {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping DataTaskResponse)
}

class Manager<EndPoint: EndPointType>: RequestManager {
    private var task: URLSessionDataTaskProtocol?
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request(_ route: EndPoint, completion: @escaping DataTaskResponse) {
        if let request = buildRequest(from: route) {
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(nil, nil, error)
                }
//                if let response = response as? HTTPURLResponse {
//                    let result = self.handleNetworkResponse(data, response)
//                    completion(result)
//                }
                completion(data, response, error)
            })
            self.task?.resume()
        }
    }
    fileprivate func buildRequest(from route: EndPoint) -> URLRequest? {
        // Check API endpoint is valid
        guard let endpointUrl = URL(string: APIBuilder.baseURL + route.path) else {
            return nil
        }
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        case .getRequest:
            let retrievedToken: String? = Keychain.value(forKey: "userToken") ?? "Not found"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(retrievedToken, forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = route.httpMethod.rawValue.uppercased()
        if request.httpMethod == ReuestType.post.rawValue.uppercased() {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: route.body ?? [:],
                                                             options: []) else {
                return request
            }
            request.httpBody = httpBody
        } else {
            request.httpBody = nil
        }
        return request
    }
    
    fileprivate func handleNetworkResponse(_ data: Data?, _ response: HTTPURLResponse) -> Result {
        switch response.statusCode {
        case 200...299: return .success(getAPIResponseFor(data, response))
        case 401...500: return .failure(ErrorType.authRequired)
        case 501...599: return .failure(ErrorType.badRequest)
        case 600: return .failure(ErrorType.outdatedRequest)
        default: return .failure(ErrorType.requestFailed)
        }
    }
    fileprivate func getAPIResponseFor(_ data: Data?, _ response: HTTPURLResponse) -> APIResponse {
        do {
            guard let responseData = data else {
                return getAPIResponseWithErrorMessage(errorMessage: ErrorMessage.kNoData)
            }
            guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                return getAPIResponseWithErrorMessage(errorMessage: ErrorMessage.kConversionFailed)
            }
            return APIResponse(body: json, header: nil, statusCode: response.statusCode, errorMessage: nil)
        } catch let error as NSError {
            return getAPIResponseWithErrorMessage(errorMessage: error.debugDescription)
        }
    }
    fileprivate func getAPIResponseWithErrorMessage(errorMessage: String) -> APIResponse {
        let apiResponse = APIResponse(body: nil, header: nil, statusCode: nil, errorMessage: errorMessage)
        return apiResponse
    }
}

