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

- (void)response:(dataResponse)callback;

- (void)responseTRLJSON:(jsonResponse)callback NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
