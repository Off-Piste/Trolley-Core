//
//  ParsedURL_Internal.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import "ParsedURL.h"

@interface ParsedURL ()

- (ParsedURL *)addingPath:(NSString *)path;

- (void)addPath:(NSString *)path;

@end
