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
    
    func testInitUserDataManager(){
        let instance = UserDataManager.shared
        XCTAssertNotNil( instance )
    }
    
    func testUserDataStackInitialization() {
      let coreDataStack = userDataManager.persistanceContainer
      XCTAssertNotNil( coreDataStack )
    }
    
    func testFetchAllUsers() {
        let expect = expectation(description: "Fetch first batch")
        
        userDataManager.fetchList { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil( data )
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
    
    func testFetchAllUsersNextBatch() {
        let expect = expectation(description: "Fetch next batch")
        userDataManager.fetchList(fetchNextRecords: true) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil( data )
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
    
    func testFetchUser() {
        let expect = expectation(description: "Fetch user")
        userDataManager.fetchItem(itemName: "mojombo") { (result) in
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
    
    func testUpdateUserNote() {
        let expect = expectation(description: "Update note")
        userDataManager.fetchItem(itemName: "mojombo") { (result) in
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
    
    func testGetAllStoredData() {
        let data = userDataManager.getAllStoredData()
        XCTAssertNotNil( data )
    }
}
