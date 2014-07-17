//
//  RLLayoutModule.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@class RLLayoutModule;

#pragma mark - RLLayoutModuleDataSource
/**
 Defines messages required by the data source of an RLLayoutModule instance.
 */
@protocol RLLayoutModuleDataSource <NSObject>

#pragma mark - Item Counts
/** @name Item Counts */

/**
 Asks the data source for the number of items in the module.
 
 This message is required.
 
 @param layoutModule The layout module requesting this information.
 @returns The number of items in `module`.
 */
-(NSInteger)numberOfItemsInLayoutModule:(RLLayoutModule*)layoutModule;

#pragma mark - Views for Items
/** @name Views for Items */

/**
 Asks the data source for a cell representing the specified index path.
 
 This message is required.
 
 @param layoutModule The layout module requesting this information.
 @param index The logical index for the item, within the module. Use this index to retrieve data.
 @param collectionView The collection view containing the module.
 @param indexPath The absolute index path for the item in the collection view. Use this index path to dequeue cells.
 @returns A configured cell object. This message must not return `nil`.
 */
-(UICollectionViewCell*)layoutModule:(RLLayoutModule*)layoutModule
                  cellForItemAtIndex:(NSInteger)index
                    inCollectionView:(UICollectionView*)collectionView
                       withIndexPath:(NSIndexPath*)indexPath;

@end

#pragma mark - RLLayoutModuleDelegate
/**
 Defines optional messages, providing notifications about or giving control over behavior of an RLLayoutModule instance.
 */
@protocol RLLayoutModuleDelegate <NSObject>

@optional

#pragma mark - Selected Items
/** @name Selected Items */

/**
 Asks the delegate if the item at the specified index should be selected.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 @param layoutModule The layout module requesting this information.
 @param index The index of the item to be selected.
 @returns `YES` if the item should be selected, or `NO` if it should not.
 */
-(BOOL)layoutModule:(RLLayoutModule*)layoutModule shouldSelectItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been selected.
 
 This method will not be called when the selection is set programmatically.
 
 @param layoutModule The layout module sending this information.
 @param index The index of the item that has been selected.
 @param cell The collection view cell that was selected.
 */
-(void)layoutModule:(RLLayoutModule*)layoutModule didSelectItemAtIndex:(NSInteger)index withCell:(UICollectionViewCell*)cell;

/**
 Asks the delegate if the item at the specified index should be deselected.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 @param layoutModule The layout module requesting this information.
 @param index The index of the item to be deselected.
 @returns `YES` if the item should be deselected, or `NO` if it should not.
 */
-(BOOL)layoutModule:(RLLayoutModule*)layoutModule shouldDeselectItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been deselected.
 
 This method will not be called when the selection is set programmatically.
 
 @param layoutModule The layout module sending this information.
 @param index The index of the item that has been deselected.
 */
-(void)layoutModule:(RLLayoutModule*)layoutModule didDeselectItemAtIndex:(NSInteger)index;

#pragma mark - Highlighted Items
/** @name Highlighted Items */

/**
 Asks the delegate if the item at the specified index should be highlighted.
 
 If this method is not implemented, the implicit return value is `YES`.
 
 @param layoutModule The layout module requesting this information.
 @param index The index of the item to be highlighted.
 @returns `YES` if the item should be highlighted, or `NO` if it should not.
 */
-(BOOL)layoutModule:(RLLayoutModule*)layoutModule shouldHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been highlighted.
 
 @param layoutModule The layout module sending this information.
 @param index The index of the item that has been highlighted.
 */
-(void)layoutModule:(RLLayoutModule*)layoutModule didHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the delegate that the item at the specified index has been unhighlighted.
 
 @param layoutModule The layout module sending this information.
 @param index The index of the item that has been unhighlighted.
 */
-(void)layoutModule:(RLLayoutModule*)layoutModule didUnhighlightItemAtIndex:(NSInteger)index;

@end

#pragma mark - RLLayoutModule
/**
 An abstract base class for a module whose data is provided by a data source, and which provides delegate messages for
 behavior customization and notifications.
 
 This class does not implement [RLModule prepareLayoutAttributes:withOrigin:width:]. Subclasses must override that
 message to avoid an exception being thrown.
 */
@interface RLLayoutModule : RLModule

#pragma mark - Initialization
/** @name Initialization */

/**
 Returns an initalized module, with `dataSource` and `delegate` set to the object passed in.

 @param target An object implementing `RLLayoutModuleDelegate` and `RLLayoutModuleDelegate`, which the new module's
               `dataSource` and `delegate` properties will be set to.

 @return An initalized layut module.
*/
+(instancetype)moduleWithTarget:(id<RLLayoutModuleDataSource,RLLayoutModuleDelegate>)target;

#pragma mark - Data Source
/** @name Data Source */

/** The data source for this layout module. */
@property (nonatomic, weak) id<RLLayoutModuleDataSource> dataSource;

#pragma mark - Delegate
/** @name Delegate */

/** The delegate for this layout module. */
@property (nonatomic, weak) id<RLLayoutModuleDelegate> delegate;

#pragma mark - Inserting, Moving, and Deleting Items
/** @name Inserting, Moving, and Deleting Items */

/**
 Inserts one or more new items into the layout module.
 
 @param indexes An array of indexes, represented as `NSNumber` instances. This parameter must not be `nil`.
 */
-(void)insertItemsAtIndexes:(NSArray*)indexes;

/**
 Deletes one or more items from the layout module.
 
 @param indexes An array of indexes, represented as `NSNumber` instances. This parameter must not be `nil`.
 */
-(void)deleteItemsAtIndexes:(NSArray*)indexes;

/**
 Moves an item from one location to another in the layout module.
 
 @param fromIndex The original index of the item.
 @param toIndex The new index of the item.
 */
-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

#pragma mark - Scrolling an Item Into View
/** @name Scrolling an Item Into View */

/**
 Scrolls the view contents until the item at the specified index is visible.
 
 @param index The index of the item.
 @param scrollPosition An option that specifies where the item should be positioned when scrolling finishes. For a list
 of possible values, see `UICollectionViewScrollPosition`.
 @param animated If `YES`, the scrolling adjustment will be animated. If `NO`, it will be immediate.
 */
-(void)scrollToItemAtIndex:(NSInteger)index
          atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                  animated:(BOOL)animated;

#pragma mark - Modifying Selection
/** @name Modifying Selection */

/**
 Selects the item at the specified index and optionally scrolls it into view.
 
 This method does not cause any selection-related methods or delegate methods to be called.
 
 @param index The index that should be selected.
 @param animated Specify `YES` to animate the change in the selection or `NO` to make the change without animating it.
 @param scrollPosition An option that specifies where the item should be positioned when scrolling finishes. For a list
 of possible values, see `UICollectionViewScrollPosition`.
 */
-(void)selectItemAtIndex:(NSInteger)index
                animated:(BOOL)animated
          scrollPosition:(UICollectionViewScrollPosition)scrollPosition;

/**
 Deselects the item at the specified index.
 
 @param index The index to deselect.
 @param animated Specify `YES` to animate the change in the selection or `NO` to make the change without animating it.
 */
-(void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
