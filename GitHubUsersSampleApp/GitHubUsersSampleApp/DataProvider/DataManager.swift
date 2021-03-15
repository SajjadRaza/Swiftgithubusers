//
//  DataProvider.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    associatedtype T
    func fetchList(fetchNextRecords: Bool, callback: @escaping (Result<[T], AppError>) -> Void)
    func fetchItem(itemName: String, callback: @escaping (Result<T, AppError>) -> Void)
    func updateItem(item: T, attributeName: String, attributeValue: Any) -> Bool
    func getAllStoredData() -> [T]?
}

class UserDataManager: NSObject, DataManagerProtocol {
    class var shared: UserDataManager {
        struct Static {
            static let instance: UserDataManager = UserDataManager()
        }
        return Static.instance
    }
    
    var persistanceContainer = CoreDataStack.shared.persistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistanceContainer.viewContext
    }
    
    typealias T = User
    
    
    // MARK: - DataManagerProtocol
    func fetchItem(itemName: String, callback: @escaping (Result<User, AppError>) -> Void) {
        let params: Parameters = [:]
        
        UserService.shared.fetchItemDetail(itemName: itemName, params: params) { result in
            switch result {
            case .success(let data):
                let taskContext = self.persistanceContainer.newBackgroundContext()
                taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                taskContext.undoManager = nil
                
                if let dataFetched = self.syncUserData(with: data, taskContext: taskContext) {
                    callback(.success(dataFetched))
                } else {
                    callback(.failure(.noDataAvailable))
                }
            case .failure(let error):
                switch error {
                case .canNotProcessData:
                    print("Cannot process the data received from server.")
                case .noDataAvailable:
                    print("No data is available")
                case .serverError:
                    print("Server not responding at the moment. Please try later.")
                case .other:
                    print(error.localizedDescription)
                    
                }
                callback(.failure(error))
            }
        }
    }
    
    func fetchList(fetchNextRecords: Bool = false, callback: @escaping (Result<[User], AppError>) -> Void) {
        var params: Parameters = ["since": "0"]
        
        if fetchNextRecords {
            let lastItemID = self.getLastItemID()
            params = lastItemID != nil ? ["since": "\(lastItemID ?? 0)"] : ["since": "0"]
        }
        
        UserService.shared.fetchItemList(params: params) { result in
            switch result {
            case .success(let data):
                let taskContext = self.persistanceContainer.newBackgroundContext()
                taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                taskContext.undoManager = nil
                let dataSynced = self.syncUsersData(with: data, taskContext: taskContext)
                Global.shared.apiResponsePageSize = data.count
                //callback(.success(dataSynced))
                if dataSynced {
                    let usersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    usersRequest.sortDescriptors = [NSSortDescriptor(key: "userID", ascending: true)]
                    do {
                        let fetchedData = try self.viewContext.fetch(usersRequest)
                        callback(.success((fetchedData as? [User])!))
                    } catch {
                        print("Error: \(error)\nCould not load existing records.")
                    }
                }else {
                    callback(.failure(.canNotProcessData))
                }
            case .failure(let error):
                switch error {
                case .canNotProcessData:
                    print("Cannot process the data received from server.")
                case .noDataAvailable:
                    print("No data is available")
                case .serverError:
                    print("Server not responding at the moment. Please try later.")
                case .other:
                    print(error.localizedDescription)
                }
                callback(.failure(error))
            }
        }
    }
    
    func updateItem(item: User, attributeName: String, attributeValue: Any) -> Bool {
        let taskContext = self.persistanceContainer.viewContext
        item.setValue(attributeValue, forKey: attributeName)
        do {
            try taskContext.save()
            return true
        } catch {
            print("Saving Core Data Failed: \(error)")
        }
        return false
    }
    
    func getAllStoredData() -> [User]? {
        let usersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        usersRequest.sortDescriptors = [NSSortDescriptor(key: "userID", ascending: true)]
        do {
            let fetchedData = try self.viewContext.fetch(usersRequest)
            return fetchedData as? [User]
        } catch {
            print("Error: \(error)\nCould not load existing records.")
            return nil
        }
    }
    
    // MARK: - Private Methods
    fileprivate func getLastItemID() -> Int32? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor.init(key: "userID", ascending: false)]
        
        var maxValue: Int32?
        do {
            let result = try self.viewContext.fetch(request).first
            maxValue = (result as? User)?.userID
        } catch {
            print("Unresolved error in retrieving max personId value \(error)")
        }
        
        return maxValue
    }
    
    fileprivate func syncUsersData(with userRMs: [UserResponseModel], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            
            // Create new records.
            for userRM in userRMs {
                guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: taskContext) as? User else {
                    print("Error: Failed to create a new Film object!")
                    return
                }
                do {
                    try user.update(with: userRM)
                } catch {
                    print("Error: \(error)\nThe quake object will be deleted.")
                    taskContext.delete(user)
                }
            }
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    
    fileprivate func syncUserData(with userRM: UserResponseModel, taskContext: NSManagedObjectContext) -> User? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.fetchLimit = 1
        
        let predicate = NSPredicate(format: "userID == %i", userRM.userID!)
        request.predicate = predicate
        
        do {
            let fetchedData = try self.viewContext.fetch(request).first as! User
            try fetchedData.update(with: userRM)
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            return fetchedData
        } catch {
            print("Unresolved error in retrieving max personId value \(error)")
        }
        return nil
    }
}
