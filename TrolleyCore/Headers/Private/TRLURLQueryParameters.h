//
//  TRLURLQueryParameters.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Workaround for not having touples in Objc
 */
@interface TRLURLQueryParameters : NSObject

@property (readwrite, nonatomic, strong) id field;

@property (readwrite, nonatomic, strong) id value;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *URLEncodedStringValue;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithField:(id)field value:(id)value NS_DESIGNATED_INITIALIZER;

@end
