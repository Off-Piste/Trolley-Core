//
//  AppDelegate.m
//  App
//
//  Created by Harry Wright on 04.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "AppDelegate.h"

@import TrolleyCore;

@interface AppDelegate ()

+ (BOOL)isWithinUnitTest;

@end

@implementation AppDelegate

+ (BOOL)isWithinUnitTest {
    if (NSClassFromString(@"XCTestCase")) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([AppDelegate isWithinUnitTest]) {
        return YES;
    }

    [Trolley open];

    return YES;
}



@end
