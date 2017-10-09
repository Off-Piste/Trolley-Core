//
//  TRLBaseCase.m
//  Core_iOS_Tests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLBaseCase.h"

static NSTimeInterval kExpectationTimeout = 30;

NSString *kDefaultShopName = @"default";

@implementation TRLBaseCase {
    id _observer;
}

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
    _observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:name
                             object:nil
                              queue:nil
                         usingBlock:^(NSNotification * _Nonnull note) {
                             handler(note);
                             // Remeber to remove observer or we hit an error.
                             [self removeObserverForNotification:name];
                         }];
}

- (void)removeObserverForNotification:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] removeObserver:_observer name:name object:nil];
}

- (void)tearDown {
    [super tearDown];

    if ([Trolley isShopOpen]) {
        [[Trolley shop] deleteShopWithHandler:^(BOOL handler) {
            XCTAssertTrue(handler);
        }];
    }
}


@end
