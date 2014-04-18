//
//  RLModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@implementation RLModule

#pragma mark - Hiding
-(void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    [self invalidateLayout];
}

#pragma mark - Background
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self invalidateLayout];
}

#pragma mark - Spacing
-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self invalidateLayout];
}

-(void)setMinimumTopPadding:(CGFloat)minimumTopPadding
{
    _minimumTopPadding = minimumTopPadding;
    [self invalidateLayout];
}

-(void)setMinimumBottomPadding:(CGFloat)minimumBottomPadding
{
    _minimumBottomPadding = minimumBottomPadding;
    [self invalidateLayout];
}

#pragma mark - Layout Implementation
-(void)invalidateLayout
{
    // TODO: implement
}

@end
