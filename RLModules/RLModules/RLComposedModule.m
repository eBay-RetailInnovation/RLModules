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
    [self invalidateNumberOfItems];
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
-(void)module:(RLModule *)module reloadDataAnimated:(BOOL)animated
{
    if ([_visibleSubmodules containsObject:module])
    {
        [self reloadDataAnimated:animated];
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

-(void)module:(RLModule *)module insertItemsAtIndexes:(NSArray *)indexes
{
    if ([self.visibleSubmodules containsObject:module])
    {
        NSArray *translated = [self translateIndexes:indexes fromModule:module];
        
        [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
            if ([moduleObserver respondsToSelector:@selector(module:insertItemsAtIndexes:)])
            {
                [moduleObserver module:self insertItemsAtIndexes:translated];
            }
        }];
    }
}

-(void)module:(RLModule *)module deleteItemsAtIndexes:(NSArray *)indexes
{
    if ([self.visibleSubmodules containsObject:module])
    {
        NSArray *translated = [self translateIndexes:indexes fromModule:module];
        
        [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
            if ([moduleObserver respondsToSelector:@selector(module:deleteItemsAtIndexes:)])
            {
                [moduleObserver module:self deleteItemsAtIndexes:translated];
            }
        }];
    }
}

-(void)module:(RLModule *)module moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if ([self.visibleSubmodules containsObject:module])
    {
        NSUInteger offset = [self offsetForModule:module];
        
        [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
            if ([moduleObserver respondsToSelector:@selector(module:moveItemAtIndex:toIndex:)])
            {
                [moduleObserver module:self moveItemAtIndex:fromIndex + offset toIndex:toIndex + offset];
            }
        }];
    }
}

-(void)module:(RLModule *)module
scrollToItemAtIndex:(NSInteger)index
atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
     animated:(BOOL)animated
{
    if ([_visibleSubmodules containsObject:module])
    {
        NSInteger new = index + [self offsetForModule:module];
        
        [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
            if ([moduleObserver respondsToSelector:@selector(module:scrollToItemAtIndex:atScrollPosition:animated:)])
            {
                [moduleObserver module:self scrollToItemAtIndex:new atScrollPosition:scrollPosition animated:animated];
            }
        }];
    }
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

-(NSUInteger)offsetForModule:(RLModule*)module
{
    NSUInteger index = [self.visibleSubmodules indexOfObject:module];
    
    if (index != NSNotFound)
    {
        NSInteger offset = 0;
        
        for (NSUInteger i = 0; i < index; i++)
        {
            offset += [(RLModule*)self.visibleSubmodules[i] numberOfItems];
        }
        
        return offset;
    }
    else
    {
        return NSNotFound;
    }
}

-(NSArray*)translateIndexes:(NSArray*)indexes fromModule:(RLModule*)module
{
    NSUInteger offset = [self offsetForModule:module];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:indexes.count];
    
    for (NSNumber *number in indexes)
    {
        [array addObject:@(number.unsignedIntegerValue + offset)];
    }
    
    return array;
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
                                        withOrigin:CGPointMake(origin.x + edgeInsets.left, origin.y)
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
-(NSInteger)calculateNumberOfItems
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
