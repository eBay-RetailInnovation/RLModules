//
//  RLModuleController.m
//  RLModules
//
//  Created by Nate Stedman on 4/19/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModuleController.h"

NSString *const kRLModuleControllerNilModuleException = @"RLModuleControllerNilModuleException";

@implementation RLModuleController

@synthesize module = _module;

#pragma mark - Module
-(RLModule*)module
{
    if (!_module)
    {
        _module = [self loadModule];
        
        if (!_module)
        {
            @throw [NSException exceptionWithName:kRLModuleControllerNilModuleException
                                           reason:@"-loadModule may not return nil"
                                         userInfo:nil];
        }
    }
    
    return _module;
}

#pragma mark - Module Loading
-(RLModule*)loadModule
{
    return nil;
}

#pragma mark - Cell Classes
+(NSArray*)requiredCellClasses
{
    return @[];
}

-(id)dequeueCellOfClass:(Class)klass
            atIndexPath:(NSIndexPath*)indexPath
       inCollectionView:(UICollectionView*)collectionView
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(klass) forIndexPath:indexPath];
}

@end
