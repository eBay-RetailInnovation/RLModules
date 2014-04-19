//
//  RLMasonryModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLLayoutModule.h"

@class RLMasonryModule;

@protocol RLMasonryModuleDelegate <RLLayoutModuleDelegate>

-(CGFloat)masonryModule:(RLMasonryModule*)masonryModule heightForItemAtIndex:(NSInteger)index withWidth:(CGFloat)width;

@end

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
