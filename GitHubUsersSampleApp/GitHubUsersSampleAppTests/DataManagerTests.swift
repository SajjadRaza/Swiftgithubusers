//
//  DataManagerTests.swift
//  GitHubUsersSampleAppTests
//
//  Created by Sajjad Raza on 10/03/2021.
//

import XCTest
import CoreData
@testable import GitHubUsersSampleApp

class DataManagerTests: XCTestCase {
    
    var userDataManager: UserDataManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userDataManager = UserDataManager.shared
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userDataManager = nil
    }
    
    func test_init_userDataManager(){
        
        let instance = UserDataManager.shared
        XCTAssertNotNil( instance )
    }
    
    func test_userDataStackInitialization() {
      let coreDataStack = userDataManager.persistanceContainer
      XCTAssertNotNil( coreDataStack )
    }
    
    func test_fetch_all_users() {
        let expect = expectation(description: "Fetch first batch")
        
        userDataManager.fetchList { (result) in
            switch result {
            case .success(let isFetchedNStore):
                XCTAssertTrue(isFetchedNStore)
            case .failure(let err):
                XCTAssert(true, err.localizedDescription)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func test_fetch_all_users_nextBatch() {
        let expect = expectation(description: "Fetch next batch")
        userDataManager.fetchList(fetchNextRecords: true) { (result) in
            switch result {
            case .success(let isFetchedNStore):
                XCTAssertTrue(isFetchedNStore)
            case .failure(let err):
                XCTAssert(true, err.localizedDescription)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func test_fetch_user() {
        let expect = expectation(description: "Fetch user")
        userDataManager.fetchItem(itemName: "topfunky") { (result) in
            switch result {
            case .success(let user):
                XCTAssertNotNil( user )
            case .failure(let err):
                XCTAssert(true, err.localizedDescription)
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func test_update_user_note() {
        let expect = expectation(description: "Update note")
        userDataManager.fetchItem(itemName: "topfunky") { (result) in
            switch result {
            case .success(let user):
                let recordeUpdated = self.userDataManager.updateItem(item: user, attributeName: "note", attributeValue: "Hello this is XCTest note message.")
                XCTAssertTrue(recordeUpdated)
            case .failure(let err):
                XCTAssert(true, err.localizedDescription)
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
