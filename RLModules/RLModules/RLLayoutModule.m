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

#pragma mark - Views for Items
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView*)collectionView
                             withIndexPath:(NSIndexPath*)indexPath
{
    return [_dataSource module:self cellForItemAtIndex:index inCollectionView:collectionView withIndexPath:indexPath];
}

#pragma mark - View Selection
-(BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:shouldSelectItemAtIndex:)])
    {
        return [_delegate module:self shouldSelectItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didSelectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:didSelectItemAtIndex:)])
    {
        [_delegate module:self didSelectItemAtIndex:index];
    }
}

-(BOOL)shouldDeselectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:shouldDeselectItemAtIndex:)])
    {
        return [_delegate module:self shouldDeselectItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didDeselectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:didDeselectItemAtIndex:)])
    {
        [_delegate module:self didDeselectItemAtIndex:index];
    }
}

#pragma mark - View Highlighting
-(BOOL)shouldHighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:shouldHighlightItemAtIndex:)])
    {
        return [_delegate module:self shouldHighlightItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

-(void)didHighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:didHighlightItemAtIndex:)])
    {
        [_delegate module:self didHighlightItemAtIndex:index];
    }
}

-(void)didUnhighlightItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(module:didUnhighlightItemAtIndex:)])
    {
        [_delegate module:self didUnhighlightItemAtIndex:index];
    }
}

@end
