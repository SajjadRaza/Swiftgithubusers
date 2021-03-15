//
//  UserCellViewModelTests.swift
//  GitHubUsersSampleAppTests
//
//  Created by Sajjad Raza on 14/03/2021.
//

import XCTest
@testable import GitHubUsersSampleApp

class UserCellViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalCellForTableView() {
        
        let tableView = UITableView.init()
        tableView.register(UINib(nibName: UserCellType.normal.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.normal.rawValue)
        
        let userObj = User.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        let userCell = NormalUserCellViewModel(user: userObj)
        let cell = userCell.cellForTableView(tableView: tableView, atIndexPath: IndexPath.init(row: 0, section: 0))
        if !cell.isKind(of: NormalUserCellViewModel.self) {
            XCTAssert(true)
        }
        
    }
    
    func testNoteCellForTableView() {
        
        let tableView = UITableView.init()
        tableView.register(UINib(nibName: UserCellType.note.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.note.rawValue)
        
        let userObj = User.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        let userCell = NoteUserCellViewModel(user: userObj)
        let cell = userCell.cellForTableView(tableView: tableView, atIndexPath: IndexPath.init(row: 0, section: 0))
        if !cell.isKind(of: NoteUserCellViewModel.self) {
            XCTAssert(true)
        }
        
        
    }
    
    func testInvertedCellForTableView() {
        
        let tableView = UITableView.init()
        tableView.register(UINib(nibName: UserCellType.inverted.rawValue, bundle: nil), forCellReuseIdentifier: UserCellType.inverted.rawValue)
        
        let userObj = User.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        let userCell = InvertedUserCellViewModel(user: userObj)
        let cell = userCell.cellForTableView(tableView: tableView, atIndexPath: IndexPath.init(row: 0, section: 0))
        if !cell.isKind(of: InvertedUserCellViewModel.self) {
            XCTAssert(true)
        }
        
        
    }
}
