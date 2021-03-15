//
//  UserViewModel.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

protocol UserListViewModelProtocol {
    
    var userDidChanges: ((Bool, Bool) -> Void)? { get set }
    var userFetched: ((User) -> Void)? { get set }
    var dataUpdated: ((Bool) -> Void)? { get set }
    
    var searchQuery: String { get set }
    
    func fetchUserList(nextBatch: Bool)
    func fetchUserDetail(userName: String)
    
    
}
class UserListViewModel: UserListViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var userDidChanges: ((Bool, Bool) -> Void)?
    var userFetched: ((User) -> Void)?
    var dataUpdated: ((Bool) -> Void)?
    var searchQuery = ""
    
    private var users: [User]? {
        didSet {
            self.processUsers()
        }
    }
    
    private var usersCellVM: [UserCellViewModelProtocol]? {
        didSet {
            self.userDidChanges!(true, false)
        }
    }
    
    // MARK: - UserListViewModelProtocol
    func fetchUserList(nextBatch: Bool) {
        if nextBatch {
            Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UsersFetch"})
            Global.shared.queueManager.queueList.append(self.fetchAllUsersTask(isNextBatch: nextBatch))
            Global.shared.queue.addOperation(self.fetchAllUsersTask(isNextBatch: nextBatch))
        } else {
            if let fetchedData = UserDataManager.shared.getAllStoredData() {
                if fetchedData.count == 0 {
                    Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UsersFetch"})
                    Global.shared.queueManager.queueList.append(self.fetchAllUsersTask(isNextBatch: nextBatch))
                    Global.shared.queue.addOperation(self.fetchAllUsersTask(isNextBatch: nextBatch))
                } else {
                    self.users = fetchedData
                }
            } else {
                Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UsersFetch"})
                Global.shared.queueManager.queueList.append(self.fetchAllUsersTask(isNextBatch: nextBatch))
                Global.shared.queue.addOperation(self.fetchAllUsersTask(isNextBatch: nextBatch))
            }
        }
    }
    
    func getUsers() -> [UserCellViewModelProtocol] {
        if  self.searchQuery != "" {
            return self.usersCellVM?.filter({
                if let loginName = $0.userModel.login, let note = $0.userModel.note, let name = $0.userModel.name {
                    return (loginName.lowercased().contains(self.searchQuery.lowercased()) || note.contains(self.searchQuery) || name.contains(self.searchQuery))
                } else {
                    return false
                }
            }) ?? []
        } else {
            return self.usersCellVM ?? []
        }
    }
    
    func fetchUserDetail(userName: String) {
        Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UserDetail"})
        Global.shared.queueManager.queueList.append(self.fetchUserDetailTask(userName: userName))
        Global.shared.queue.addOperation(self.fetchUserDetailTask(userName: userName))
    }
    
    func updateUserData(user: User, notes: String) {
        let updated = UserDataManager.shared.updateItem(item: user, attributeName: "note", attributeValue: notes)
        
        if updated {
            self.processUsers()
        }
        self.dataUpdated!(updated)
    }
    
    //MARK: - Public
    func setSearch(text: String) {
        self.searchQuery = text
        self.userDidChanges!(true, false)
        
    }
    
    //MARK: - Private Methods
    fileprivate func processUsers() {
        if let usersArray = users {
            var tempCellVMs = [UserCellViewModelProtocol]()
            for (index, user) in usersArray.enumerated() {
                if index.isMultiple(of: 3) && index != 0 {
                    let invertedVM = InvertedUserCellViewModel(user: user)
                    tempCellVMs.append(invertedVM)
                } else if user.note != "" && user.note != nil {
                    let noteVM = NoteUserCellViewModel(user: user)
                    tempCellVMs.append(noteVM)
                } else {
                    let normalVM = NormalUserCellViewModel(user: user)
                    tempCellVMs.append(normalVM)
                }
            }
            self.usersCellVM = tempCellVMs
        }
    }
    
    fileprivate func fetchAllUsersTask(isNextBatch: Bool = false) -> ConcurrentOperation {
        let concurrentOperationA = ConcurrentOperation { _ in
            UserDataManager.shared.fetchList(fetchNextRecords: isNextBatch) { (result) in
                switch result {
                case .success(let users):
                    self.users = users
                    Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UsersFetch"})
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        concurrentOperationA.name = "UsersFetch"
        return concurrentOperationA
    }
    
    fileprivate func fetchUserDetailTask(userName: String) -> ConcurrentOperation {
        let concurrentOperationA = ConcurrentOperation { _ in
            UserDataManager.shared.fetchItem(itemName: userName) { (result) in
                switch result {
                case .success(let fetchUser):
                    self.userFetched!(fetchUser)
                    Global.shared.queueManager.queueList = Global.shared.queueManager.queueList.filter({$0.name != "UserDetail"})
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        concurrentOperationA.name = "UserDetail"
        return concurrentOperationA
    }
}
