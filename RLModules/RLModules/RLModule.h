//
//  RLModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLModule;

@protocol RLModuleDataSource <NSObject>

/** @name Item Counts */

/**
 Asks the data source for the number of items in the module.
 
 This message is required.
 
 @param module The module requesting this information.
 @returns The number of items in `module`.
 */
-(NSInteger)numberOfItemsInModule:(RLModule*)module;

/** @name Views for Items */

/**
 Asks the data source for a cell representing the specified index path.
 
 This message is required.
 
 @param module The module requesting this information.
 @param indexPath The index path that specifies the location of the item.
 @param collectionView The collection view containing the module.
 @returns A configured cell object. This message must not return `nil`.
 */
-(UICollectionViewCell*)module:(RLModule*)module
        cellForItemAtIndexPath:(NSIndexPath*)indexPath
              inCollectionView:(UICollectionView*)collectionView;

@end

@protocol RLModuleDelegate <NSObject>

@end

@interface RLModule : NSObject

#pragma mark - Data Source
/** @name Data Source */

/** The data source for this module. */
@property (nonatomic, weak) id<RLModuleDataSource> dataSource;

#pragma mark - Delegate
/** @name Delegate */

/** The delegate for this module. */
@property (nonatomic, weak) id<RLModuleDelegate> delegate;

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

#pragma mark - Layout Implementation
/** @name Layout Implementation */

/**
 Invalidates the current layout.
 
 Subclasses should pass this message to `self` after a property that layout depends on changes.
 */
-(void)invalidateLayout;

/**
 Prepares layout attributes for this module.
 
 Subclasses must override this message. The default implementation throws an exception.
 
 The `minimumTopPadding` and `edgeInsets` properties are already taken into account by the layout object. It should not
 be necessary to access those properties in the implementation of this message.
 
 @param layoutAttributes An array of `UICollectionViewLayoutAttributes` objects.
 @param origin The leftmost X position and topmost Y position to use for layout.
 @param width The width that should be used for the module's layout.
 @returns The maximum Y position for the layout. The `minimumBottomPadding` property and the `bottom` structure member
 of the `edgeInsets` property should not be added to this value - that is handled automatically by the layout object.
 */
-(CGFloat)prepareLayoutAttributes:(NSArray*)layoutAttributes
                       withOrigin:(CGPoint)origin
                            width:(CGFloat)width;

@end
