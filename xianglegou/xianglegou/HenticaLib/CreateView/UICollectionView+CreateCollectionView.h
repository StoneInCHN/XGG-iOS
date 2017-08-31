//
//  UICollectionView+CreateCollectionView.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CreateCollectionView)

///创建CollectionView
+(UICollectionView*)createCollectionViewWithDelegateTarget:(id)delegateTarget;

///创建CollectionView
+(UICollectionView*)createCollectionViewWithDelegateTarget:(id)delegateTarget forScrollDirection:(UICollectionViewScrollDirection)scrollDirection;

///获取
+(UICollectionView*)getCollectionViewForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
