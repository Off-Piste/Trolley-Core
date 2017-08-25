//
//  TRLURLRequestBuilder.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequestBuilder.h"
#import "NSMutableURLRequest+Trolley.h"
#import "TRLURLParameterEncoding.h"
#import "TRLURLRequest_Internal.h"
#import "TRLLogger.h"
#import <TrolleyCore/TrolleyCore-Swift.h>

static TRLURLRequestBuilder *aBuilder;

@implementation TRLURLRequestBuilder

// Consider removing this and changing - to
// + for requestWithURL...
+ (TRLURLRequestBuilder *)defaultRequestBuilder {
    if (aBuilder) {
        return aBuilder;
    }
    @synchronized (self) {
        aBuilder = [[TRLURLRequestBuilder alloc] init];
        return aBuilder;
    }

    // This old lump causes a memery leak
    // keeping it here so I know to avoid it.
//    TRLURLRequestBuilder *aSession;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        aSession = [[TRLURLRequestBuilder alloc] init];
//    });
//    return aSession;
}

+ (HTTPHeaders *)defaultHTTPHeaders {
    NSString *acceptEncoding = @"gzip;q=1.0, compress;q=0.5";
    NSString *userAgent = [[UserAgent shared] header];
    NSString *acceptLanguage = [NSLocale acceptLanguage];

    NSLog(@"%@", userAgent);
    return @{@"Accept-Encoding": acceptEncoding, @"Accept-Language": acceptLanguage, @"User-Agent": userAgent };
}

- (void)dealloc {
    @synchronized (self) {
        aBuilder = nil;
    }
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
