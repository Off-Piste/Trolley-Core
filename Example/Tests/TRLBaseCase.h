//
//  TRLBaseCase.h
//  Core_iOS_Tests
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TrolleyCore;

#define TRLBaseCaseSubclass(classname) \
@interface classname : TRLBaseCase @end \

typedef void(^trl_note_void)(NSNotification *note);

@interface TRLBaseCase : XCTestCase

@property (assign, nonatomic) NSTimeInterval timeout;

- (void)waitForExpectations;

- (void)observeNotification:(NSNotificationName)name handler:(trl_note_void)handler;

@end
