//
//  TrolleyCoreTests.m
//  TrolleyCoreTests
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#define QUICK_DISABLE_SHORT_SYNTAX 1

@import Quick;
@import TrolleyCore;
@import Nimble;

QuickSpecBegin(TRLJSONSpec)

describe(@"JSON", ^{
    it(@"Should create valid JSON", ^{
        TRLJSON *json = [[TRLJSON alloc]
                         init:@{@"Foo":@"Bar", @"X": @{ @"nestedFoo" : @"nestedBar" }}];
        expect(json.error).to(beNil());
        expect([json[@"X"] valueForKey:@"nestedFoo"]).to(equal(@"nestedBar"));
    });
});

QuickSpecEnd
