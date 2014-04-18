//
//  RLModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLModule;

#pragma mark - RLModuleDataSource
@protocol RLModuleDataSource <NSObject>

#pragma mark - Item Counts
/** @name Item Counts */

/**
 Asks the data source for the number of items in the module.
 
 This message is required.
 
 @param module The module requesting this information.
 @returns The number of items in `module`.
 */
-(NSInteger)numberOfItemsInModule:(RLModule*)module;

#pragma mark - Views for Items
/** @name Views for Items */

/**
 Asks the data source for a cell representing the specified index path.
 
 This message is required.
 
 @param module The module requesting this information.
 @param index The logical index for the item, within the module. Use this index to retrieve data.
 @param collectionView The collection view containing the module.
 @param indexPath The absolute index path for the item in the collection view. Use this index path to dequeue cells.
 @returns A configured cell object. This message must not return `nil`.
 */
-(UICollectionViewCell*)module:(RLModule*)module
            cellForItemAtIndex:(NSInteger)index
              inCollectionView:(UICollectionView*)collectionView
                 withIndexPath:(NSIndexPath*)indexPath;

@end

#pragma mark - RLModuleDelegate

@protocol RLModuleDelegate <NSObject>

@optional

#pragma mark - Selected Items
/** @name Selected Items */

/**
 Asks the delegate if the item at the specified index should be selected.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 @param module The module requesting this information.
 @param index The index of the item to be selected.
 @returns `YES` if the item should be selected, or `NO` if it should not.
 */
-(BOOL)module:(RLModule*)module shouldSelectItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been selected.
 
 This method will not be called when the selection is set programmatically.
 
 @param module The module sending this information.
 @param index The index of the item that has been selected.
 */
-(void)module:(RLModule*)module didSelectItemAtIndex:(NSInteger)index;

/**
 Asks the delegate if the item at the specified index should be deselected.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 @param module The module requesting this information.
 @param index The index of the item to be deselected.
 @returns `YES` if the item should be deselected, or `NO` if it should not.
 */
-(BOOL)module:(RLModule*)module shouldDeselectItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been deselected.
 
 This method will not be called when the selection is set programmatically.
 
 @param module The module sending this information.
 @param index The index of the item that has been deselected.
 */
-(void)module:(RLModule*)module didDeselectItemAtIndex:(NSInteger)index;

#pragma mark - Highlighted Items
/** @name Highlighted Items */

/**
 Asks the delegate if the item at the specified index should be highlighted.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 @param module The module requesting this information.
 @param index The index of the item to be highlighted.
 @returns `YES` if the item should be highlighted, or `NO` if it should not.
 */
-(BOOL)module:(RLModule *)module shouldHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been highlighted.
 
 @param module The module sending this information.
 @param index The index of the item that has been highlighted.
 */
-(void)module:(RLModule*)module didHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been unhighlighted.
 
 @param module The module sending this information.
 @param index The index of the item that has been unhighlighted.
 */
-(void)module:(RLModule*)module didUnhighlightItemAtIndex:(NSInteger)index;

@end

#pragma mark - RLModule

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

#pragma mark - Module State
/** @name Module State */

/**
 Indicates that the content of the module has changed, and that the module should be reloaded.
 
 Subclasses (especially meta-modules) may use this if a property changes that would alter the number of items in the
 module. Clients may use this when the model changes.
 */
-(void)invalidateContent;

/**
 Returns the number of items in the module.
 
 @returns The number of items in the module.
 */
-(NSInteger)numberOfItems;

@end
