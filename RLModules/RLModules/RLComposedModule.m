//
//  RLComposedModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLComposedModule.h"
#import "RLModule+Implementation.h"

@interface RLComposedModule () <RLModuleObserver>

@property (nonatomic, strong) NSArray *submodules;
@property (nonatomic, strong) NSArray *visibleSubmodules;

@end

@implementation RLComposedModule

#pragma mark - Deallocation
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Modules
-(void)setSubmodules:(NSArray *)submodules
{
    for (RLModule *module in _submodules)
    {
        [module removeModuleObserver:self];
    }
    
    _submodules = submodules;
    
    for (RLModule *module in _submodules)
    {
        [module addModuleObserver:self];
    }
    
    self.visibleSubmodules = [self visibleModulesInArray:_submodules];
}

-(NSArray*)visibleModulesInArray:(NSArray*)array
{
    NSIndexSet *set = [array indexesOfObjectsPassingTest:^BOOL(RLModule *module, NSUInteger idx, BOOL *stop) {
        return !module.hidden;
    }];
    
    return [array objectsAtIndexes:set];
}

-(void)setVisibleSubmodules:(NSArray *)visibleSubmodules
{
    _visibleSubmodules = visibleSubmodules;
    [self invalidateLayout];
}

-(void)invalidateSubmodules
{
    self.submodules = [self currentSubmodules];
}

-(NSArray*)currentSubmodules
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Module Observer
-(void)moduleContentInvalidated:(RLModule *)module
{
    if ([_visibleSubmodules containsObject:module])
    {
        [self invalidateContent];
    }
}

-(void)moduleLayoutInvalidated:(RLModule *)module
{
    if ([_visibleSubmodules containsObject:module])
    {
        [self invalidateLayout];
    }
}

-(void)module:(RLModule *)module hiddenStateChanged:(BOOL)hidden
{
    self.visibleSubmodules = [self visibleModulesInArray:_submodules];
}

#pragma mark - Child Modules
-(RLModule*)submoduleAtIndex:(NSInteger)index submoduleItemIndex:(NSInteger*)submoduleItemIndex
{
    NSInteger offset = 0;
    
    for (RLModule *module in _visibleSubmodules)
    {
        NSInteger numberOfItems = module.numberOfItems;
        
        if (offset + numberOfItems > index)
        {
            *submoduleItemIndex = index - offset;
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
    NSUInteger count = _visibleSubmodules.count;
    NSUInteger offset = 0;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        RLModule *module = _visibleSubmodules[i];
        NSUInteger itemCount = module.numberOfItems;
        
        // layout
        UIEdgeInsets edgeInsets = module.edgeInsets;
        origin.y += edgeInsets.top;
        origin.y = [module prepareLayoutAttributes:[layoutAttributes subarrayWithRange:NSMakeRange(offset, itemCount)]
                                        withOrigin:CGPointMake(edgeInsets.left, origin.y)
                                             width:width - edgeInsets.left - edgeInsets.right];
        origin.y += edgeInsets.bottom;
        
        // add bottom padding
        RLModule *nextModule = i + 1 < count ? _visibleSubmodules[i + 1] : nil;
        origin.y += MAX(module.minimumBottomPadding, nextModule.minimumTopPadding);
        
        // offset
        offset += itemCount;
    }
    
    return origin.y;
}

#pragma mark - Module State
-(NSInteger)numberOfItems
{
    NSInteger sum = 0;
    
    for (RLModule *submodule in _visibleSubmodules)
    {
        sum += submodule.numberOfItems;
    }
    
    return sum;
}

#pragma mark - Views for Items
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView *)collectionView
                             withIndexPath:(NSIndexPath *)indexPath
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:indexPath.item submoduleItemIndex:&submoduleItemIndex];
    
    return [submodule cellForItemAtIndex:submoduleItemIndex
                          inCollectionView:collectionView
                             withIndexPath:indexPath];
}

#pragma mark - Selected Items
-(BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    return [submodule shouldSelectItemAtIndex:submoduleItemIndex];
}

-(void)didSelectItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    [submodule didSelectItemAtIndex:submoduleItemIndex];
}

-(BOOL)shouldDeselectItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    return [submodule shouldDeselectItemAtIndex:submoduleItemIndex];
}

-(void)didDeselectItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    [submodule didDeselectItemAtIndex:submoduleItemIndex];
}

#pragma mark - Highlighted Items
-(BOOL)shouldHighlightItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    return [submodule shouldHighlightItemAtIndex:submoduleItemIndex];
}

-(void)didHighlightItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    [submodule didHighlightItemAtIndex:submoduleItemIndex];
}

-(void)didUnhighlightItemAtIndex:(NSInteger)index
{
    NSInteger submoduleItemIndex = 0;
    RLModule *submodule = [self submoduleAtIndex:index submoduleItemIndex:&submoduleItemIndex];
    [submodule didHighlightItemAtIndex:submoduleItemIndex];
}

@end
