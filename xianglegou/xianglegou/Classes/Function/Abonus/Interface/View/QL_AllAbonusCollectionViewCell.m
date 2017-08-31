//
//  QL_AllAbonusCollectionViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/12.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AllAbonusCollectionViewCell.h"
#import "QL_AllAbonusView.h"

@interface QL_AllAbonusCollectionViewCell()

///全部分红view
@property(nonatomic, weak) QL_AllAbonusView *allAbonusView;

@end

@implementation QL_AllAbonusCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_AllAbonusCollectionViewCell class] forCellWithReuseIdentifier:@"QL_AllAbonusCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_AllAbonusCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    self.backgroundView = [UIImageView createImageViewWithName:@"rebate_bg_country"];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.allAbonusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

///更新ui
- (void)updateUIForAllAbonusData:(QL_AllAbonusDataModel *)data
{
    [self.allAbonusView updateUIForAllAbonusData:data];
}

///显示加载
- (void)showLoading
{
    [self.allAbonusView showLoading];
}

///取消加载
- (void)cancelLoading
{
    [self.allAbonusView cancelLoading];
}

#pragma mark -- getter,setter

///全部分红view
- (QL_AllAbonusView *)allAbonusView
{
    if(!_allAbonusView){
        QL_AllAbonusView *view = [[QL_AllAbonusView alloc] init];
        [self.contentView addSubview:_allAbonusView = view];
    }
    return _allAbonusView;
}

@end
