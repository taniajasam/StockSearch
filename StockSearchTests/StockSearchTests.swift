//
//  StockSearchTests.swift
//  StockSearchTests
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import XCTest
@testable import StockSearch

class StockSearchTests: XCTestCase {

     var sut: HomeViewModel!
       
       override func setUp() {
           sut = HomeViewModel()
             let testBundle = Bundle(for: type(of: self))
             let path = testBundle.path(forResource: "TestData", ofType: "json")
             let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
             
        let url = URL(string: AppConstants.API.users)
             let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
           
             let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
             NetworkManager.shared.webserviceHelper.session = sessionMock
       }

       override func tearDown() {
           sut = nil
           super.tearDown()
       }

    // NOTE: App should be uninstalled before running this test case.
    
       func test_Users_ParseData() {
         let promise = expectation(description: "Status code: 200")
         
           XCTAssertEqual(sut.users, nil, "Users array should be nil before the data task runs")
           weak var weakSelf = self
        NetworkManager.shared.fetchUsers { (homeResponse) in
               if let homeData = homeResponse {
                   if let users = homeData.users {
                    weakSelf?.sut.saveDataToDB(usersData: users)
                       promise.fulfill()
                   }
               }
           }
           
         wait(for: [promise], timeout: 5)
         
        XCTAssertEqual(sut.users?.count, 100, "Didn't parse 100 items from fake response")
       }
       
}
