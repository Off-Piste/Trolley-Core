//
//  LogMarco.h
//  TrolleyCore
//
//  Created by Harry Wright on 06.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#ifndef LogMarco_h
#define LogMarco_h

#define os_log_trl_bridge(service, level, fmt, ...) \
    if (isLogging) {\
        __TRLLogger *logger = [__TRLLogger loggerForService:service]; \
        os_log_t os_logger = [logger valueForKey:@"_os_log"]; \
        os_log_with_type(os_logger, level, fmt, ##__VA_ARGS__); \
    }

#define os_log_trl_bridge_t(level, fmt, ...) \ \
    os_log_t os_logger = [self valueForKey:@"_os_log"]; \
    os_log_with_type(os_logger, level, fmt, ##__VA_ARGS__);

#define TRLLog(service, fmt, ...) \
    os_log_trl_bridge(service, TRLLoggerLevelDefault, fmt, ##__VA_ARGS__);

#define TRLInfoLogger(service, fmt, ...) \
    os_log_trl_bridge(service, TRLLoggerLevelInfo, fmt, ##__VA_ARGS__);

#define TRLDebugLogger(service, fmt, ...) \
    os_log_trl_bridge(service, TRLLoggerLevelDebug, fmt, ##__VA_ARGS__);

#define TRLErrorLogger(service, fmt, ...) \
    os_log_trl_bridge(service, TRLLoggerLevelError, fmt, ##__VA_ARGS__);

#define TRLFaultLogger(service, fmt, ...) \
    os_log_trl_bridge(service, TRLLoggerLevelFault, fmt, ##__VA_ARGS__);

#endif /* LogMarco_h */
