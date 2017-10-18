//
//  TRLBaseCase.m
//  Core_iOS_Tests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLBaseCase.h"

#define NSNotficationObserver(name, ...) \
[[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:nil usingBlock:__VA_ARGS__];

static NSTimeInterval kExpectationTimeout = 30;

NSString *kDefaultShopName = @"default";

@implementation TRLBaseCase {
    id _observer;
    NSNotificationName _name;
}

- (void)setUp {
    [super setUp];

    // On the odd ocassion a shop will still be
    // open after -[tearDown] is called.
    if ([Trolley isShopOpen]) {
        [[Trolley shop] deleteShop];
    }
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
    _name = name;
    _observer = NSNotficationObserver(name, handler);
}

- (void)removeObserver:(id)observer forNotification:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
}

- (void)tearDown {
    [super tearDown];

    if (_name != nil && _observer != nil) {
        [self removeObserver:_observer forNotification:_name];
    }

    if ([Trolley isShopOpen]) {
        [[Trolley shop] deleteShop];
    }
}


@end
