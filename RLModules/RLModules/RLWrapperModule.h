//
//  RLWrapperModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLComposedModule.h"

@interface RLWrapperModule : RLComposedModule

#pragma mark - Submodule
/** @name Submodule */

/** The submodule displayed by this wrapper module. */
@property (nonatomic, strong) RLModule *submodule;

@end
