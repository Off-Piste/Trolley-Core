//
//  TRLURLParameterEncoding.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TRLURLParameterEncoding <NSObject>

- (nullable NSURLRequest *)encode:(NSURLRequest *)request
                    with:(NSDictionary *_Nullable)parameters
                   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
