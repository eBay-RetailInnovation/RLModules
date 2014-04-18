//
//  RLModulesViewController.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLModulesViewController : UIViewController

#pragma mark - Modules
/** @name Modules */

/**
 The modules currently displayed by this view controller.
 */
@property (nonatomic, strong) NSArray *modules;

#pragma mark - Cell Classes
/** @name Cell Classes */

/**
 Registers a cell class for reuse.
 
 The reuse identifier registered is the class name.
 
 @param klass The cell class to register.
 */
-(void)registerCellClassForReuse:(Class)klass;

/**
 Registers an array of cell classes for reuse.
 
 The reuse identifier registered for each class is the class name.
 
 @param classes An array of cell classes to register.
 */
-(void)registerCellClassesForReuse:(NSArray*)classes;

/**
 Dequeues a cell of the specified class at the specified index path.
 
 The cell class must have been previously registered with `-registerCellClassForReuse`.
 
 @param klass The cell class to dequeue.
 @param indexPath The index path to dequeue at.
 @returns An instance of `klass`.
 */
-(id)dequeueCellOfClass:(Class)klass atIndexPath:(NSIndexPath*)indexPath;

#pragma mark - Collection View
/** @name Collection View */

/**
 The collection view used by this view controller.
 
 Although this property is visible, it is generally advisable to avoid using it, except in very advanced and specialized
 situations. Typically, all interaction should be done through module objects and methods of this object. If it is
 necessary to use this property, consider if the RLModules library is deficient in some way, and should instead be
 expanded to cover that use case without using direct collection view access.
 */
@property (nonatomic, readonly, strong) UICollectionView *collectionView;

@end
