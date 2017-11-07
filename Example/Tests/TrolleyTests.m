//
//  TrolleyTests.m
//  TrolleyTests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLBaseCase.h"
@import TrolleyCore;
//@import TrolleyCore;

TRLBaseCaseSubclass(TrolleyTests)

@implementation TrolleyTests

- (void)testThatOpenWillNotThrowExcertion {
    // Add Observer here as the call should come before the 'Then' is called
    XCTestExpectation *exp = TRLExpectation;
    [self observeNotification:TRLTrolleyStartingUpNotification handler:^(NSNotification *note) {
        [exp fulfill];
    }];

    // Given, When
    XCTAssertNoThrow([Trolley open]);

    // Then
    XCTAssertNotNil([Trolley shop]);
    XCTAssertTrue([Trolley isShopOpen]);
    XCTAssertEqualObjects([[Trolley shop] shopName], kDefaultShopName);

    [self waitForExpectations];
}

- (void)testThatOpenWithOptionsWillNotThrowException {
    // Add Observer here as the call should come before the 'Then' is called
    XCTestExpectation *exp = TRLExpectation;
    [self observeNotification:TRLTrolleyStartingUpNotification handler:^(NSNotification *note) {
        [exp fulfill];
    }];

    // Given, When
    XCTAssertNoThrow([Trolley openWithOptions:[TRLOptions defaultOptions]]);

    // Then
    XCTAssertNotNil([Trolley shop]);
    XCTAssertTrue([Trolley isShopOpen]);
    XCTAssertEqualObjects([[Trolley shop] shopName], kDefaultShopName);

    [self waitForExpectations];
}

- (void)testThatOpenWithOptionsCustomPlistNameWillThrowException {
    // Given
    TRLOptions *options = [TRLOptions optionsForPlist:@"invalid_options"];

    // When, Then
    XCTAssertThrows([Trolley openWithOptions:options]);
    XCTAssertNil([Trolley shop]);
    XCTAssertFalse([Trolley isShopOpen]);
}

- (void)testThatOpenWithOptionsCustomOptionsWillThrowExecption {
    // Given
    TRLOptions *options = [TRLOptions optionsForID:@"invalid_options"
                                               URL:@"http://invalid.url.org"
                                   DefaultCurrency:@"GBP"];

    // When, Then
    XCTAssertThrows([Trolley openWithOptions:options]);
    XCTAssertNil([Trolley shop]);
    XCTAssertFalse([Trolley isShopOpen]);
}

- (void)testThatOpenWithOptionsCustomOptionsWillNotThrowExecption {
    TRLOptions *options = [TRLOptions optionsForID:@"2:ios:asgagahgvsdgvvc:tester"
                                               URL:@"http://localhost:8080"
                                   DefaultCurrency:@"GBP"];

    // When, Then
    XCTAssertNoThrow([Trolley openWithOptions:options]);
    XCTAssertNotNil([Trolley shop]);
    XCTAssertTrue([Trolley isShopOpen]);
}

- (void)testThatCallingOpenTwiceWillThrowExecption {
    XCTAssertNoThrow([Trolley open]);
    XCTAssertThrows([Trolley open]);
}

- (void)testThatDeleteAppWillDeleteApp {
    // Given, When
    [Trolley open];

    // Then
    [[Trolley shop] deleteShopWithHandler:^(BOOL deleted) {
        XCTAssertTrue(deleted);
    }];

    XCTAssertNil([Trolley shop]);
}

- (void)testThatDeleteAppWillNotDeleteApp {
    // Given, When, Then
    [[Trolley shop] deleteShopWithHandler:^(BOOL deleted) {
        XCTAssertFalse(deleted);
    }];
}

@end
