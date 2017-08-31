//
//  QL_MineAbonusCollectionViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/12.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MineAbonusCollectionViewCell.h"
#import "QL_MineAbonusView.h"

@interface QL_MineAbonusCollectionViewCell()

///我的分红view
@property(nonatomic, weak) QL_MineAbonusView *mineAbonusView;

@end

@implementation QL_MineAbonusCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_MineAbonusCollectionViewCell class] forCellWithReuseIdentifier:@"QL_MineAbonusCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_MineAbonusCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    self.backgroundView = [UIImageView createImageViewWithName:@"rebate_bg_mine"];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.mineAbonusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

///更新ui
- (void)updateUIForUserInfoData:(GC_MResUserInfoDataModel *)data
{
    [self.mineAbonusView updateUIForUserInfoData:data];
}

///更新UI
- (void)updateUIForUserAbonusData:(QL_UserAbonusDataModel *)data
{
    [self.mineAbonusView updateUIForUserAbonusData:data];
}

///显示加载
- (void)showLoading
{
    [self.mineAbonusView showLoading];
}

///取消加载
- (void)cancelLoading
{
    [self.mineAbonusView cancelLoading];
}

#pragma mark -- getter,setter

///我的分红view
- (QL_MineAbonusView *)mineAbonusView
{
    if(!_mineAbonusView){
        QL_MineAbonusView *view = [[QL_MineAbonusView alloc] init];
        [self.contentView addSubview:_mineAbonusView = view];
    }
    return _mineAbonusView;
}

@end
