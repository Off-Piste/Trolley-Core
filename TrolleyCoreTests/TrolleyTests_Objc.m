//
//  TrolleyTests_Objc.m
//  TrolleyCoreTests
//
//  Created by Harry Wright on 28.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BaseTestClass.h"

@import TrolleyCore;

@interface TrolleyTests_Objc : BaseTestClass

@end

@implementation TrolleyTests_Objc

- (void)testInitalisation {
    TRLOptions *options = [[TRLOptions alloc] initWithBundle:TestBundle];
    [Trolley openWith:options];

    XCTAssertNotNil([Trolley shop]);
}

- (void)testInvalidEmptyOptions {
    NSError *error;
    TRLOptions *options = [[TRLOptions alloc] init];

    [options validateOrThrowAndReturnError:&error];
    NSLog(@"%@", error);
    XCTAssertNotNil(error);
}

- (void)testInvalidAPIKey_Options {
    describeThrow(@"testInvalidAPIKey_Options", ^{
        NSError *error;
        TRLOptions *options = [TRLOptions optionsForID:[NSUUID UUID].UUIDString
                                                   URL: @"http://www.apple.com"
                                       DefaultCurrency: @"GBP"];

        [options validateOrThrowAndReturnError:&error];
        return error;
    });
}

@end
