//
//  TrolleyHelpers.m
//  TrolleyCoreTests
//
//  Created by Harry Wright on 28.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TrolleyHelpers.h"

@import TrolleyCore;

NSTimeInterval trl_timeout = 30;

BOOL trl_isLogging = YES;

void trl_set_log(void) {
    [Trolley setlogging:trl_isLogging];
}
