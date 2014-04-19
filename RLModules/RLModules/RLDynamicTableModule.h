//
//  RLDynamicTableModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/19/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLLayoutModule.h"

@class RLDynamicTableModule;

/**
 Defines additional methods for the delegates of `RLDynamicTableModule` instances.
 */
@protocol RLDynamicTableModuleDelegate <RLLayoutModuleDelegate>

@required
/** @name Required */
/**
 Requests that the delegate calculate the height for the specified item.
 
 @param dynamicTableModule The dynamic table module requesting this information.
 @param index The item index.
 @param width The content width of the module.
 @returns A row height value.
 */
-(CGFloat)dynamicTableModule:(RLDynamicTableModule*)dynamicTableModule
        heightForItemAtIndex:(NSInteger)index
                   withWidth:(CGFloat)width;

@optional
/** @name Optional */
/**
 Requests that the delegate calculate the padding after the specified item.
 
 This method is optional. If implemented, this method will override the `-[RLDynamicTableModule rowPadding]` property.
 
 @param dynamicTableModule The dynamic table module requesting this information.
 @param index The item index.
 @param width The content width of the module.
 @returns A row padding value.
 */
-(CGFloat)dynamicTableModule:(RLDynamicTableModule*)dynamicTableModule
     paddingAfterItemAtIndex:(NSInteger)index
                   withWidth:(CGFloat)width;

@end

@interface RLDynamicTableModule : RLLayoutModule

#pragma mark - Delegation
/** @name Delegation */
@property (nonatomic, weak) id<RLDynamicTableModuleDelegate> delegate;

#pragma mark - Row Padding
/** @name Row Padding */

/**
 The padding, in points, between each row.
 
 The default value for this property is `0`.
 */
@property (nonatomic) CGFloat rowPadding;

@end
