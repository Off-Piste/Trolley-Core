//
//  TRLURLRequest.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TRLURLRequest : NSObject

@property (strong, nullable) NSURLRequest *originalRequest;

@property (strong, nullable) NSError *error;

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithRequest:(NSURLRequest *_Nullable)request failedForError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
