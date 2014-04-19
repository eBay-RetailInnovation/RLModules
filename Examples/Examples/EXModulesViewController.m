//
//  EXModulesViewController.m
//  Examples
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "EXModulesViewController.h"

@interface EXModulesViewController () <RLLayoutModuleDataSource, RLMasonryModuleDelegate>
{
@private
    // basic modules
    RLTableModule *_tableModule;
    RLGridModule *_gridModule;
    RLMasonryModule *_masonryModule;
    
    // header module
    RLComposedArrayModule *_composedModule;
    RLTableModule *_composedHeaderModule;
    RLGridModule *_composedContentModule;
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
    
    _masonryModule = [RLMasonryModule new];
    _masonryModule.dataSource = self;
    _masonryModule.delegate = self;
    _masonryModule.edgeInsets = edgeInsets;
    
    // header module
    _composedHeaderModule = [RLTableModule new];
    _composedHeaderModule.dataSource = self;
    _composedHeaderModule.delegate = self;
    _composedHeaderModule.rowHeight = 22;
    
    _composedContentModule = [RLGridModule new];
    _composedContentModule.dataSource = self;
    _composedContentModule.delegate = self;
    
    RLTableModule *composedHidden = [RLTableModule new];
    composedHidden.dataSource = self;
    composedHidden.delegate = self;
    composedHidden.hidden = YES;
    
    _composedModule = [RLComposedArrayModule new];
    _composedModule.modules = @[_composedHeaderModule, composedHidden, _composedContentModule];
    
    self.modules = @[_tableModule, _gridModule, _masonryModule, _composedModule];
}

#pragma mark - Module Data Source
-(NSInteger)numberOfItemsInLayoutModule:(RLLayoutModule*)layoutModule
{
    return 10;
}

-(UICollectionViewCell*)layoutModule:(RLLayoutModule*)layoutModule
                  cellForItemAtIndex:(NSInteger)index
                    inCollectionView:(UICollectionView *)collectionView
                       withIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self dequeueCellOfClass:[UICollectionViewCell class] atIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - Masonry Module Delegate
-(CGFloat)masonryModule:(RLMasonryModule *)masonryModule heightForItemAtIndex:(NSInteger)index withWidth:(CGFloat)width
{
    return 10 + 10 * (index % 3);
}

@end
