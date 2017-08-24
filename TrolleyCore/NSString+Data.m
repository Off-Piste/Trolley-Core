//
//  NSString+Data.m
//  TrolleyCore
//
//  Created by Harry Wright on 24.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (Data)

+ (NSString *)stringFromData:(NSData *)data {
    NSString *returnValue;
    BOOL boolean;

    [NSString stringEncodingForData:data
                    encodingOptions:NULL
                    convertedString:&returnValue
                usedLossyConversion:&boolean];
    return returnValue;
}

@end
