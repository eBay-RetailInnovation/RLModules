//
//  RLAutoGridModule.m
//  RLModules
//
//  Created by Nate Stedman on 7/16/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLAutoGridModule.h"

@implementation RLAutoGridModule

-(id)init
{
    self = [super init];
    
    if (self)
    {
        _tileSize = CGSizeMake(100, 100);
        _innerPadding = CGSizeMake(10, 10);
    }
    
    return self;
}

#pragma mark - Layout Properties
-(void)setTileSize:(CGSize)tileSize
{
    _tileSize = tileSize;
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
    // calculate number of columns
    NSUInteger numberOfColumns = 1;
    for (; numberOfColumns * _tileSize.width + (numberOfColumns - 1) * _innerPadding.width < width; numberOfColumns++);
    
    // prepare layout attribute frames
    NSUInteger count = layoutAttributes.count;
    for (NSUInteger i = 0; i < count; i++)
    {
        NSInteger row = i / numberOfColumns, column = i % numberOfColumns;
        UICollectionViewLayoutAttributes *attrs = layoutAttributes[i];
        
        attrs.frame = CGRectMake(origin.x + column * (_tileSize.width + _innerPadding.width),
                                 origin.y + row * (_tileSize.height + _innerPadding.height),
                                 _tileSize.width,
                                 _tileSize.height);
    }
    
    // calculate bottom Y position for module
    NSInteger rowCount = (count + numberOfColumns - 1) / numberOfColumns;
    return origin.y + MAX(0, rowCount * _tileSize.height + (rowCount - 1) * _innerPadding.height);
}

@end
