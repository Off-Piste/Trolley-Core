//
//  Log.m
//  ARKit_Test
//
//  Created by Harry Wright on 20.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "Log.h"

#define OS_LOG_FMT_MAX_CMDS    48
#define OS_LOG_FMT_BUF_SIZE    (2 + (2 + 16) * OS_LOG_FMT_MAX_CMDS)

BOOL isLogging = NO;

TRLLoggerService TRLLoggerServiceCore = @"Trolley/Core";

static inline const char*_Nullable get_app_bundle_identifier(void) {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier] ?
    [[NSBundle mainBundle] bundleIdentifier] : @"Unknown";
    return [bundleIdentifier UTF8String];
}

@interface __TRLLogger ()

@property (retain, readonly) os_log_t _os_log;

@end

@implementation __TRLLogger

+ (instancetype)loggerForService:(TRLLoggerService)service {
    return [[__TRLLogger alloc] initWithService:service];
}

- (instancetype)initWithService:(TRLLoggerService)service {
    if (self = [super init]) {
        const char* serviceChar = [service UTF8String];
        if (serviceChar && get_app_bundle_identifier()) {
            self->__os_log = os_log_create(get_app_bundle_identifier(), serviceChar);
        } else {
            @throw [NSException exceptionWithName:NSGenericException
                                           reason:@"Could not set up logging tools"
                                         userInfo:nil];
        }
    }
    return self;
}

- (void)logWithLevel:(TRLLoggerLevel)level fmt:(const char *)fmt args:(va_list)args {
    // Easier from swift if we have it set to char, would be nicer if we could
    // access the elements inside:
    // https://github.com/apple/swift/blob/master/stdlib/public/SDK/os/os_log.m

    NSString *format = [NSString stringWithUTF8String:fmt];
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    os_log_with_type(self._os_log, level, "%{public}s", [msg UTF8String]);
}

@end
