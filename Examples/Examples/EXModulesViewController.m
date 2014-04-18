//
//  EXModulesViewController.m
//  Examples
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "EXModulesViewController.h"

@interface EXModulesViewController () <RLModuleDataSource, RLModuleDelegate>
{
@private
    RLTableModule *_tableModule;
    RLGridModule *_gridModule;
}

@end

@implementation EXModulesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // cell reuse
    [self registerCellClassForReuse:[UICollectionViewCell class]];
    
    // modules
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _tableModule = [RLTableModule new];
    _tableModule.dataSource = self;
    _tableModule.delegate = self;
    _tableModule.edgeInsets = edgeInsets;
    
    _gridModule = [RLGridModule new];
    _gridModule.dataSource = self;
    _gridModule.delegate = self;
    _gridModule.edgeInsets = edgeInsets;
    
    self.modules = @[_tableModule, _gridModule];
}

#pragma mark - Module Data Source
-(NSInteger)numberOfItemsInModule:(RLModule *)module
{
    return 10;
}

-(UICollectionViewCell*)module:(RLModule *)module
        cellForItemAtIndexPath:(NSIndexPath *)indexPath
              inCollectionView:(UICollectionView *)collectionView
{
    UICollectionViewCell *cell = [self dequeueCellOfClass:[UICollectionViewCell class] atIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
