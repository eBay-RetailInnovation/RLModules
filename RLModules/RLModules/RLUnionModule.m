//
//  RLUnionModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule+Implementation.h"
#import "RLUnionModule.h"

@interface RLUnionModule ()

@property (nonatomic, strong) NSArray *childModules;

@end

@implementation RLUnionModule

#pragma mark - Deallocation
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hidden"] && [_modules containsObject:object])
    {
        self.visibleModules = [self visibleModulesInArray:_modules];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (RLModule *module in _modules)
    {
        [center removeObserver:self name:kRLModuleContentInvalidationNotification object:module];
        [center removeObserver:self name:kRLModuleLayoutInvalidationNotification object:module];
        [module removeObserver:self forKeyPath:@"hidden"];
    }
    
    _modules = modules;
    
    for (RLModule *module in _modules)
    {
        [module addObserver:self forKeyPath:@"hidden" options:0 context:NULL];
        
        [center addObserver:self
                   selector:@selector(childModuleContentInvalidated:)
                       name:kRLModuleContentInvalidationNotification
                     object:module];
        
        [center addObserver:self
                   selector:@selector(childModuleLayoutInvalidated:)
                       name:kRLModuleLayoutInvalidationNotification
                     object:module];

    }
    
    self.visibleModules = [self visibleModulesInArray:_modules];
}

-(NSArray*)visibleModulesInArray:(NSArray*)array
{
    NSIndexSet *set = [array indexesOfObjectsPassingTest:^BOOL(RLModule *module, NSUInteger idx, BOOL *stop) {
        return !module.hidden;
    }];
    
    return [array objectsAtIndexes:set];
}

-(void)setVisibleModules:(NSArray *)visibleModules
{
    _visibleModules = visibleModules;
    [self invalidateLayout];
}

#pragma mark - Child Module Invalidation
-(void)childModuleContentInvalidated:(NSNotification*)notification
{
    if ([_visibleModules containsObject:notification.object])
    {
        [self invalidateContent];
    }
}

-(void)childModuleLayoutInvalidated:(NSNotification*)notification
{
    if ([_visibleModules containsObject:notification.object])
    {
        [self invalidateLayout];
    }
}

#pragma mark - Child Modules
-(RLModule*)childModuleAtIndex:(NSInteger)index logicalIndex:(NSInteger*)logicalIndex
{
    NSInteger offset = 0;
    
    for (RLModule *module in _visibleModules)
    {
        NSInteger numberOfItems = module.numberOfItems;
        
        if (offset + numberOfItems > index)
        {
            *logicalIndex = index - offset;
            return module;
        }
        else
        {
            offset += numberOfItems;
        }
    }
    
    return nil;
}

#pragma mark - Layout
-(CGFloat)prepareLayoutAttributes:(NSArray *)layoutAttributes withOrigin:(CGPoint)origin width:(CGFloat)width
{
    NSUInteger count = _visibleModules.count;
    NSUInteger offset = 0;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        RLModule *module = _visibleModules[i];
        NSUInteger itemCount = module.numberOfItems;
        
        // layout
        UIEdgeInsets edgeInsets = module.edgeInsets;
        origin.y += edgeInsets.top;
        origin.y = [module prepareLayoutAttributes:[layoutAttributes subarrayWithRange:NSMakeRange(offset, itemCount)]
                                        withOrigin:CGPointMake(edgeInsets.left, origin.y)
                                             width:width - edgeInsets.left - edgeInsets.right];
        origin.y += edgeInsets.bottom;
        
        // add bottom padding
        RLModule *nextModule = i + 1 < count ? _visibleModules[i + 1] : nil;
        origin.y += MAX(module.minimumBottomPadding, nextModule.minimumTopPadding);
        
        // offset
        offset += itemCount;
    }
    
    return origin.y;
}

#pragma mark - Module Data Source
-(NSInteger)numberOfItems
{
    NSInteger sum = 0;
    
    for (RLModule *childModule in _visibleModules)
    {
        sum += childModule.numberOfItems;
    }
    
    return sum;
}

#pragma mark - Views for Items
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView *)collectionView
                             withIndexPath:(NSIndexPath *)indexPath
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:indexPath.item logicalIndex:&logicalIndex];
    
    return [childModule cellForItemAtIndex:logicalIndex
                          inCollectionView:collectionView
                             withIndexPath:indexPath];
}

#pragma mark - Module Delegate
-(BOOL)module:(RLModule *)module shouldSelectItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    return [childModule shouldSelectItemAtIndex:logicalIndex];
}

-(void)module:(RLModule *)module didSelectItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    [childModule didSelectItemAtIndex:logicalIndex];
}

-(BOOL)module:(RLModule *)module shouldDeselectItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    return [childModule shouldDeselectItemAtIndex:logicalIndex];
}

-(void)module:(RLModule *)module didDeselectItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    [childModule didDeselectItemAtIndex:logicalIndex];
}

-(BOOL)module:(RLModule *)module shouldHighlightItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    return [childModule shouldHighlightItemAtIndex:logicalIndex];
}

-(void)module:(RLModule *)module didHighlightItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    [childModule didHighlightItemAtIndex:logicalIndex];
}

-(void)module:(RLModule *)module didUnhighlightItemAtIndex:(NSInteger)index
{
    NSInteger logicalIndex = 0;
    RLModule *childModule = [self childModuleAtIndex:index logicalIndex:&logicalIndex];
    [childModule didHighlightItemAtIndex:logicalIndex];
}

@end
