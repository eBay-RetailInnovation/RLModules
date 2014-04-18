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

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hidden"] && [_modules containsObject:object])
    {
        self.visibleModules = [self visibleModulesInArray:_modules];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    for (RLModule *module in modules)
    {
        [module removeObserver:self forKeyPath:@"hidden"];
    }
    
    _modules = modules;
    
    for (RLModule *module in modules)
    {
        [module addObserver:self forKeyPath:@"hidden" options:0 context:NULL];
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
    return [module.dataSource module:module cellForItemAtIndexPath:indexPath inCollectionView:collectionView];
}

#pragma mark - Collection View Delegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:shouldSelectItemAtIndex:)])
    {
        return [module.delegate module:module shouldSelectItemAtIndex:indexPath.item];
    }
    else
    {
        return YES;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:didSelectItemAtIndex:)])
    {
        [module.delegate module:module didSelectItemAtIndex:indexPath.item];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:shouldDeselectItemAtIndex:)])
    {
        return [module.delegate module:module shouldDeselectItemAtIndex:indexPath.item];
    }
    else
    {
        return YES;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:didDeselectItemAtIndex:)])
    {
        [module.delegate module:module didDeselectItemAtIndex:indexPath.item];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:shouldHighlightItemAtIndex:)])
    {
        return [module.delegate module:module shouldHighlightItemAtIndex:indexPath.item];
    }
    else
    {
        return YES;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:didHighlightItemAtIndex:)])
    {
        [module.delegate module:module didHighlightItemAtIndex:indexPath.item];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLModule *module = _modules[indexPath.section];
    
    if ([module.delegate respondsToSelector:@selector(module:didUnhighlightItemAtIndex:)])
    {
        [module.delegate module:module didUnhighlightItemAtIndex:indexPath.item];
    }
}

@end
