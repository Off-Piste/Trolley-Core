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
    XCTestExpectation *exp = DefaultExpectation;
    TRLRetryHelper *helper = [[TRLRetryHelper alloc] initWithDispatchQueue:dispatch_get_main_queue()
                                                 minRetryDelayAfterFailure:1
                                                             maxRetryDelay:40
                                                             retryExponent:1.3f
                                                              jitterFactor:0.7];

    [helper retryWithBlock:^{
        [exp fulfill];
    }];

    [self waitForExpectations];
}

@end
