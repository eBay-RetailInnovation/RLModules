//
//  RLAutoGridModule.h
//  RLModules
//
//  Created by Nate Stedman on 7/16/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLLayoutModule.h"

/**
 A module which automatically determines the number of grid items that should be placed in each row.
 */
@interface RLAutoGridModule : RLLayoutModule

#pragma mark - Layout Properties
/** @name Layout Properties */

/**
 The size of each grid tile.
 
 The default value for this property is `100` in both dimensions.
 */
@property (nonatomic) CGSize tileSize;

/**
 The padding between each column or row, in points.
 
 The default value for this property is `10` in both dimensions.
 */
@property (nonatomic) CGSize innerPadding;

@end
