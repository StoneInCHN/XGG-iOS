//
//  UICollectionView+CreateCollectionView.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UICollectionView+CreateCollectionView.h"

@implementation UICollectionView (CreateCollectionView)

///创建CollectionView
+(UICollectionView*)createCollectionViewWithDelegateTarget:(id)delegateTarget
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = kFontColorWhite;
    collectionView.delegate = delegateTarget;
    collectionView.dataSource = delegateTarget;
    
    return collectionView;
}

///创建CollectionView
+(UICollectionView*)createCollectionViewWithDelegateTarget:(id)delegateTarget forScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = kFontColorWhite;
    collectionView.delegate = delegateTarget;
    collectionView.dataSource = delegateTarget;
    
    // 设置cell的大小和细节
    flowLayout.scrollDirection = scrollDirection;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    return collectionView;
}

///获取
+(UICollectionView*)getCollectionViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UICollectionView *collectionView = (UICollectionView*)[view viewWithTag:tag];
    
    return collectionView;
}

@end
