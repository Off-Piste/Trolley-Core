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
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    TRLOptions *options = [[TRLOptions alloc] initWithBundle:bundle];
    [Trolley openWith:options];

    XCTAssertNotNil([Trolley shop]);
}

@end
