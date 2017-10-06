//
//  Log.h
//  ARKit_Test
//
//  Created by Harry Wright on 20.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogMarco.h"
@import os.log;

/**
 The level for the Log message.

 :nodoc:
 - TRLLoggerLevelDefault:   OS_LOG_TYPE_DEFAULT
 - TRLLoggerLevelInfo:      OS_LOG_TYPE_INFO
 - TRLLoggerLevelDebug:     OS_LOG_TYPE_DEBUG
 - TRLLoggerLevelError:     OS_LOG_TYPE_ERROR
 - TRLLoggerLevelFault:     OS_LOG_TYPE_FAULT
 */
typedef NS_ENUM(uint8_t, TRLLoggerLevel) {
    TRLLoggerLevelDefault = OS_LOG_TYPE_DEFAULT,
    TRLLoggerLevelInfo = OS_LOG_TYPE_INFO,
    TRLLoggerLevelDebug = OS_LOG_TYPE_DEBUG,
    TRLLoggerLevelError = OS_LOG_TYPE_ERROR,
    TRLLoggerLevelFault = OS_LOG_TYPE_FAULT,
} NS_SWIFT_NAME(LoggerLevel);

/**
 :nodoc:
 */
extern TRLLoggerLevel kGlobalLoggerLevel;

/**
 :nodoc:
 */
extern BOOL canLog(TRLLoggerLevel level);

/**
 :nodoc:
 */
typedef NSString *const TRLLoggerService NS_EXTENSIBLE_STRING_ENUM;

/**
 :nodoc:
 */
FOUNDATION_EXPORT TRLLoggerService TRLLoggerServiceCore;

/**
 This is only to be used to get the os_log_t && by our Swift API
 :nodoc:
 */
NS_SWIFT_NAME(trl_logger_t)
@interface __TRLLogger : NSObject

/**
 The main interface for the logger, uses TRLLoggerService to create the os_log_t

 :nodoc:
 @param service  The Current service the user is in, must be created inside that framework
                 so we cannot use them in the wrong areas;
 @return         The TRLLogger instance for the service.
 */
+ (instancetype)loggerForService:(TRLLoggerService)service;

/**
 The Swift compatabil method, please only use from the swift ext

 :nodoc:
 @param level   TRLLoggerLevel for the log
 @param fmt     The string format
 @param args    The va_list
 */
- (void)logWithLevel:(TRLLoggerLevel)level fmt:(const char *)fmt args:(va_list)args
NS_SWIFT_NAME(log(level:fmt:_:));

@end
