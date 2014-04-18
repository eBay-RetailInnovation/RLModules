//
//  RLGridModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

/**
 A module which places its views in rows and columns of equal widths and heights.
 */
@interface RLGridModule : RLModule

#pragma mark - Layout Properties
/** @name Layout Properties */

/**
 The height, in points, of each row.
 
 The default value for this property is `145`.
 */
@property (nonatomic) CGFloat rowHeight;

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
