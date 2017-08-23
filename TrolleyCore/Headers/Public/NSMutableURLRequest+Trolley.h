//
//  NSURLRequest+Trolley.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLNetworkingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableURLRequest (Trolley)

- (instancetype)initWithURL:(NSURL *)URL
                     method:(NSString *)method
                    headers:(HTTPHeaders *_Nullable)headers;

- (instancetype _Nullable)initWithURL:(NSString *)URL
                     method:(NSString *)method
                    headers:(HTTPHeaders *_Nullable)headers
                      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
