//
//  RLModulesCollectionViewLayout.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule+Private.h"
#import "RLModulesCollectionViewLayout.h"

@implementation RLModulesCollectionViewLayout

#pragma mark - Deallocation
-(void)dealloc
{
    self.modules = nil;
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    for (RLModule *module in _modules)
    {
        module.collectionViewLayout = nil;
    }
    
    _modules = modules;
    
    for (RLModule *module in _modules)
    {
        module.collectionViewLayout = self;
    }
}

@end
