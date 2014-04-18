//
//  RLModulesCollectionViewLayout.m
//  RLModules
//
//  Created by Nate Stedman on 4/18/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#import "RLModule+Private.h"
#import "RLModulesCollectionViewLayout.h"

typedef id(^RLModulesCollectionViewLayoutMapToIntegerBlock)(NSUInteger i);
static NSArray* RLModulesCollectionViewLayoutMapToInteger(NSUInteger integer, RLModulesCollectionViewLayoutMapToIntegerBlock block)
{
    if (integer > 0)
    {
        __autoreleasing id* mapped = (__autoreleasing id*)malloc(sizeof(id) * integer);
        
        for (NSUInteger i = 0; i < integer; i++)
            mapped[i] = block(i);
        
        NSArray* array = [NSArray arrayWithObjects:mapped count:integer];
        free(mapped);
        return array;
    }
    else return @[];
}

@interface RLModulesCollectionViewLayout ()
{
@private
    // layout state
    CGFloat *_yOffsets;
    CGSize _contentSize;
    
    // content layout attributes
    NSArray *_sectionedLayoutAttributes;
}

@end

@implementation RLModulesCollectionViewLayout

#pragma mark - Deallocation
-(void)dealloc
{
    self.modules = nil;
    free(_yOffsets);
}

#pragma mark - Modules
-(void)setModules:(NSArray *)modules
{
    for (RLModule *module in _modules)
    {
        module.collectionViewLayout = nil;
    }
    
    _modules = modules;
    
    for (RLModule *module in _modules)
    {
        module.collectionViewLayout = self;
    }
}

#pragma mark - Content Size
-(CGSize)collectionViewContentSize
{
    return _contentSize;
}

#pragma mark - Layout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect old = self.collectionView.bounds;
    return old.size.width != newBounds.size.width;
}

-(void)prepareLayout
{
    // setup variables
    UICollectionView *collectionView = self.collectionView;
    NSInteger sectionCount = collectionView.numberOfSections;
    
    if (sectionCount > 0)
    {
        // more variables
        CGFloat width = collectionView.bounds.size.width;
        __block CGFloat yOffset = 0;
        
        // update y offsets array
        _yOffsets = realloc(_yOffsets, sizeof(CGFloat) * sectionCount);
        
        // build array of sections
        _sectionedLayoutAttributes = RLModulesCollectionViewLayoutMapToInteger(sectionCount, ^id(NSUInteger section) {
            // information about this section
            RLModule *module = _modules[section];
            NSInteger itemCount = [collectionView numberOfItemsInSection:section];
            _yOffsets[section] = yOffset;
            
            // build an array of layout attributes for this section
            NSArray *layoutAttributes = RLModulesCollectionViewLayoutMapToInteger(itemCount, ^id(NSUInteger item) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForCellWithIndexPath:path];
                return attributes;
            });
            
            // layout
            UIEdgeInsets edgeInsets = module.edgeInsets;
            yOffset += edgeInsets.top;
            yOffset += [module prepareLayoutAttributes:layoutAttributes
                                            withOrigin:CGPointMake(edgeInsets.left, yOffset)
                                                 width:width - edgeInsets.left - edgeInsets.right];
            yOffset += edgeInsets.bottom;
            
            // add bottom padding
            RLModule *nextVisibleModule = section + 1 < sectionCount ? _modules[section + 1] : nil;
            yOffset += MAX(module.minimumBottomPadding, nextVisibleModule.minimumTopPadding);
            
            return layoutAttributes;
        });
    }
    else
    {
        // clear all layout ivars, no layout this time
        free(_yOffsets);
        _yOffsets = NULL;
        _contentSize = CGSizeZero;
        _sectionedLayoutAttributes = nil;
    }
}

#pragma mark - Layout Attributes
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    return _sectionedLayoutAttributes[path.section][path.item];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSArray *section in _sectionedLayoutAttributes)
    {
        for (UICollectionViewLayoutAttributes *attributes in section)
        {
            if (CGRectIntersectsRect(rect, attributes.frame))
            {
                [array addObject:attributes];
            }
        }
    }
    
    return array;
}

@end
