//
//  RLComposedArrayModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLComposedModule.h"

@interface RLComposedArrayModule : RLComposedModule

#pragma mark - Modules
/** @name Modules */

/** The submodules displayed by this composed array module. */
@property (nonatomic, strong) NSArray *modules;

@end
