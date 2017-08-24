//
//  TRLLogger.m
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <TrolleyCore/TRLLogger.h>
#import <TrolleyCore/TrolleyCore-Swift.h>

TRLLoggerService kTRLLoggerCore = @"[Trolley/Core]";

static TRLLogger *aLogger;

@implementation TRLLogger

+ (TRLLogger *)defaultLogger {
    if (aLogger) {
        return aLogger;
    }

    @synchronized (self) {
        aLogger = [[TRLLogger alloc] init];
        return aLogger;
    }
}

- (BOOL)isLogging {
    BOOL logging = [Trolley shared].isLogging;
    return logging;
}

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
              file:(NSString *)aFile
          function:(NSString *)aFunction
              line:(NSUInteger)line
         seperator:(NSString *)seperator {
    if (![Trolley shared].isLogging) {
        NSLog(@"%i", [Trolley shared].isLogging);
        return;
    }

    NSString *levelString;
    switch (lvl) {
        case TRLLoggerLevelInfo: levelString = @"<INFO>";
        case TRLLoggerLevelDebug: levelString = @"<DEBUG>";
        case TRLLoggerLevelError: levelString = @"<ERROR>";
        case TRLLoggerLevelWarning: levelString = @"<WARNING>";
        default: break; //notice is for printing everything to the user
    }

    NSString *source = [NSString stringWithFormat:@"[%@:%@:%lu]",
                        aFile.lastPathComponent, aFunction, (unsigned long)line];

    NSString *msg = [items componentsJoinedByString:seperator];
    NSString *message;
    if (lvl == TRLLoggerLevelNotice) {
        message = [NSString stringWithFormat:@"%@ %@", service, msg];
    } else {
        message = [NSString stringWithFormat:@"%@ %@ %@ %@",
                   service, levelString, source, msg];
    }

    NSLog(@"%@", message);
}

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
         seperator:(NSString *)seperator {
    if (![Trolley shared].isLogging) {
        return;
    }

    NSString *levelString;
    switch (lvl) {
        case TRLLoggerLevelInfo: levelString = @"<INFO>";
        case TRLLoggerLevelDebug: levelString = @"<DEBUG>";
        case TRLLoggerLevelError: levelString = @"<ERROR>";
        case TRLLoggerLevelWarning: levelString = @"<WARNING>";
        default: break; //notice is for printing everything to the user
    }

    NSString *msg = [items componentsJoinedByString:seperator];
    NSString *message;
    if (lvl == TRLLoggerLevelNotice) {
        message = [NSString stringWithFormat:@"%@ %@", service, msg];
    } else {
        message = [NSString stringWithFormat:@"%@ %@ %@",
                   service, levelString, msg];
    }

    NSLog(@"%@", message);
}

@end
