//
//  RLGridModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLGridModule.h"

@implementation RLGridModule

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _rowHeight = 145;
        _numberOfColumns = 2;
        _innerPadding = CGSizeMake(10, 10);
    }
    
    return self;
}

#pragma mark - Layout Properties
-(void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self invalidateLayout];
}

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
    
    // prepare layout attribute frames
    NSUInteger count = layoutAttributes.count;
    for (NSUInteger i = 0; i < count; i++)
    {
        NSInteger row = i / _numberOfColumns, column = i % _numberOfColumns;
        UICollectionViewLayoutAttributes *attrs = layoutAttributes[i];
        
        attrs.frame = CGRectMake(origin.x + column * (tileWidth + _innerPadding.width),
                                 origin.y + row * (_rowHeight + _innerPadding.height),
                                 tileWidth,
                                 _rowHeight);
    }
    
    // calculate bottom Y position for module
    NSInteger rowCount = (count + _numberOfColumns - 1) / _numberOfColumns;
    return origin.y + rowCount * _rowHeight + (rowCount - 1) * _innerPadding.height;
}

@end
