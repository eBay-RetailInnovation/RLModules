//
//  RLComposedArrayModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLComposedArrayModule.h"

@implementation RLComposedArrayModule

#pragma mark - Initializers
+(instancetype)moduleWithModules:(NSArray*)modules
{
    RLComposedArrayModule *module = [self new];
    module.modules = modules;
    return module;
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    _modules = modules;
    [self invalidateSubmodules];
}

-(NSArray*)currentSubmodules
{
    return _modules;
}

@end
