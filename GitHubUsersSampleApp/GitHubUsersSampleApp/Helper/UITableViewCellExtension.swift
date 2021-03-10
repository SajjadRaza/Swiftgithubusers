//
//  UITableViewCellExtension.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

protocol TableViewCompatibleViewModelProtocol {
    var reuseIdentifier: String { get }
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
}

protocol ConfigurableTableViewCellProtocol {
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
}
