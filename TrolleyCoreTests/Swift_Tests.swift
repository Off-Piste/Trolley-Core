//
//  Swift_Tests.swift
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import XCTest
@testable import TrolleyCore
import TrolleyCore.Private

class Swift_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

//        TRLURLEncoding.default
        let rsq = request("http://www.apple.co.uk/API", "GET", ["key":"Hello"], TRLURLEncoding.default, nil)
        print(rsq)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
