//
//  TRLURLSessionManager.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLSessionManager.h"
#import "NSMutableURLRequest+Trolley.h"
#import "TRLURLParameterEncoding.h"
#import "TRLURLRequest_Internal.h"

@implementation TRLURLSessionManager

+ (TRLURLSessionManager *)defaultSessionManager {
    TRLURLSessionManager *aSession __block;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aSession = [[TRLURLSessionManager alloc] init];
    });
    return aSession;
}

+ (HTTPHeaders *)defaultHTTPHeaders {
    return @{ };
}

- (TRLURLRequest *)requestWithURL:(NSString *)url
                           method:(NSString *)method
                       parameters:(Parameters *)parameters
                         encoding:(id<TRLURLParameterEncoding>)encoding
                          headers:(HTTPHeaders *)headers {
    NSMutableURLRequest *orginalRequest;
    NSError *error;

    orginalRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                       method:method
                                                      headers:headers
                                                        error:&error];

    if (error) {
        return [[TRLURLRequest alloc] initWithRequest:orginalRequest failedForError:error];
    }

    error = nil;
    NSURLRequest *encodedRequest = [encoding encode:orginalRequest with:parameters error:&error];
    if (error) {
        return [[TRLURLRequest alloc] initWithRequest:orginalRequest failedForError:error];
    }

    return [[TRLURLRequest alloc] initWithRequest:encodedRequest];
}

@end
