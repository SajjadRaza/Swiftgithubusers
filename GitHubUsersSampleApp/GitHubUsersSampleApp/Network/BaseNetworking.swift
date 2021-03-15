//
//  BaseNetworking.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

enum AppError: Error {
    case noDataAvailable
    case canNotProcessData
    case serverError
    case other
}

enum RequestType {
    case data
}

enum ResponseType {
    case json
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

typealias Headers = [String: String]
typealias Parameters = [String: Any]

protocol Requestable {
}

extension Requestable {
    
    private func urlRequest(with method: RequestMethod, path: String, params: Parameters) -> URLRequest? {
        guard let url = url(with: Global.shared.environment.baseURL, path: path, method: method, params: params ) else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = Global.shared.environment.headers
        request.httpBody = getJSONBody(with: method, params: params)
        
        return request
    }
    
    private func url(with baseURL: String, path: String, method: RequestMethod, params: Parameters) -> URL? {
        guard var urlComponents = URLComponents(url: URL.init(string: baseURL)!, resolvingAgainstBaseURL: false) else {
            return nil
        }
        urlComponents.path = path
        urlComponents.queryItems = getQueryItems(with: method, params: params)
        return urlComponents.url
    }
    
    private func getQueryItems(with method: RequestMethod, params: Parameters) -> [URLQueryItem]? {
        guard method == .get else {
            return nil
        }
        return params.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = (value as AnyObject).description
            return URLQueryItem(name: key, value: valueString)
        }
    }
    private func getJSONBody(with method: RequestMethod, params: Parameters) -> Data? {
        guard [.post, .put].contains(method) else {
            return nil
        }
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: params,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
}

extension Requestable {
    internal func getRequest(path: String, params: Parameters, callback: @escaping (Result<Any, AppError>) -> Void) {
        request(method: .get, path: path, params: params, callback: callback)
    }
    
    internal func request(method: RequestMethod, path: String, params: Parameters, callback: @escaping (Result<Any, AppError>) -> Void ) {
        guard let urlRequest = urlRequest(with: method, path: path, params: params) else {
            callback(.failure(.other))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Requestable - request error - \(error.localizedDescription)")
                    callback(.failure(.noDataAvailable))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        callback(.success(data!))
                    } else {
                        callback(.failure(.serverError))
                    }
                }
            }
        }
        task.resume()
    }
}
