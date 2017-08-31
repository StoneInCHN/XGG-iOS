//
//  GC_PaymentFilterCollectionViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_PaymentFilterCollectionViewCell.h"


@interface GC_PaymentFilterCollectionViewCell ()
///标题
@property (nonatomic, weak) UILabel *titleLabel;

///背景
@property (nonatomic, weak) UIImageView *bgImage;

@end


@implementation GC_PaymentFilterCollectionViewCell

///注册cell
+(void)registerCollectionView:(UICollectionView*)collectionView
{
    [collectionView registerClass:[GC_PaymentFilterCollectionViewCell class] forCellWithReuseIdentifier:@"GC_PaymentFilterCollectionViewCell"];
}

///创建
+(id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"GC_PaymentFilterCollectionViewCell" forIndexPath:indexPath];
}

///初始化
-(void)initDefault
{
    
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.contentView);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgImage);
    }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



///更新 ui
- (void)updateUiForDate:(GC_PaymentFilterDataModel *)data
{
    if(data){
        self.titleLabel.text = data.name;
    }
    
}

- (void)setFilterIsSelected:(BOOL)isSelected
{
    if(isSelected){
        self.titleLabel.textColor = kFontColorRed;
        [self.bgImage setImageForName:@"homepage_city_choose"];
    }else{
        self.titleLabel.textColor = kFontColorBlack;
        [self.bgImage setImageForName:@"homepage_city"];
    }
}


#pragma mark -- getter,setter

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
    
        
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}


///背景
- (UIImageView *)bgImage
{
    if(!_bgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_city"];
        [self.contentView addSubview:_bgImage = image];
    }
    return _bgImage;
}

@end
