//
//  TRLURLRequest.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequest.h"

@implementation TRLURLRequest

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

#pragma mark Fix this
- (NSString *)description {
    return (self.originalRequest) ? self.originalRequest.URL.absoluteString : self.error.localizedDescription;
}

@end
