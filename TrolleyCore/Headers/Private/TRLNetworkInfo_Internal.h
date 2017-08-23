//
//  TRLNetworkInfo_Internal.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <TrolleyCore/TRLNetworkInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class Trolley;

@interface TRLNetworkInfo ()

- (instancetype)initWithHost:(NSString *)aHost
                   namespace:(NSString *)aNamespace
                      secure:(BOOL)isSecure
                         url:(NSURL *_Nullable)url;

- (nullable instancetype)initWithURL:(NSString *)url
                                error:(NSError *__autoreleasing *)error;

- (nullable instancetype)addingPath:(NSString *)path
                              error:(NSError *__autoreleasing *)error;

- (void)addPath:(NSString *)path error:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
