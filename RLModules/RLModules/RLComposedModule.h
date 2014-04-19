//
//  RLComposedModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@interface RLComposedModule : RLModule

#pragma mark - Submodules
/** @name Submodules */

/**
 The current submodules of this composed module.
 
 This includes modules with their `[RLModule hidden]` property set to `YES`.
 */
@property (nonatomic, readonly, strong) NSArray *submodules;

/**
 The currently visible submodules of this composed module.
 
 This does not include modules with their `[RLModule hidden]` property set to `YES`.
 */
@property (nonatomic, readonly, strong) NSArray *visibleSubmodules;

/**
 Instructs the composed module to reload its submodules.
 
 It is not necessary to call this method when a submodule is invalidated in some way, hidden, or unhidden. This is
 automatically handled.
 */
-(void)invalidateSubmodules;

/**
 Subclasses must override this message to provide an array of submodules.
 
 The default implementation throws an exception.
 */
-(NSArray*)currentSubmodules;

@end
