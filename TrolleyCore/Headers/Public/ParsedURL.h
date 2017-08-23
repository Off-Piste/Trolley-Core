//
//  ParsedURL.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRLNetworkInfo;

NS_ASSUME_NONNULL_BEGIN

/**
 ParsedURL is the validated URL for all
 calls to the Trolley API server, this is 
 passable into any built in network call
 */
@interface ParsedURL : NSObject {
    TRLNetworkInfo *_info;
}

/**
 <#Description#>
 */
@property (strong, readonly, nullable) NSURL *url;

/**
 <#Description#>
 */
@property (strong, readonly) NSURL *connectionURL;

/**
 @warning Do not use!
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 The Init to create the ParsedURL

 @param info The network info for the URL
 @return A ParsedURL
 */
- (instancetype)initWithNetworkInfo:(TRLNetworkInfo *)info NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
