//
//  RLDynamicTableModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/19/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLDynamicTableModule.h"

@implementation RLDynamicTableModule

#pragma mark - Delegate
@dynamic delegate;

-(void)setDelegate:(id<RLDynamicTableModuleDelegate>)delegate
{
    [super setDelegate:delegate];
    [self invalidateLayout];
}

#pragma mark - Row Padding
-(void)setRowPadding:(CGFloat)rowPadding
{
    _rowPadding = rowPadding;
    
    if (![self.delegate respondsToSelector:@selector(dynamicTableModule:paddingAfterItemAtIndex:withWidth:)])
    {
        [self invalidateLayout];
    }
}

#pragma mark - Layout Implementation
-(CGFloat)prepareLayoutAttributes:(NSArray *)layoutAttributes withOrigin:(CGPoint)origin width:(CGFloat)width
{
    BOOL dynamicPadding = [self.delegate respondsToSelector:@selector(dynamicTableModule:paddingAfterItemAtIndex:withWidth:)];
    
    NSInteger index = 0;
    for (UICollectionViewLayoutAttributes *attrs in layoutAttributes)
    {
        CGFloat height = [self.delegate dynamicTableModule:self heightForItemAtIndex:index withWidth:width];
        attrs.frame = CGRectMake(origin.x, origin.y, width, height);
        
        CGFloat padding = dynamicPadding ? [self.delegate dynamicTableModule:self
                                                     paddingAfterItemAtIndex:index
                                                                   withWidth:width] : _rowPadding;
        
        origin.y += height + padding;
        index++;
    }
    
    return origin.y;
}

@end
