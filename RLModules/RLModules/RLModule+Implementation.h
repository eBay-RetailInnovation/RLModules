//
//  RLModule+Implementation.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

FOUNDATION_EXTERN NSString *const kRLModuleLayoutInvalidationNotification;
FOUNDATION_EXTERN NSString *const kRLModuleContentInvalidationNotification;

/**
 This category provides the messages needed to implement a concrete module subclass.
 
 It is not included in the `RLModules.h` header file, and must be imported explicitly.
 */
@interface RLModule (Implementation)

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
 */
-(void)didSelectItemAtIndex:(NSInteger)index;

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

@end
