//
//  TrolleyCore.h
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

//#import <TrolleyCore/TRLCurrency.h>
#import <TrolleyCore/TRLNetworkInfo.h>
#import <TrolleyCore/ParsedURL.h>
#import "NSArray+Map.h"
#import "TRLURLEncoding.h"
#import "TRLNetworking.h"
#import "TRLNetworkingConstants.h"
#import "TRLURLParameterEncoding.h"
#import "TRLURLRequest.h"
#import "TRLURLSessionManager.h"
