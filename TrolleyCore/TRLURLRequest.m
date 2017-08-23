//
//  TRLURLRequest.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequest.h"
#import "TRLURLRequest_Internal.h"
#import "TRLURLSessionManager.h"
#import "TRLURLEncoding.h"

@implementation TRLURLRequest

- (NSURLRequest *)request {
    return _originalRequest;
}

- (NSError *)error {
    return _error;
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        self->_originalRequest = request;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request failedForError:(NSError *)error {
    self = [super init];
    if (self) {
        self->_error = error;
        self->_originalRequest = request;
    }
    return self;
}

- (NSString *)description {
    return (_originalRequest) ? _originalRequest.URL.absoluteString : _error.localizedDescription;
}

+ (TRLURLRequest *)request:(NSString *)url {
    return [self request:url method:@"GET"];
}

+ (TRLURLRequest *)request:(NSString *)url method:(NSString *)method {
    return [self request:url method:method parameters:nil];
}

+ (TRLURLRequest *)request:(NSString *)url parameters:(Parameters *)parameters {
    return [self request:url method:@"GET" parameters:parameters];
}

+ (TRLURLRequest *)request:(NSString *)url method:(NSString *)method parameters:(Parameters *)parameters {
    TRLURLEncoding *encoding = [TRLURLEncoding defaultTRLURLEncoding];
    return [self request:url method:method parameters:parameters encoding:encoding];
}

+ (TRLURLRequest *)request:(NSString *)url method:(NSString *)method parameters:(Parameters *)parameters encoding:(id<TRLURLParameterEncoding>)encoding {
    return [self request:url method:method parameters:parameters encoding:encoding header:nil];
}

+ (TRLURLRequest *)request:(NSString *)url method:(NSString *)method parameters:(Parameters *)parameters encoding:(id<TRLURLParameterEncoding>)encoding header:(HTTPHeaders *)headers {
    return [[TRLURLSessionManager defaultSessionManager] requestWithURL:url method:method parameters:parameters encoding:encoding headers:headers];
}

@end
