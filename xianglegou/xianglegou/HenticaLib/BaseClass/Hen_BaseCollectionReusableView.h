//
//  Hen_BaseCollectionReusableView.h
//  HelloWorld
//
//  Created by mini2 on 16/8/31.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hen_BaseCollectionReusableView : UICollectionReusableView

///注册cell
+(void)registerCollectionView:(UICollectionView*)collectionView;

///创建
+(id)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

///初始化
-(void)initDefault;

///加载子视图约束
-(void)loadSubviewConstraints;

@end
