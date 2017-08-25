//
//  TRLURLRequest_Response.h
//  TrolleyCore
//
//  Created by Harry Wright on 24.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class TRLJSON;

typedef void (^dataResponse)(NSData *_Nullable data, NSError *_Nullable error);

typedef void(^jsonResponse)(TRLJSON *_Nullable json, NSError *_Nullable error);

@interface TRLURLRequest ()

/**
 The default

 @param callback <#callback description#>
 */
- (void)response:(dataResponse)callback;


/**
 <#Description#>

 @param queue <#queue description#>
 @param block <#block description#>
 */
- (void)responseWith:(dispatch_queue_t)queue block:(dataResponse)block;

/**
 <#Description#>

 @param callback <#callback description#>
 */
- (void)responseTRLJSON:(jsonResponse)callback NS_REFINED_FOR_SWIFT;

- (void)responseTRLJSONWith:(dispatch_queue_t)queue
                      block:(jsonResponse)callback NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
