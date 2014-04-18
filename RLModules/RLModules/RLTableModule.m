//
//  RLTableModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLTableModule.h"

@implementation RLTableModule

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _rowHeight = 44;
    }
    
    return self;
}

#pragma mark - Row Height
-(void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self invalidateLayout];
}

#pragma mark - Layout Implementation
-(CGFloat)prepareLayoutAttributes:(NSArray *)layoutAttributes withOrigin:(CGPoint)origin width:(CGFloat)width
{
    for (UICollectionViewLayoutAttributes *attrs in layoutAttributes)
    {
        attrs.frame = CGRectMake(origin.x, origin.y, width, _rowHeight);
        origin.y += _rowHeight;
    }
    
    return origin.y;
}

@end
