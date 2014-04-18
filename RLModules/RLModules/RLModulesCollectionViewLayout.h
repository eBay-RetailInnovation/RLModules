//
//  RLModulesCollectionViewLayout.h
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLModulesCollectionViewLayout : UICollectionViewLayout

#pragma mark - Modules
/** @name Modules */

/**
 The modules displayed by this layout.
 */
@property (nonatomic, strong) NSArray *modules;

@end
