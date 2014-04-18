//
//  RLUnionModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@interface RLUnionModule : RLModule

#pragma mark - Initialization
/** @name Initialization */

/**
 Returns a union module with the specified child modules, in order.
 
 @param modules The child modules for the union module.
 @returns An allocated and initialized union module.
 */
+(instancetype)unionModuleWithModules:(NSArray*)modules;

/**
 Initializes a union module with the specified child modules, in order.
 
 @param modules The child modules for the union module.
 @returns An initialized union module.
 */
-(instancetype)initWithModules:(NSArray*)modules;

#pragma mark - Modules
/** @name Modules */

/** The child modules of this union module. */
@property (nonatomic, readonly, strong) NSArray *modules;

@end
