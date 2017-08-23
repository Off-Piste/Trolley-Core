//
//  TRLURLRequest.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLNetworkingConstants.h"
#import "TRLURLParameterEncoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Request)
@interface TRLURLRequest : NSObject {
    NSURLRequest *_originalRequest;
    NSError *_error;
}

@property (strong, nullable, readonly) NSURLRequest *request;

@property (strong, nullable, readonly) NSError *error;

- (instancetype)init NS_UNAVAILABLE;

/**
 <#Description#>

 @param url <#url description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url __attribute__((unused));

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(NSString *)method __attribute__((unused));

/**
 <#Description#>

 @param url <#url description#>
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                parameters:(Parameters *_Nullable)parameters __attribute__((unused));

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(NSString *)method
                parameters:(Parameters *_Nullable)parameters __attribute__((unused));

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @param encoding <#encoding description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(NSString *)method
                parameters:(Parameters *_Nullable)parameters
                  encoding:(id <TRLURLParameterEncoding>)encoding __attribute__((unused));

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @param encoding <#encoding description#>
 @param headers <#headers description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(NSString *)method
                parameters:(Parameters *_Nullable)parameters
                  encoding:(id <TRLURLParameterEncoding>)encoding
                    header:(HTTPHeaders *_Nullable)headers __attribute__((unused));

@end

NS_ASSUME_NONNULL_END
