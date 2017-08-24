//
//  TRLURLEncoding.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRLURLParameterEncoding.h"

NS_ASSUME_NONNULL_BEGIN

@class TRLURLQueryParameters;

typedef NS_ENUM(NSUInteger, TRLURLEncodingDestination) {
    TRLURLEncodingDestinationMethodDependent,
    TRLURLEncodingDestinationQueryString
};

@interface TRLURLEncoding : NSObject<TRLURLParameterEncoding>

@property (readonly) TRLURLEncodingDestination destination;

@property (class, readonly) TRLURLEncoding *queryString;

@property (class, readonly) TRLURLEncoding *methodDependent;

@property (class, readonly) TRLURLEncoding *defaultTRLURLEncoding;

- (instancetype)init;

- (instancetype)initWithDestination:(TRLURLEncodingDestination)destination
NS_DESIGNATED_INITIALIZER;

- (NSString *)escape:(NSString *)string;

- (NSString *)query:(NSDictionary *)parameters;

@end

// Taken from realm, seems like its the best way to check NSNumber...

static inline bool nsnumber_is_like_integer(__unsafe_unretained NSNumber *const obj)
{
    char data_type = obj.objCType[0];
    return data_type == *@encode(bool) ||
    data_type == *@encode(char) ||
    data_type == *@encode(short) ||
    data_type == *@encode(int) ||
    data_type == *@encode(long) ||
    data_type == *@encode(long long) ||
    data_type == *@encode(unsigned short) ||
    data_type == *@encode(unsigned int) ||
    data_type == *@encode(unsigned long) ||
    data_type == *@encode(unsigned long long);
}

static inline bool nsnumber_is_like_bool(__unsafe_unretained NSNumber *const obj)
{
    // @encode(BOOL) is 'B' on iOS 64 and 'c'
    // objcType is always 'c'. Therefore compare to "c".
    if (obj.objCType[0] == 'c') {
        return true;
    }

    if (nsnumber_is_like_integer(obj)) {
        int value = obj.intValue;
        return value == 0 || value == 1;
    }

    return false;
}

NS_ASSUME_NONNULL_END
