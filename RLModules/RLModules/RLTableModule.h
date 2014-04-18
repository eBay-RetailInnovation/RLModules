//
//  RLTableModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

/**
 A layout module which places views sequentially vertically. Every row has the same height.
 */
@interface RLTableModule : RLModule

#pragma mark - Row Height
/** @name Row Height */

/**
 The height, in points, of each row.
 
 The default value for this property is `44`.
 */
@property (nonatomic) CGFloat rowHeight;

@end
