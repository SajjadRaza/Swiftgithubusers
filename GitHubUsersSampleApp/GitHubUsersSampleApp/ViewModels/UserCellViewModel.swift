//
//  UserCellViewModel.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

protocol UserCellViewModelProtocol {
    
    var userModel: User { get set }
}

class NormalUserCellViewModel: UserCellViewModelProtocol, TableViewCompatibleViewModelProtocol {
    var userModel: User
    init(user: User) {
        self.userModel = user
    }
    // MARK: - TableViewCompatible
    var reuseIdentifier: String {
        return "UserTableViewCell"
    }
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.configureWithModel(self.userModel)
        return cell
    }
    
}

class NoteUserCellViewModel: UserCellViewModelProtocol, TableViewCompatibleViewModelProtocol {
    var userModel: User
    init(user: User) {
        self.userModel = user
    }
    // MARK: - TableViewCompatible
    var reuseIdentifier: String {
        return "UserNotesTableViewCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! UserNotesTableViewCell
        cell.configureWithModel(self.userModel)
        return cell
    }
}

class InvertedUserCellViewModel: UserCellViewModelProtocol, TableViewCompatibleViewModelProtocol {
    var userModel: User
    init(user: User) {
        self.userModel = user
    }
    // MARK: - TableViewCompatible
    var reuseIdentifier: String {
        return "InvertedTableViewCell"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! InvertedTableViewCell
        cell.configureWithModel(self.userModel)
        return cell
    }
}
