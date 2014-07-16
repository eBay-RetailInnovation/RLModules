//
//  RLComposedArrayModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLComposedModule.h"

@interface RLComposedArrayModule : RLComposedModule

#pragma mark - Initializers
/** @name Initializers */

/**
 Returns an initialized composed array module with the specified submodules.

 @param modules The submodules for the new module.

 @return An initialized composed array module.
*/
+(instancetype)moduleWithModules:(NSArray*)modules;

#pragma mark - Modules
/** @name Modules */

/** The submodules displayed by this composed array module. */
@property (nonatomic, strong) NSArray *modules;

@end
