//
//  RLMasonryModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLLayoutModule.h"

@class RLMasonryModule;

/**
 Defines an additional method required by the delegates of RLMasonryModule instances.
 */
@protocol RLMasonryModuleDelegate <RLLayoutModuleDelegate>

/**
 Instructs the delegate to determine the height for an item in the masonry module.
 
 @param masonryModule The masonry module asking for this information.
 @param index The index of the item in the masonry module.
 @param width The width of the column in the masonry module.
 */
-(CGFloat)masonryModule:(RLMasonryModule*)masonryModule heightForItemAtIndex:(NSInteger)index withWidth:(CGFloat)width;

@end

/**
 A masonry grid module. Items are arranged in columns, and may vary in height. Items are placed in order, with each
 sequential item being placed into the shortest column.
 */
@interface RLMasonryModule : RLLayoutModule

#pragma mark - Delegate
/** @name Delegate */

/** The delegate for this masonry module. */
@property (nonatomic, weak) id<RLMasonryModuleDelegate> delegate;

#pragma mark - Layout Properties

/**
 The padding between each column or row, in points.
 
 The default value for this property is `10` in both dimensions.
 */
@property (nonatomic) CGSize innerPadding;

/**
 The number of columns in each row.
 
 The default value for this property is `2`.
 */
@property (nonatomic) NSUInteger numberOfColumns;

@end
