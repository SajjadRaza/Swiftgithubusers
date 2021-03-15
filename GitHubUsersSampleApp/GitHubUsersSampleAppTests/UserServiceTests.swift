//
//  UserServiceTests.swift
//  GitHubUsersSampleAppTests
//
//  Created by Sajjad Raza on 14/03/2021.
//

import XCTest
@testable import GitHubUsersSampleApp

class UserServiceTests: XCTestCase {

    var userService: UserService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userService = UserService.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchItemList() {
        let expect = expectation(description: "Fetch users List")
        let params: Parameters = ["since": "0"]
        userService.fetchItemList(params: params) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil( data )
            case .failure(let error):
                XCTAssertNotNil( error )
            }
        }
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testFetchUserList - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testFetchItemDetail() {
        let expect = expectation(description: "Fetch users List")
        let params: Parameters = ["since": "0"]
        let itemName: String = "mojombo"
        userService.fetchItemDetail(itemName: itemName, params: params) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil( data )
            case .failure(let error):
                XCTAssertNotNil( error )
            }
        }
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testFetchUserList - waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
