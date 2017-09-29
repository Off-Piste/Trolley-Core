//
//  TestBlocks.h
//  TrolleyCoreTests
//
//  Created by Harry Wright on 29.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#ifndef TestBlocks_h
#define TestBlocks_h

#import <XCTest/XCTest.h>

#pragma mark DefaultThrows

typedef NSError *_Nullable(^trl_void_error)(void);

static inline NSError *_Nullable run_void_error_block(trl_void_error _Nonnull block) {
    if (block) {
        return block();
    }
    return nil;
}

#define describeThrow(desc, blk) \
    NSError *error = run_void_error_block(blk); \
    if (!error) { \
        XCTFail(desc); \
    }

#define describeNoThrow(desc, blk) \
    NSError *error = run_void_error_block(blk); \
    if (error) { \
        XCTFail(desc); \
    }

#endif /* TestBlocks_h */
