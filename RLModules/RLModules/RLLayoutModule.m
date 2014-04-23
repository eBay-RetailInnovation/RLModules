//
//  RLLayoutModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLLayoutModule.h"
#import "RLModule+Implementation.h"

@implementation RLLayoutModule

#pragma mark - Inserting, Moving, and Deleting Items
-(void)insertItemsAtIndexes:(NSArray*)indexes
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:insertItemsAtIndexes:)])
        {
            [moduleObserver module:self insertItemsAtIndexes:indexes];
        }
    }];
}

-(void)deleteItemsAtIndexes:(NSArray*)indexes
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:deleteItemsAtIndexes:)])
        {
            [moduleObserver module:self deleteItemsAtIndexes:indexes];
        }
    }];
}

-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:moveItemAtIndex:toIndex:)])
        {
            [moduleObserver module:self moveItemAtIndex:fromIndex toIndex:toIndex];
        }
    }];
}

#pragma mark - Scrolling an Item Into View
-(void)scrollToItemAtIndex:(NSInteger)index
          atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                  animated:(BOOL)animated
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:scrollToItemAtIndex:atScrollPosition:animated:)])
        {
            [moduleObserver module:self scrollToItemAtIndex:index atScrollPosition:scrollPosition animated:animated];
        }
    }];
}

#pragma mark - Modifying Selection
-(void)selectItemAtIndex:(NSInteger)index
                animated:(BOOL)animated
          scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:selectItemAtIndex:animated:scrollPosition:)])
        {
            [moduleObserver module:self selectItemAtIndex:index animated:animated scrollPosition:scrollPosition];
        }
    }];
}

-(void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(module:deselectItemAtIndex:animated:)])
        {
            [moduleObserver module:self deselectItemAtIndex:index animated:animated];
        }
    }];
}

#pragma mark - Module State
-(NSInteger)calculateNumberOfItems
{
    return [_dataSource numberOfItemsInLayoutModule:self];
}

#pragma mark - Views for Items
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView*)collectionView
                             withIndexPath:(NSIndexPath*)indexPath
{
    return [_dataSource layoutModule:self
                  cellForItemAtIndex:index
                    inCollectionView:collectionView
                       withIndexPath:indexPath];
}

#pragma mark - View Selection
-(BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:shouldSelectItemAtIndex:)])
    {
        return [_delegate layoutModule:self shouldSelectItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didSelectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:didSelectItemAtIndex:)])
    {
        [_delegate layoutModule:self didSelectItemAtIndex:index];
    }
}

-(BOOL)shouldDeselectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:shouldDeselectItemAtIndex:)])
    {
        return [_delegate layoutModule:self shouldDeselectItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didDeselectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:didDeselectItemAtIndex:)])
    {
        [_delegate layoutModule:self didDeselectItemAtIndex:index];
    }
}

#pragma mark - View Highlighting
-(BOOL)shouldHighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:shouldHighlightItemAtIndex:)])
    {
        return [_delegate layoutModule:self shouldHighlightItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didHighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:didHighlightItemAtIndex:)])
    {
        [_delegate layoutModule:self didHighlightItemAtIndex:index];
    }
}

-(void)didUnhighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(layoutModule:didUnhighlightItemAtIndex:)])
    {
        [_delegate layoutModule:self didUnhighlightItemAtIndex:index];
    }
}

@end
