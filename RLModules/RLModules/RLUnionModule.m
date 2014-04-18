//
//  RLUnionModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule+Private.h"
#import "RLUnionModule.h"

@interface RLUnionModule () <RLModuleDataSource, RLModuleDelegate>

@end

@implementation RLUnionModule

#pragma mark - Initialization
+(instancetype)unionModuleWithModules:(NSArray*)modules
{
    return [[self alloc] initWithModules:modules];
}

-(instancetype)initWithModules:(NSArray*)modules
{
    self = [self init];
    
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        
        _modules = modules;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        for (RLModule *module in _modules)
        {
            [center addObserver:self
                       selector:@selector(childModuleInvalidated:)
                           name:kRLModuleInvalidationNotification
                         object:module];
        }
    }
    
    return self;
}

#pragma mark - Deallocation
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Child Module Invalidation
-(void)childModuleInvalidated:(NSNotificationCenter*)notification
{
    [self invalidateLayout];
}

#pragma mark - Child Modules
-(NSInteger)indexPathItemOffsetForChildModule:(RLModule*)childModule
{
    NSInteger offset = 0;
    
    for (NSInteger i = 0; i < _modules.count; i++)
    {
        RLModule *module = _modules[i];
        
        if (module == childModule)
        {
            break;
        }
        else
        {
            offset -= module.numberOfItems;
        }
    }
    
    return offset;
}

#pragma mark - Layout
-(CGFloat)prepareLayoutAttributes:(NSArray *)layoutAttributes withOrigin:(CGPoint)origin width:(CGFloat)width
{
    NSUInteger count = _modules.count;
    NSUInteger offset = 0;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        RLModule *module = _modules[i];
        NSUInteger itemCount = module.numberOfItems;
        
        // layout
        UIEdgeInsets edgeInsets = module.edgeInsets;
        origin.y += edgeInsets.top;
        origin.y = [module prepareLayoutAttributes:[layoutAttributes subarrayWithRange:NSMakeRange(offset, itemCount)]
                                        withOrigin:CGPointMake(edgeInsets.left, origin.y)
                                             width:width - edgeInsets.left - edgeInsets.right];
        origin.y += edgeInsets.bottom;
        
        // add bottom padding
        RLModule *nextModule = i + 1 < count ? _modules[i + 1] : nil;
        origin.y += MAX(module.minimumBottomPadding, nextModule.minimumTopPadding);
        
        // offset
        offset += itemCount;
    }
    
    return origin.y;
}

#pragma mark - Module Data Source
-(NSInteger)numberOfItemsInModule:(RLModule *)module
{
    NSInteger sum = 0;
    
    for (RLModule *childModule in _modules)
    {
        sum += childModule.numberOfItems;
    }
    
    return sum;
}

-(UICollectionViewCell*)module:(RLModule *)module
            cellForItemAtIndex:(NSInteger)index
              inCollectionView:(UICollectionView *)collectionView
                 withIndexPath:(NSIndexPath *)indexPath
{
    return [module.dataSource module:module
                  cellForItemAtIndex:indexPath.item + [self indexPathItemOffsetForChildModule:module]
                    inCollectionView:collectionView
                       withIndexPath:indexPath];
}

@end
