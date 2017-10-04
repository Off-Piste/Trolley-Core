//
//  TRLBaseCase.m
//  Core_iOS_Tests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLBaseCase.h"

static NSTimeInterval kExpectationTimeout = 30;

@implementation TRLBaseCase

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    if (self = [super initWithInvocation:invocation]) {
        self->_timeout = kExpectationTimeout;
    }
    return self;
}

- (void)waitForExpectations {
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)observeNotification:(NSNotificationName)name
                    handler:(trl_note_void)handler {
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:handler];
}

- (void)tearDown {
    [super tearDown];

    if ([Trolley isShopOpen]) {
        [[Trolley shop] deleteAppWithHandler:^(BOOL handler) {
            XCTAssertTrue(handler);
        }];
    }
}


@end
