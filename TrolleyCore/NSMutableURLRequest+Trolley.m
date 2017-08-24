//
//  NSURLRequest+Trolley.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "NSMutableURLRequest+Trolley.h"
#import <TrolleyCore/TrolleyCore-Swift.h>
#import "TRLLogger.h"

@implementation NSMutableURLRequest (Trolley)

- (instancetype)initWithURL:(NSURL *)URL
                     method:(NSString *)method
                    headers:(HTTPHeaders *)headers {
    self = [self initWithURL:URL];
    self.HTTPMethod = method;

    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forHTTPHeaderField:key];
        }];
    }

    return self;
}

- (instancetype)initWithURL:(NSString *)URL
                     method:(NSString *)method
                    headers:(HTTPHeaders *)headers
                      error:(NSError * _Nullable __autoreleasing *)error {
    NSURL *aURL = [NSURL URLWithString:URL];
    if (aURL) {
        return [self initWithURL:aURL method:method headers:headers];
    }

    *error = [TRLError invalidURL:URL];
    return nil;
}

@end
