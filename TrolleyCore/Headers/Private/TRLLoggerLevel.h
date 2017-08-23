//
//  TRLLoggerLevel.h
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TRLLoggerLevel) {
    TRLLoggerLevelError = 3,
    TRLLoggerLevelWarning = 4,
    TRLLoggerLevelNotice = 5,
    TRLLoggerLevelInfo = 6,
    TRLLoggerLevelDebug = 7
} NS_SWIFT_NAME(LoggerLevel);

typedef NSString *const TRLLoggerService;

extern TRLLoggerService kTRLLoggerCore;
