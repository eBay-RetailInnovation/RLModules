//
//  RLWrapperModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLWrapperModule.h"

@implementation RLWrapperModule

-(void)setSubmodule:(RLModule *)submodule
{
    _submodule = submodule;
    [self invalidateSubmodules];
}

-(NSArray*)currentSubmodules
{
    return _submodule ? @[_submodule] : @[];
}

@end
