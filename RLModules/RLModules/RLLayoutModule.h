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
 */
-(void)layoutModule:(RLLayoutModule*)layoutModule didSelectItemAtIndex:(NSInteger)index;

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

#pragma mark - Data Source
/** @name Data Source */

/** The data source for this layout module. */
@property (nonatomic, weak) id<RLLayoutModuleDataSource> dataSource;

#pragma mark - Delegate
/** @name Delegate */

/** The delegate for this layout module. */
@property (nonatomic, weak) id<RLLayoutModuleDelegate> delegate;

@end
