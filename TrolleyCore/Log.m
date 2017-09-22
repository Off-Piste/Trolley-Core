//
//  Log.m
//  ARKit_Test
//
//  Created by Harry Wright on 20.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "Log.h"
#import "TrolleyCore/TrolleyCore-Swift.h"

void TRLLog(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)

    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args_copy];
    [[TRLLogger loggerForService:service] log:logString level:TRLLoggerLevelDefault];
}

void TRLInfoLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)

    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args_copy];
    [[TRLLogger loggerForService:service] log:logString level:TRLLoggerLevelInfo];
}

void TRLDebugLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)

    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args_copy];
    [[TRLLogger loggerForService:service] log:logString level:TRLLoggerLevelDebug];
}

void TRLErrorLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)

    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args_copy];
    [[TRLLogger loggerForService:service] log:logString level:TRLLoggerLevelError];
}

void TRLFaultLogger(TRLLoggerService *service, NSString *format, ...) {
    CVarArgCopy(format)

    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args_copy];
    [[TRLLogger loggerForService:service] log:logString level:TRLLoggerLevelFault];
}


