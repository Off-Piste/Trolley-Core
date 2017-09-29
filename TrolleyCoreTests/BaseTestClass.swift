//
//  BaseTestClass.swift
//  TrolleyCoreTests
//
//  Created by Harry Wright on 28.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import XCTest
import TrolleyCore

extension Bundle {
    static let testBundle: Bundle = Bundle(for: BaseTestClass.self)
}

open class BaseTestClass: XCTestCase {

    final var timeout: TimeInterval = trl_timeout

    final func waitForExpectations(handler: XCWaitCompletionHandler? = nil) {
        self.waitForExpectations(timeout: timeout, handler: handler)
    }

    final func waitForObserver(
        _ name: NSNotification.Name,
        handler: @escaping (Notification) -> Void
        )
    {
        NotificationCenter
            .default
            .addObserver(forName: name, object: nil, queue: .main, using: handler)
    }

    final func defaultException(_ name: String = #function) -> XCTestExpectation {
        return self.expectation(description: name)
    }

    open override func tearDown() {
        super.tearDown()
        Trolley.shop?.deleteApp()
    }


    open override func setUp() {
        super.setUp()
        trl_set_log()
    }

    func describeNoThrow(
        _ description: String,
        file: StaticString = #file,
        line: UInt = #line,
        body: () throws -> Void
        )
    {
        do {
            try body()
        } catch {
            XCTFail(description, file: file, line: line)
        }
    }

    func describeThrow(
        _ description: String,
        file: StaticString = #file,
        line: UInt = #line,
        body: () throws -> Void
        )
    {
        do {
            try body()
            XCTFail(description, file: file, line: line)
        } catch _ { }
    }

}
