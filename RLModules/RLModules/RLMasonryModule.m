//
//  RLMasonryModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLMasonryModule.h"

@implementation RLMasonryModule

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _numberOfColumns = 2;
        _innerPadding = CGSizeMake(10, 10);
    }
    
    return self;
}

#pragma mark - Delegate
@dynamic delegate;

-(void)setDelegate:(id<RLMasonryModuleDelegate>)delegate
{
    [super setDelegate:delegate];
    [self invalidateLayout];
}

#pragma mark - Layout Properties
-(void)setNumberOfColumns:(NSUInteger)numberOfColumns
{
    _numberOfColumns = numberOfColumns;
    [self invalidateLayout];
}

-(void)setInnerPadding:(CGSize)innerPadding
{
    _innerPadding = innerPadding;
    [self invalidateLayout];
}

#pragma mark - Layout Implementation
-(CGFloat)prepareLayoutAttributes:(NSArray *)layoutAttributes withOrigin:(CGPoint)origin width:(CGFloat)width
{
    // calculate tile width
    CGFloat tileWidth = (width - _innerPadding.width * (_numberOfColumns - 1)) / _numberOfColumns;
    
    // y offsets
    CGFloat *yOffsets = calloc(_numberOfColumns, sizeof(CGFloat));
    
    // prepare layout attribute frames
    NSUInteger count = layoutAttributes.count;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        // calculate height in the delegate
        CGFloat height = [self.delegate masonryModule:self heightForItemAtIndex:i withWidth:tileWidth];
        
        // find the lowest (highest, geometry-wise) row
        CGFloat minValue = yOffsets[0];
        NSUInteger minIndex = 0;
        
        for (NSUInteger i = 1; i < _numberOfColumns; i++)
        {
            if (yOffsets[i] < minValue)
            {
                minValue = yOffsets[i];
                minIndex = i;
            }
        }
        
        // update attributes
        UICollectionViewLayoutAttributes *attrs = layoutAttributes[i];
        
        attrs.frame = CGRectMake(origin.x + minIndex * (tileWidth + _innerPadding.width),
                                 origin.y + yOffsets[minIndex],
                                 tileWidth,
                                 height);
        
        // update offset
        yOffsets[minIndex] += height + _innerPadding.height;
    }
    
    // calculate bottom Y position for module
    CGFloat maxYOffset = yOffsets[0];
    
    for (NSUInteger i = 1; i < _numberOfColumns; i++)
    {
        maxYOffset = MAX(maxYOffset, yOffsets[i]);
    }
    
    return origin.y + maxYOffset;
}

@end
