//
//  TRLNetworkInfo.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRLNetworkInfo : NSObject

@property (strong, readonly) NSString *host;

@property (strong, readonly) NSString *urlNamespace NS_SWIFT_NAME(namespace);

@property (readonly) BOOL secure;

@property (strong, nullable) NSURL *url;

@property (strong, readonly) NSURL *connectionURL;

@end

NS_ASSUME_NONNULL_END
