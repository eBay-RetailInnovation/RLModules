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
