//
//  RLModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLModule : NSObject

#pragma mark - Hiding
/** @name Hiding */

/** `YES` if the module is currently hidden, otherwise `NO`. */
@property (nonatomic) BOOL hidden;

#pragma mark - Background
/** @name Background */

/**
 The background color for the module.
 
 For efficiency, do not set this property to `[UIColor clearColor]`. use `nil` instead.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - Spacing
/** @name Spacing */

/**
 The inset area on the outside of the module.
 
 The `top` and `bottom` members of the `UIEdgeInsets` structure will stack with the values determined by
 `minimumTopPadding` and `minimumBottomPadding`. Generally, it's probably best to leave `top` and `bottom` at `0`, and
 use those properties instead for vertical spacing.
 */
@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 The required spacing above this module.
 
 The actual spacing will depend on the previous module's `minimumBottomPadding` value - the greater of the two values
 will be used.
 */
@property (nonatomic) CGFloat minimumTopPadding;

/**
 The required spacing below this module.
 
 The actual spacing will depend on the following module's `minimumTopPadding` value - the greater of the two values will
 be used.
 */
@property (nonatomic) CGFloat minimumBottomPadding;

@end
