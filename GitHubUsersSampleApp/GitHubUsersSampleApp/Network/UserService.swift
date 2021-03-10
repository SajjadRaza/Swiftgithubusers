//
//  UserService.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

protocol ServiceProtocol {
    associatedtype T
    func fetchItemList(params: Parameters, callback: @escaping (Result<[T], AppError>) -> Void)
    func fetchItemDetail(itemName: String, params: Parameters, callback: @escaping (Result<T, AppError>) -> Void)
}

class UserService: NSObject, Requestable, ServiceProtocol {
    typealias T = UserResponseModel
    
    class var shared: UserService {
        struct Static {
            static let instance: UserService = UserService()
        }
        return Static.instance
    }

    func fetchItemList(params: Parameters, callback: @escaping (Result<[UserResponseModel], AppError>) -> Void) {
        getRequest(path: APIEndpoint.users, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let mappedModel = try JSONDecoder().decode([UserResponseModel].self, from: data as! Data)
                    callback(.success(mappedModel))
                } catch {
                    callback(.failure(error as! AppError))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func fetchItemDetail(itemName: String, params: Parameters, callback: @escaping (Result<UserResponseModel, AppError>) -> Void) {
        getRequest(path: "\(APIEndpoint.users)/\(itemName)", params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let mappedModel = try JSONDecoder().decode(UserResponseModel.self, from: data as! Data)
                    callback(.success(mappedModel))
                } catch {
                    callback(.failure(.canNotProcessData))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
