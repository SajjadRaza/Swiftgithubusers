//
//  UserListViewModelTests.swift
//  GitHubUsersSampleAppTests
//
//  Created by Sajjad Raza on 14/03/2021.
//

import XCTest
@testable import GitHubUsersSampleApp

class UserListViewModelTests: XCTestCase {

    var userListVM: UserListViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userListVM = UserListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitUserListViewModel(){
        let instance = UserListViewModel()
        XCTAssertNotNil( instance )
    }

    func testFetchUserList() {
        let expect = expectation(description: "Fetch users List")
        
        userListVM.userDidChanges = { (_, error) in
            XCTAssertFalse( error )
        }
        userListVM.fetchUserList(nextBatch: false)
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testFetchUserList - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetUsers() {
        let expect = expectation(description: "Get Users")
        
        userListVM.userDidChanges = { (_, error) in
            if !error {
                let users = self.userListVM.getUsers()
                XCTAssertNotNil( users )
            }
        }
        userListVM.fetchUserList(nextBatch: false)
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testGetUsers - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFetchUserDetail() {
        let expect = expectation(description: "Get Users")
        userListVM.userFetched = {(user) in
            XCTAssertNotNil( user )
        }
        userListVM.fetchUserDetail(userName: "mojombo")
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testFetchUserDetail - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testUpdateUserData() {
        let expect = expectation(description: "Get Users")
        userListVM.userFetched = {(user) in
            self.userListVM.updateUserData(user: user, notes: "Here is the note updated from Test-ULVM.")
        }
        userListVM.dataUpdated = { (success) in
            XCTAssertTrue( success )
        }
        userListVM.fetchUserDetail(userName: "mojombo")
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testUpdateUserData - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSearch() {
        let expect = expectation(description: "Search Users")
        userListVM.userDidChanges = { (_, error) in
            if !error {
                let users = self.userListVM.getUsers()
                XCTAssertNotNil( users )
            }
        }
        userListVM.setSearch(text: "mojombo")
        userListVM.fetchUserList(nextBatch: false)
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testSearch - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
