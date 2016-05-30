//
//  LineLayout.m
//  CollectionViewLayout
//
//  Created by 杜习营 on 16/5/30.
//  Copyright © 2016年 dxy. All rights reserved.
//

#import "LineLayout.h"

@implementation LineLayout

static CGFloat const itemWH = 100;

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    /** 这些代码不能写在init方法里。因为在布局的时候，collectionview还没有初始化完*/
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat inset = (self.collectionView.frame.size.width - itemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.minimumLineSpacing = itemWH * 0.7;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat itemCenterX = attrs.center.x;
        CGFloat scale = 1 + 0.6 * (1 - (ABS(itemCenterX - centerX) / 150));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    CGFloat adjustOffsetX = MAXFLOAT;
    
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(centerX - attrs.center.x) < ABS(adjustOffsetX)) {
            adjustOffsetX = centerX - attrs.center.x;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
@end
