//
//  ParsedURL.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "ParsedURL.h"
#import "TRLNetworkInfo.h"
#import "TRLNetworkInfo_Internal.h"
#import "ParsedURL_Internal.h"
#import "TRLLogger.h"

@implementation ParsedURL

- (NSURL *)url {
    return _info.url;
}

- (NSURL *)connectionURL {
    return _info.connectionURL;
}

- (instancetype)initWithNetworkInfo:(TRLNetworkInfo *)info {
    self = [super init];
    if (self) {
        self->_info = info;
    }
    return self;
}

- (ParsedURL *)addingPath:(NSString *)path {
    NSError *error;
    TRLNetworkInfo *newInfo = [_info addingPath:path error:&error];
    if (error) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:error.localizedDescription
                                     userInfo:NULL];
    }

    return [[ParsedURL alloc] initWithNetworkInfo:newInfo];
}

- (void)addPath:(NSString *)path {
    CoreLogger(TRLLoggerLevelInfo, @"Adding a path to ParsedURL is dangerous, please make sure it is definatly needed!")

    NSError *error;
    [_info addPath:path error:&error];

    if (error) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:error.localizedDescription
                                     userInfo:NULL];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.url.absoluteString];
}

@end
