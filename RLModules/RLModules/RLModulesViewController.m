//
//  RLModulesViewController.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModulesCollectionViewLayout.h"
#import "RLModulesViewController.h"

@interface RLModulesViewController ()

@end

@implementation RLModulesViewController

#pragma mark - View Loading
-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    RLModulesCollectionViewLayout *layout = [RLModulesCollectionViewLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:_collectionView];
    
    self.view = view;
}

@end
