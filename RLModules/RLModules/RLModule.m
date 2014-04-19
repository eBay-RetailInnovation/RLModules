//
//  RLModule.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"
#import "RLModule+Implementation.h"
#import "RLModulesCollectionViewLayout.h"

@interface RLModule ()
{
@private
    NSHashTable *_moduleObservers;
}

@end

@implementation RLModule

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _moduleObservers = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

#pragma mark - Hiding
-(void)setHidden:(BOOL)hidden
{
    if (_hidden != hidden)
    {
        _hidden = hidden;
        
        [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
            if ([moduleObserver respondsToSelector:@selector(module:hiddenStateChanged:)])
            {
                [moduleObserver module:self hiddenStateChanged:_hidden];
            }
        }];
    }
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
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(moduleLayoutInvalidated:)])
        {
            [moduleObserver moduleLayoutInvalidated:self];
        }
    }];
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
    [self enumerateModuleObservers:^(id<RLModuleObserver> moduleObserver) {
        if ([moduleObserver respondsToSelector:@selector(moduleContentInvalidated:)])
        {
            [moduleObserver moduleContentInvalidated:self];
        }
    }];
}

-(NSInteger)numberOfItems
{
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

@end

@implementation RLModule (Implementation)

#pragma mark - Module Observers
-(void)addModuleObserver:(id<RLModuleObserver>)moduleObserver
{
    [_moduleObservers addObject:moduleObserver];
}

-(void)removeModuleObserver:(id<RLModuleObserver>)moduleObserver
{
    [_moduleObservers removeObject:moduleObserver];
}

-(void)enumerateModuleObservers:(void(^)(id<RLModuleObserver> moduleObserver))block
{
    for (id<RLModuleObserver> moduleObserver in _moduleObservers)
    {
        block(moduleObserver);
    }
}

#pragma mark - Views for Items
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView*)collectionView
                             withIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

#pragma mark - Selected Items
-(BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

-(void)didSelectItemAtIndex:(NSInteger)index
{
}

-(BOOL)shouldDeselectItemAtIndex:(NSInteger)index
{
    return YES;
}

-(void)didDeselectItemAtIndex:(NSInteger)index
{
}

#pragma mark - Highlighted Items
-(BOOL)shouldHighlightItemAtIndex:(NSInteger)index
{
    return YES;
}

-(void)didHighlightItemAtIndex:(NSInteger)index
{
}

-(void)didUnhighlightItemAtIndex:(NSInteger)index
{
}

@end
