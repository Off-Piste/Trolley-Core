//
//  TRLJSON.h
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 05.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>

#import "TRLJSONBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLJSON : TRLJSONBase <NSCopying, NSMutableCopying>

# pragma mark Properties

@property (strong, readonly) id object;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger count;

@property (strong, readonly, nullable) NSArray<TRLJSON *> *array;

@property (strong, readonly) NSArray<TRLJSON *> *arrayValue;

@property (strong, readonly, nullable) NSDictionary<NSString *, TRLJSON *> *dictionary;

@property (strong, readonly) NSDictionary<NSString *, TRLJSON *> *dictionaryValue;

@property (strong, readonly) NSDictionary<NSString *, id> *dictionaryObject;

@property (strong, readonly, nullable) NSString *string;

@property (strong, readonly) NSString *stringValue;

@property (strong, readonly, nullable) NSNumber *number;

@property (strong, readonly) NSNumber *numberValue;

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;

- (instancetype)objectForKeyedSubscript:(NSString *)key;

# pragma mark Initalisation

+ (instancetype)object:(id)obj NS_SWIFT_NAME(init(_:));

+ (instancetype)parseJSON:(NSString *)jsonString NS_SWIFT_NAME(init(parseJSON:));

+ (instancetype)null;

@end

NS_ASSUME_NONNULL_END
