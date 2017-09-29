//
//  TrolleyCoreTests.swift
//  TrolleyCoreTests
//
//  Created by Harry Wright on 27.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import XCTest
import TrolleyCore

class TrolleyNetworkManagerTests: BaseTestClass {

    func testReachabilty() {
        let exp = self.defaultException()

        // Given, when
        let options = TRLOptions(bundle: .testBundle)
        Trolley.open(with: options)

        // Then
        self.waitForObserver(.reachabilityChanged) { (note) in
            if let reach = note.object as? Reachability {
                XCTAssert(reach.currentReachabilityStatus != NetworkStatus.NotReachable)
            }

            exp.fulfill()
        }

        self.waitForExpectations()
    }
    
}

class TrolleyTests: BaseTestClass {

    func testShopCreation() {
        // Given, when
        let options = TRLOptions(bundle: .testBundle)
        Trolley.open(with: options)

        // Then
        XCTAssertNotNil(Trolley.shop)
    }

    func testInvalidAPIKey_Options() {
        describeThrow(#function) {
            let options = TRLOptions(shopURL: "http://", shopID: UUID().uuidString)

            try options.validateOrThrow()
        }
    }
}
