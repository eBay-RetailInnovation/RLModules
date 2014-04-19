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
