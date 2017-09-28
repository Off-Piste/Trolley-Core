//
//  BaseTestClass.m
//  TrolleyCoreTests
//
//  Created by Harry Wright on 28.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "BaseTestClass.h"
#import "TrolleyHelpers.h"

@import TrolleyCore;

@implementation BaseTestClass

- (instancetype)init {
    if (self = [super init]) {
        self->_timeout = trl_timeout;
    }
    return self;
}

- (void)waitForExpectations {
    [self waitForExpectationsWithHandler:nil];
}

- (void)waitForExpectationsWithHandler:(XCWaitCompletionHandler)handler {
    [self waitForExpectationsWithTimeout:self.timeout handler:handler];
}

- (void)waitForObserver:(__autoreleasing NSNotificationName)name
            withHandler:(notification_handler)handler {
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:handler];
}

- (void)setUp {
    [super setUp];
    [Trolley setlogging:trl_isLogging];
}

- (void)tearDown {
    [super tearDown];

    if ([Trolley isShopOpen]) {
        [[Trolley shop] deleteAppWithHandler:nil];
    }
}

@end
