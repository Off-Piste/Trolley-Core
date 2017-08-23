//
//  TRLNetwork.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRLNetworkingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class ParsedURL;
@class TRLNetworkInfo;
@protocol TRLURLParameterEncoding;

@interface TRLNetwork : NSObject {
    ParsedURL *_url;
}

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithParsedURL:(ParsedURL *)url NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNetworkInfo:(TRLNetworkInfo *)info;

- (nullable instancetype)initWithURL:(NSString *)url error:(NSError *__autoreleasing *)error;

- (void)get:(NSString *)route
   encoding:(id<TRLURLParameterEncoding>)encoding;

- (void)get:(NSString *)route
       with:(Parameters *_Nullable)parameters
   encoding:(id<TRLURLParameterEncoding>)encoding
    headers:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
