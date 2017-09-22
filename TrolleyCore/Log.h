//
//  Log.h
//  ARKit_Test
//
//  Created by Harry Wright on 20.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
@import os.log;

@class TRLLogger;
@class TRLLoggerService;

/**
 <#Description#>

 - TRLLoggerLevelDefault: <#TRLLoggerLevelDefault description#>
 - TRLLoggerLevelInfo: <#TRLLoggerLevelInfo description#>
 - TRLLoggerLevelDebug: <#TRLLoggerLevelDebug description#>
 - TRLLoggerLevelError: <#TRLLoggerLevelError description#>
 - TRLLoggerLevelFault: <#TRLLoggerLevelFault description#>
 */
typedef NS_ENUM(uint8_t, TRLLoggerLevel) {
    TRLLoggerLevelDefault = OS_LOG_TYPE_DEFAULT,
    TRLLoggerLevelInfo = OS_LOG_TYPE_INFO,
    TRLLoggerLevelDebug = OS_LOG_TYPE_DEBUG,
    TRLLoggerLevelError = OS_LOG_TYPE_ERROR,
    TRLLoggerLevelFault = OS_LOG_TYPE_FAULT,
} NS_SWIFT_NAME(LoggerLevel);

#define TRLLoggerServiceCore [TRLLoggerService core]

#define TRLLoggerServiceDatabase [TRLLoggerService database]

#define CVarArgCopy(fmt) \
va_list args, args_copy; \
va_start(args, fmt); \
va_copy(args_copy, args); \
va_end(args); \

/**
 <#Description#>

 @param service <#service description#>
 @param format <#format description#>
 @param ... <#... description#>
 */
void TRLLog(TRLLoggerService *service, NSString *format, ...)
NS_SWIFT_UNAVAILABLE("Please use Swift Methods");

/**
 <#Description#>

 @param service <#service description#>
 @param format <#format description#>
 @param ... <#... description#>
 */
void TRLInfoLogger(TRLLoggerService *service, NSString *format, ...)
NS_SWIFT_UNAVAILABLE("Please use Swift Methods");

/**
 <#Description#>

 @param service <#service description#>
 @param format <#format description#>
 @param ... <#... description#>
 */
void TRLDebugLogger(TRLLoggerService *service, NSString *format, ...)
NS_SWIFT_UNAVAILABLE("Please use Swift Methods");

/**
 <#Description#>

 @param service <#service description#>
 @param format <#format description#>
 @param ... <#... description#>
 */
void TRLErrorLogger(TRLLoggerService *service, NSString *format, ...)
NS_SWIFT_UNAVAILABLE("Please use Swift Methods");

/**
 <#Description#>

 @param service <#service description#>
 @param format <#format description#>
 @param ... <#... description#>
 */
void TRLFaultLogger(TRLLoggerService *service, NSString *format, ...)
NS_SWIFT_UNAVAILABLE("Please use Swift Methods");
