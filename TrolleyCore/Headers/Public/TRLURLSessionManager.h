//
//  TRLURLSessionManager.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLNetworkingConstants.h"
#import "TRLURLParameterEncoding.h"

@class TRLURLRequest;

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLSessionManager : NSObject

@property (strong, class, readonly) TRLURLSessionManager *defaultSessionManager;

@property (strong, class, readonly) HTTPHeaders *defaultHTTPHeaders;

- (TRLURLRequest *)requestWithURL:(NSString *)url
                           method:(NSString *)method
                       parameters:(Parameters *_Nullable)parameters
                         encoding:(id<TRLURLParameterEncoding>)encoding
                          headers:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
