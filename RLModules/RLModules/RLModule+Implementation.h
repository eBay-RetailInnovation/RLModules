//
//  RLModule+Implementation.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

@class RLModule;

/**
 Defines optional methods for observers of RLModule instances.
 
 RLModulesViewController and RLComposedModule use this protocol internally. It should not be necessary to implement
 this protocol (if it is, RLModules is probably deficient in some way - improve it instead).
 */
@protocol RLModuleObserver <NSObject>

@optional

#pragma mark - Layout Invalidation
/** @name Layout Invalidation */

/**
 Notifies the receiver that a module's layout is invalid.
 
 @param module The invalidated module.
 */
-(void)moduleLayoutInvalidated:(RLModule*)module;

#pragma mark - Reloading Data
/** @name Reloading Data */

/**
 Notifies the receiver that a module's content should be reloaded.
 
 @param module The invalidated module.
 @param animated If the reload should be animated.
 */
-(void)module:(RLModule*)module reloadDataAnimated:(BOOL)animated;

#pragma mark - State Changes
/** @name State Changes */

/**
 Notifies the reciever that a module's hidden state has changed.
 
 @param module The module.
 @param hidden The new hidden state.
 */
-(void)module:(RLModule*)module hiddenStateChanged:(BOOL)hidden;

#pragma mark - Inserting, Moving, and Deleting Items
/** @name Inserting, Moving, and Deleting Items */

/**
 Notifies the receiver that items should be inserted into the module.
 
 @param module The module.
 @param indexes An array of indexes, represented as `NSNumber` instances.
 */
-(void)module:(RLModule *)module insertItemsAtIndexes:(NSArray*)indexes;

/**
 Notifies the receiver that items should be deleted from the module.
 
 @param module The module.
 @param indexes An array of indexes, represented as `NSNumber` instances.
 */
-(void)module:(RLModule *)module deleteItemsAtIndexes:(NSArray*)indexes;

/**
 Notifies the receiver that an item should be moved to a new index.
 
 @param module The module.
 @param fromIndex The original index of the item.
 @param toIndex The new index of the item.
 */
-(void)module:(RLModule *)module moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

#pragma mark - Scrolling an Item Into View
/** @name Scrolling an Item Into View */

/**
 Notifies the receiver that an item should be scrolled into view.
 
 @param module The module.
 @param index The index of the item.
 @param scrollPosition An option that specifies where the item should be positioned when scrolling finishes. For a list
 of possible values, see `UICollectionViewScrollPosition`.
 @param animated If `YES`, the scrolling adjustment will be animated. If `NO`, it will be immediate.
 */
-(void)module:(RLModule *)module
scrollToItemAtIndex:(NSInteger)index
atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
     animated:(BOOL)animated;

#pragma mark - Modifying Selection
/** @name Modifying Selection */

/**
 Notifies the receiver that the item at the specified index should be selected.
 
 This method does not cause any selection-related methods or delegate methods to be called.
 
 @param module The module.
 @param index The index that should be selected.
 @param animated Specify `YES` to animate the change in the selection or `NO` to make the change without animating it.
 @param scrollPosition An option that specifies where the item should be positioned when scrolling finishes. For a list
 of possible values, see `UICollectionViewScrollPosition`.
 */
-(void)module:(RLModule *)module
selectItemAtIndex:(NSInteger)index
     animated:(BOOL)animated
scrollPosition:(UICollectionViewScrollPosition)scrollPosition;

/**
 Notifies the receiver that the item at the specified index should be deselected.
 
 @param module The module.
 @param index The index to deselect.
 @param animated Specify `YES` to animate the change in the selection or `NO` to make the change without animating it.
 */
-(void)module:(RLModule *)module deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

#pragma mark -

/**
 This category provides the messages needed to implement a concrete module subclass (but not a subclass of
 RLComposedModule or RLLayoutModule - everything needed is provided in those classes).
 
 It is not included in the `RLModules.h` header file, and must be imported explicitly.
 */
@interface RLModule (Implementation)

#pragma mark - Module Observers
/** @name Module Observers */
/**
 Adds a module observer. Module observers are not retained.
 
 @param moduleObserver The module observer to add.
 */
-(void)addModuleObserver:(id<RLModuleObserver>)moduleObserver;

/**
 Removes a module observer.
 
 @param moduleObserver The module observer to remove.
 */
-(void)removeModuleObserver:(id<RLModuleObserver>)moduleObserver;

/**
 Enumerates the module's observers, passing each to the specified block.
 
 @param block A block to pass each module observer to. This parameter must not be `nil`.
 */
-(void)enumerateModuleObservers:(void(^)(id<RLModuleObserver> moduleObserver))block;

#pragma mark - Views for Items
/** @name Views for Items */

/**
 Asks the module for a cell representing the specified index path.
 
 This message must be overriden to provide a cell.
 
 @param index The logical index for the item, within the module. Use this index to retrieve data.
 @param collectionView The collection view containing the module.
 @param indexPath The absolute index path for the item in the collection view. Use this index path to dequeue cells.
 @returns A configured cell object. This message must not return `nil`.
 */
-(UICollectionViewCell*)cellForItemAtIndex:(NSInteger)index
                          inCollectionView:(UICollectionView*)collectionView
                             withIndexPath:(NSIndexPath*)indexPath;

#pragma mark - Selected Items
/** @name Selected Items */

/**
 Asks the module if the item at the specified index should be selected.
 
 The default implementation returns `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 @param index The index of the item to be selected.
 @returns `YES` if the item should be selected, or `NO` if it should not.
 */
-(BOOL)shouldSelectItemAtIndex:(NSInteger)index;

/**
 Notifies the module that the item at the specified index has been selected.
 
 This method will not be called when the selection is set programmatically.
 
 The default implementation does nothing.
 
 @param index The index of the item that has been selected.
 @param cell The collection view cell that was selected.
 */
-(void)didSelectItemAtIndex:(NSInteger)index withCell:(UICollectionViewCell*)cell;

/**
 Asks the module if the item at the specified index should be deselected.
 
 The default implementation returns `YES`.
 
 This method will not be called when the selection is set programmatically.
 
 The default implementation does nothing.
 
 @param index The index of the item to be deselected.
 @returns `YES` if the item should be deselected, or `NO` if it should not.
 */
-(BOOL)shouldDeselectItemAtIndex:(NSInteger)index;

/**
 Notifies the module that the item at the specified index has been deselected.
 
 This method will not be called when the selection is set programmatically.
 
 The default implementation does nothing.
 
 @param index The index of the item that has been deselected.
 */
-(void)didDeselectItemAtIndex:(NSInteger)index;

#pragma mark - Highlighted Items
/** @name Highlighted Items */

/**
 Asks the module if the item at the specified index should be highlighted.
 
 The default implementation returns `YES`.
 
 @param index The index of the item to be highlighted.
 @returns `YES` if the item should be highlighted, or `NO` if it should not.
 */
-(BOOL)shouldHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the module that the item at the specified index has been highlighted.
 
 The default implementation does nothing.
 
 @param index The index of the item that has been highlighted.
 */
-(void)didHighlightItemAtIndex:(NSInteger)index;

/**
 Notifies the module that the item at the specified index has been unhighlighted.
 
 The default implementation does nothing.
 
 @param index The index of the item that has been unhighlighted.
 */
-(void)didUnhighlightItemAtIndex:(NSInteger)index;

#pragma mark - Module State
/** @name Module State */

/**
 Subclasses must override this method to implement the `-[RLModule numberOfItems]` method. That method will cache the
 result until the content is invalidated.
 
 The default implementation throws an exception.
 */
-(NSInteger)calculateNumberOfItems;

/**
 Indicates that the number of items of the module has changed, and should be reloaded.
 
 Note that this message does not pass `-[RLModule reloadData]` - instead, `-[RLModule reloadData]` passes this message.
 Therefore, it is typically not necessary for clients to pass this message.
 */
-(void)invalidateNumberOfItems;

@end
