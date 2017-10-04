//
//  Core_iOS_Tests.m
//  Core_iOS_Tests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLBaseCase.h"
//@import TrolleyCore;

#define XCTestCaseSubclass(classname) @interface classname : TRLBaseCase @end

XCTestCaseSubclass(Core_iOS_Tests)

@implementation Core_iOS_Tests

- (void)testOpen {
    // Add Observer here as the call should come before the 'Then' is called
    XCTestExpectation *exp = [self expectationWithDescription:@"TRLTrolleyStartingUpNotification"];
    [self observeNotification:TRLTrolleyStartingUpNotification handler:^(NSNotification *note) {
        [exp fulfill];
    }];

    // Given, When
    [Trolley open];

    // Then
    XCTAssertNotNil([Trolley shop]);
    XCTAssertTrue([Trolley isShopOpen]);

    [self waitForExpectations];
}

@end
