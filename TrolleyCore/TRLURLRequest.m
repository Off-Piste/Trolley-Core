//
//  TRLURLRequest.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequest.h"
#import "TRLURLRequest_Internal.h"
#import "TRLURLRequestBuilder.h"
#import "TRLURLEncoding.h"
#import "TRLURLRequest_Response.h"
#import <TrolleyCore/TrolleyCore-Swift.h>
#import "TRLLogger.h"

@implementation TRLURLRequest

- (NSURLRequest *)request {
    return _originalRequest;
}

- (NSError *)error {
    return _error;
}

- (dispatch_queue_t)queue {
    NSString *label = [NSString stringWithFormat:@"io.trolley.core.%@",
                       [NSUUID UUID].UUIDString];
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
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

#pragma mark Response

- (void)response:(dataResponse)callback {
    if (self.error) {
        callback(NULL, self.error);
        return;
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callback(data, error);
    }];
    
    [task resume];
    return;
}

- (void)responseTRLJSON:(jsonResponse)callback {
    [self response:^(NSData *data, NSError *error) {
        if (error) {
            callback(NULL, error);
        } else {
            TRLJSON *json = [[TRLJSON alloc] initWithNullable_data:data];
            if (json.error) {
                callback(NULL, json.error);
            } else {
                callback(json, NULL);
            }
        }
    }];
}

#pragma mark Requests

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
    return [[TRLURLRequestBuilder defaultRequestBuilder] requestWithURL:url method:method parameters:parameters encoding:encoding headers:headers];
}

@end
