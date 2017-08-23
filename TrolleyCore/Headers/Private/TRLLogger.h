//
//  TRLLogger.h
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLLoggerLevel.h"

NS_ASSUME_NONNULL_BEGIN

//extern BOOL kIsLogging;

@interface TRLLogger : NSObject

@property (strong, class, readonly) TRLLogger *defaultLogger;

@property (readonly) BOOL isLogging;

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
              file:(NSString *)aFile
          function:(NSString *)aFunction
              line:(NSUInteger)line
         seperator:(NSString *)seperator;

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
         seperator:(NSString *)seperator;

@end

#define CoreLogger(lvl, msg) do { \
if (TRLLogger.defaultLogger.isLogging) { \
NSString *levelString;\
switch (lvl) { \
case TRLLoggerLevelInfo: levelString = @" <INFO> "; \
case TRLLoggerLevelDebug: levelString = @" <DEBUG> "; \
case TRLLoggerLevelError: levelString = @" <ERROR> "; \
case TRLLoggerLevelWarning: levelString = @" <WARNING> "; \
default: levelString = @" "; \
} \
\
NSLog(@"%@%@[%@:%@:%d] %@", kTRLLoggerCore, levelString, [NSString stringWithFormat: @"%s", __FILE__].lastPathComponent, [NSString stringWithFormat: @"%s", __PRETTY_FUNCTION__],__LINE__, msg); } }while(0);


NS_ASSUME_NONNULL_END
