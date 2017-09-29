//
//  BaseTestClass.h
//  TrolleyCoreTests
//
//  Created by Harry Wright on 28.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestBlocks.h"

#define TestBundle [NSBundle bundleForClass:[self class]]

#define DefaultExpectation \
    [self expectationWithDescription:[NSString stringWithFormat:@"%s", __FUNCTION__]];

NS_ASSUME_NONNULL_BEGIN

typedef void(^notification_handler)(NSNotification *note);

@interface BaseTestClass : XCTestCase

@property (nonatomic, assign) NSTimeInterval timeout;

- (void)waitForExpectations;

- (void)waitForExpectationsWithHandler:(XCWaitCompletionHandler _Nullable)handler;

- (void)waitForObserver:(NSNotificationName)name
            withHandler:(notification_handler _Nonnull)handler;

@end

NS_ASSUME_NONNULL_END
