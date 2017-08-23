//
//  TRLNetworkInfo_Helper.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLNetworkInfo.h"

NS_ASSUME_NONNULL_BEGIN

static BOOL TRLNetworkInfoAreEqual(TRLNetworkInfo *lhs, TRLNetworkInfo *rhs);

static TRLNetworkInfo *_Nullable infoForURL(NSString *url, NSError *__autoreleasing *error);

NS_ASSUME_NONNULL_END
