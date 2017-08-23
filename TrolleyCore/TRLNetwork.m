//
//  TRLNetwork.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLNetwork.h"
#import "ParsedURL.h"
#import "TRLNetworkInfo_Internal.h"
#import "ParsedURL_Internal.h"
#import "TRLLogger.h"
#import "TRLURLParameterEncoding.h"

@implementation TRLNetwork

- (instancetype)initWithParsedURL:(ParsedURL *)url {
    self = [super init];
    if (self) {
        self->_url = url;
    }

    return self;
}

- (instancetype)initWithNetworkInfo:(TRLNetworkInfo *)info {
    return [self initWithParsedURL:[[ParsedURL alloc] initWithNetworkInfo:info]];
}

- (instancetype)initWithURL:(NSString *)url
                      error:(NSError *__autoreleasing *)error {
    NSError *err;
    TRLNetworkInfo *info = [[TRLNetworkInfo alloc] initWithURL:url error:&err];

    if (err) {
        *error = err;
        return nil;
    }

    return [self initWithNetworkInfo:info];
}

- (void)get:(NSString *)route encoding:(id<TRLURLParameterEncoding>)encoding {
    
}

- (void)get:(NSString *)route with:(Parameters *)parameters encoding:(id<TRLURLParameterEncoding>)encoding headers:(HTTPHeaders *)headers {

}
@end
