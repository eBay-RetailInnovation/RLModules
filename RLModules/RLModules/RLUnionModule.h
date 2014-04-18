//
//  RLUnionModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@interface RLUnionModule : RLModule

#pragma mark - Modules
/** @name Modules */

/**
 The child modules of this union module.
 
 This includes modules with their `[RLModule hidden]` property set to `YES`.
 */
@property (nonatomic, strong) NSArray *modules;

/**
 The currently visible child modules of this union module.
 
 This does not include modules with their `[RLModule hidden]` property set to `YES`.
 */
@property (nonatomic, readonly, strong) NSArray *visibleModules;

@end
