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

@import PromiseKit;

@implementation TRLURLRequest

- (NSURLRequest *)request {
    return _originalRequest;
}

- (NSError *)error {
    return _error;
}

- (dispatch_queue_t)queue {
    NSString *fmt = @"io.trolley.core.networking.%@";
    NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@"."].lowercaseString;
    NSString *label = [NSString stringWithFormat:fmt, uuid];
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
}

- (NSURLSession *)session {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = [TRLURLRequestBuilder defaultHTTPHeaders];
    return [NSURLSession sessionWithConfiguration:configuration];
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
    [self responseWith:self.queue block:callback];
    return;
}

- (void)responseWith:(dispatch_queue_t)queue block:(dataResponse)block {
    if (self.error) {
        block(NULL, self.error);
        return;
    }

    NSLog(@"%@ %@", queue.description, self.session.description);

    // Why use promise kit?
    // Well it helps keep all my internal aysnc code neat and is easly readable
    // for all who wish to use us, and it pre-validates the JSON so saves us
    // adding a new couple methods to ask users if they wish to validate like
    // alamofire does.
    [self.session promiseDataTaskWithRequest:self.request]
    .thenOn(queue, ^(id obj){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            TRLJSON *json = [[TRLJSON alloc] init:obj];
            if (json.error) {
                @throw json.error; // Highly unlikly but do so anyway
            }
            block(json.rawData, NULL);
        } else if ([obj isKindOfClass:[NSString class]]) {
            NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
                block(data, NULL);
            } else {
                // Highly unlikly but do so anyway
                @throw [TRLError invalidJSON:(NSString *)obj];
            }
        } else {
            block((NSData *)obj, NULL);
        }
    }).catch(^(NSError *error){
        block(NULL, error);
    });

    return;

}

- (void)responseTRLJSON:(jsonResponse)callback {
    [self responseTRLJSONWith:self.queue block:callback];
}

- (void)responseTRLJSONWith:(dispatch_queue_t)queue block:(jsonResponse)callback {
    [self responseWith:queue block:^(NSData *data, NSError *error) {
        if (error) {
            callback(NULL, error);
        } else {
            NSError *error;
            TRLJSON *json = [[TRLJSON alloc] initWithNullable_data:data error:&error];
            if (error) {
                callback(NULL, error);
            } else if (json.error) {
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
