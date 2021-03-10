//
//  AppURL.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

protocol EnvironmentProtocol {
    var headers: [String: String] { get }
    var baseURL: String { get }
}

enum AppURL: EnvironmentProtocol {
    case development
    case production
    
    var headers: [String: String] {
        switch self {
        case .development:
            return [:]
        case .production:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.github.com"
        case .production:
            return "https://api.github.com"
        }
    }
}

struct APIEndpoint {
    static let users = "/users"
}
