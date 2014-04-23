//
//  RLModulesViewController.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule+Implementation.h"
#import "RLModulesCollectionViewLayout.h"
#import "RLModulesViewController.h"

@interface RLModulesViewController () <RLModuleObserver, UICollectionViewDataSource, UICollectionViewDelegate>
{
@private
    RLModulesCollectionViewLayout *_collectionViewLayout;
}

@property (nonatomic, strong) NSArray *visibleModules;

@end

@implementation RLModulesViewController

#pragma mark - Deallocation
-(void)dealloc
{
    self.modules = nil;
}

#pragma mark - View Loading
-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    _collectionViewLayout = [RLModulesCollectionViewLayout new];
    _collectionViewLayout.modules = _modules;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:_collectionViewLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [view addSubview:_collectionView];
    
    self.view = view;
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    for (RLModule *module in _modules)
    {
        [module removeModuleObserver:self];
    }
    
    _modules = modules;
    
    for (RLModule *module in _modules)
    {
        [module addModuleObserver:self];
    }
    
    self.visibleModules = [self visibleModulesInArray:_modules];
}

-(NSArray*)visibleModulesInArray:(NSArray*)array
{
    NSIndexSet *set = [array indexesOfObjectsPassingTest:^BOOL(RLModule *module, NSUInteger idx, BOOL *stop) {
        return !module.hidden;
    }];
    
    return [array objectsAtIndexes:set];
}

-(void)setVisibleModules:(NSArray *)visibleModules
{
    _visibleModules = visibleModules;
    _collectionViewLayout.modules = _visibleModules;
    [_collectionView reloadData];
}

-(NSInteger)sectionForModule:(RLModule*)module
{
    return [_visibleModules indexOfObject:module];
}

-(NSArray*)indexPathsForIndexes:(NSArray*)indexes inModule:(RLModule*)module
{
    NSInteger section = [self sectionForModule:module];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:indexes.count];
    
    for (NSNumber *number in indexes)
    {
        [array addObject:[NSIndexPath indexPathForItem:number.integerValue inSection:section]];
    }
    
    return array;
}

#pragma mark - Module Observer
-(void)module:(RLModule *)module hiddenStateChanged:(BOOL)hidden
{
    self.visibleModules = [self visibleModulesInArray:_modules];
}

-(void)module:(RLModule *)module reloadDataAnimated:(BOOL)animated
{
    NSUInteger index = [_visibleModules indexOfObject:module];
    
    if (index != NSNotFound)
    {
        BOOL enabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:animated];
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
        [UIView setAnimationsEnabled:enabled];
    }
}

-(void)module:(RLModule *)module insertItemsAtIndexes:(NSArray *)indexes
{
    if ([_visibleModules containsObject:module])
    {
        [_collectionView insertItemsAtIndexPaths:[self indexPathsForIndexes:indexes inModule:module]];
    }
}

-(void)module:(RLModule *)module deleteItemsAtIndexes:(NSArray *)indexes
{
    if ([_visibleModules containsObject:module])
    {
        [_collectionView deleteItemsAtIndexPaths:[self indexPathsForIndexes:indexes inModule:module]];
    }
}

-(void)module:(RLModule *)module moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if ([_visibleModules containsObject:module])
    {
        NSInteger section = [self sectionForModule:module];
        NSIndexPath *fromPath = [NSIndexPath indexPathForItem:fromIndex inSection:section];
        NSIndexPath *toPath = [NSIndexPath indexPathForItem:toIndex inSection:section];
        
        [_collectionView moveItemAtIndexPath:fromPath toIndexPath:toPath];
    }
}

-(void)module:(RLModule *)module
scrollToItemAtIndex:(NSInteger)index
atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
     animated:(BOOL)animated
{
    if ([_visibleModules containsObject:module])
    {
        NSInteger section = [self sectionForModule:module];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
        
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

#pragma mark - Cell Classes
-(void)registerCellClassForReuse:(Class)klass
{
    [_collectionView registerClass:klass forCellWithReuseIdentifier:NSStringFromClass(klass)];
}

-(void)registerCellClassesForReuse:(NSArray*)classes
{
    for (Class klass in classes)
    {
        [self registerCellClassForReuse:klass];
    }
}

-(void)registerCellClassesForModuleControllerClass:(Class)moduleControllerClass
{
    [self registerCellClassesForReuse:[moduleControllerClass requiredCellClasses]];
}

-(id)dequeueCellOfClass:(Class)klass atIndexPath:(NSIndexPath*)indexPath
{
    return [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(klass) forIndexPath:indexPath];
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
    return [module cellForItemAtIndex:indexPath.item
                     inCollectionView:collectionView
                        withIndexPath:indexPath];
}

#pragma mark - Collection View Delegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if (module.allowsSelection)
    {
        return [module shouldSelectItemAtIndex:indexPath.item];
    }
    else
    {
        return NO;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    [module didSelectItemAtIndex:indexPath.item];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    return [module shouldDeselectItemAtIndex:indexPath.item];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    return [module didDeselectItemAtIndex:indexPath.item];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if (module.allowsSelection)
    {
        return [module shouldHighlightItemAtIndex:indexPath.item];
    }
    else
    {
        return NO;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    return [module didHighlightItemAtIndex:indexPath.item];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    return [module didUnhighlightItemAtIndex:indexPath.item];
}

@end
