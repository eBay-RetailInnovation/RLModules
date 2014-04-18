//
//  RLModulesViewController.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule.h"
#import "RLModulesCollectionViewLayout.h"
#import "RLModulesViewController.h"

@interface RLModulesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RLModulesViewController

#pragma mark - View Loading
-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    RLModulesCollectionViewLayout *layout = [RLModulesCollectionViewLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [view addSubview:_collectionView];
    
    self.view = view;
}

#pragma mark - Collection View Data Source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _modules.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [(RLModule*)_modules[section] numberOfItems];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    return [module.dataSource module:module cellForItemAtIndexPath:indexPath inCollectionView:collectionView];
}

@end
