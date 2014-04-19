//
//  EXModulesViewController.m
//  Examples
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "EXModulesViewController.h"

@interface EXModulesViewController () <RLLayoutModuleDataSource, RLLayoutModuleDelegate>
{
@private
    // basic module
    RLTableModule *_tableModule;
    RLGridModule *_gridModule;
    
    // header module
    RLUnionModule *_unionModule;
    RLTableModule *_unionHeaderModule;
    RLGridModule *_unionContentModule;
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
    
    // basic modules
    _tableModule = [RLTableModule new];
    _tableModule.dataSource = self;
    _tableModule.delegate = self;
    _tableModule.edgeInsets = edgeInsets;
    
    _gridModule = [RLGridModule new];
    _gridModule.dataSource = self;
    _gridModule.delegate = self;
    _gridModule.edgeInsets = edgeInsets;
    
    // header module
    _unionHeaderModule = [RLTableModule new];
    _unionHeaderModule.dataSource = self;
    _unionHeaderModule.delegate = self;
    _unionHeaderModule.rowHeight = 22;
    
    _unionContentModule = [RLGridModule new];
    _unionContentModule.dataSource = self;
    _unionContentModule.delegate = self;
    
    RLTableModule *unionHidden = [RLTableModule new];
    unionHidden.dataSource = self;
    unionHidden.delegate = self;
    unionHidden.hidden = YES;
    
    _unionModule = [RLUnionModule new];
    _unionModule.modules = @[_unionHeaderModule, unionHidden, _unionContentModule];
    
    self.modules = @[_tableModule, _gridModule, _unionModule];
}

#pragma mark - Module Data Source
-(NSInteger)numberOfItemsInModule:(RLModule *)module
{
    return 10;
}

-(UICollectionViewCell*)module:(RLModule *)module
            cellForItemAtIndex:(NSInteger)index
              inCollectionView:(UICollectionView *)collectionView
                 withIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self dequeueCellOfClass:[UICollectionViewCell class] atIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
