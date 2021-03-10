//
//  UserDataSource.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

enum UserCellType: String {
    case normal = "UserTableViewCell"
    case note = "UserNotesTableViewCell"
    case inverted = "InvertedTableViewCell"
}

protocol UserDataSourceProtocol: class {
    var searching: Bool { get set }
    func userSelect(user: User)
}

class UserDataSource: NSObject {
    
    weak var parentView: UsersViewController?
    weak var delegate: UserDataSourceProtocol?
    init(attachView: UsersViewController) {
        super.init()
        self.parentView = attachView
        self.delegate = (attachView as UserDataSourceProtocol)
        attachView.tableView.delegate = self
        attachView.tableView.dataSource = self
        self.setLoaderToFooterOfTableView(attachView.tableView)
        attachView.tableView.register(UINib(nibName: UserCellType.normal.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.normal.rawValue)
        attachView.tableView.register(UINib(nibName: UserCellType.inverted.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.inverted.rawValue)
        attachView.tableView.register(UINib(nibName: UserCellType.note.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.note.rawValue)
    }
    
    func setLoaderToFooterOfTableView(_ tableView: UITableView) {
        var indictaor: UIActivityIndicatorView?
        if #available(iOS 13.0, *) {
            indictaor = UIActivityIndicatorView(style: .large)
        } else {
            indictaor = UIActivityIndicatorView(style: .gray)
        }
        indictaor?.startAnimating()
        indictaor?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        tableView.tableFooterView = indictaor
    }
}

// MARK: - UITableView Delegate And Datasource Methods

extension UserDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parentView!.viewModel.getUsers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.parentView!.viewModel.getUsers()[indexPath.row]
        return (model as! TableViewCompatibleViewModelProtocol).cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.parentView!.searching {
            if indexPath.row == self.parentView!.viewModel.getUsers().count - 1 {
                self.parentView!.viewModel.fetchUserList(nextBatch: true)
            }
            self.parentView?.tableView.tableFooterView?.isHidden = false
        } else {
            self.parentView?.tableView.tableFooterView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.parentView!.viewModel.getUsers()[indexPath.row]
        self.delegate?.userSelect(user: user.userModel)
    }
}
