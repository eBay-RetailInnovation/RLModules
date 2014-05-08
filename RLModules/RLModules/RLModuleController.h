//
//  RLModuleController.h
//  RLModules
//
//  Created by Nate Stedman on 4/19/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"

FOUNDATION_EXTERN NSString *const kRLModuleControllerNilModuleException;

@interface RLModuleController : NSObject

#pragma mark - Module
/** @name Module */

/**
 The module represented by this controller.
 
 This property is lazily initialized via the `-loadModule` message.
 */
@property (nonatomic, readonly, strong) RLModule *module;

#pragma mark - Module Loading
/** @name Module Loading */

/**
 Instructs the controller to load its module.
 
 @returns A valid module object. This method may not return `nil` - an exception will be thrown.
 */
-(RLModule*)loadModule;

#pragma mark - Cell Classes
/** @name Cell Classes */

/**
 Returns an array of cell classes required by this module.
 
 This message must be implemented to use `-[RLModulesViewController registerCellClassesForModuleControllerClass:]`.
 */
+(NSArray*)requiredCellClasses;

/**
 Dequeues a cell of the specified class at the specified index path.
 
 The cell class must have been previously registered.
 
 @param klass The cell class to dequeue.
 @param indexPath The index path to dequeue at.
 @param collectionView The collection view to dequeue in.
 @returns An instance of `klass`.
 */
-(id)dequeueCellOfClass:(Class)klass
            atIndexPath:(NSIndexPath*)indexPath
       inCollectionView:(UICollectionView*)collectionView;

@end
