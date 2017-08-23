//
//  TRLURLRequest_Internal.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLURLRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLRequest ()

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithRequest:(NSURLRequest *_Nullable)request failedForError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
