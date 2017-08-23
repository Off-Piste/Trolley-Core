//
//  TRLNetworking.m
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "TRLNetworking.h"

TRLURLRequest *request(NSString *url, NSString *method, Parameters *_Nullable parameters, id<TRLURLParameterEncoding> encoding, HTTPHeaders *_Nullable headers) {
    return [[TRLURLSessionManager defaultSessionManager] requestWithURL:url method:method parameters:parameters encoding:encoding headers:headers];
}
