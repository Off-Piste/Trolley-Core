//
//  Log.m
//  ARKit_Test
//
//  Created by Harry Wright on 20.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "Log.h"
#import "TrolleyCore/TrolleyCore-Swift.h"

#define Log(service, level, fmt, args) __log(service, level, format, args_copy); return;

static void __log(TRLLoggerService *service,
                  TRLLoggerLevel level,
                  NSString *fmt,
                  va_list args)
{
    NSString *logString = [[NSString alloc] initWithFormat:fmt arguments:args];
    [[TRLLogger loggerForService:service] log:logString level:level];
}

void TRLLog(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)
    Log(service, TRLLoggerLevelDefault, format, args_copy)
}

void TRLInfoLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)
    Log(service, TRLLoggerLevelInfo, format, args_copy)
}

void TRLDebugLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)
    Log(service, TRLLoggerLevelDebug, format, args_copy)
}

void TRLErrorLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)
    Log(service, TRLLoggerLevelError, format, args_copy)
}

void TRLFaultLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)
    Log(service, TRLLoggerLevelFault, format, args_copy)
}


