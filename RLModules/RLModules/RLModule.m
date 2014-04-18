//
//  RLModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"
#import "RLModule+Private.h"
#import "RLModulesCollectionViewLayout.h"

NSString *const kRLModuleLayoutInvalidationNotification = @"kRLModuleLayoutInvalidationNotification";
NSString *const kRLModuleContentInvalidationNotification = @"kRLModuleContentInvalidationNotification";

@implementation RLModule

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kRLModuleLayoutInvalidationNotification object:self];
}

-(CGFloat)prepareLayoutAttributes:(NSArray*)layoutAttributes
                       withOrigin:(CGPoint)origin
                            width:(CGFloat)width
{
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

#pragma mark - Module State
-(void)invalidateContent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRLModuleContentInvalidationNotification object:self];
}

-(NSInteger)numberOfItems
{
    return [_dataSource numberOfItemsInModule:self];
}

@end
