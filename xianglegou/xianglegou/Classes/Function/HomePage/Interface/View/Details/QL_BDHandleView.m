//
//  QL_BDHandleView.m
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BDHandleView.h"
#import "QL_PayBillViewController.h"

@interface QL_BDHandleView()

///收藏按钮
@property(nonatomic, weak) UIButton *collcetionButton;
///购买按钮
@property(nonatomic, weak) UIButton *buyButton;
///收藏图片
@property(nonatomic, weak) UIImageView *collectionImage;
///收藏信息
@property(nonatomic, weak) UILabel *collectionInfoLabel;

@end

@implementation QL_BDHandleView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.collcetionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kMainScreenWidth/2);
        make.left.equalTo(self);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kMainScreenWidth/2);
        make.right.equalTo(self);
    }];
}

#pragma mark -- event response

///收藏
- (void)onCollectionAction:(UIButton *)sender
{
    //参数
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    if(DATAMODEL.token){
        [param setObject:DATAMODEL.token forKey:@"token"];
    }
    [param setObject:self.businessData.id forKey:@"entityId"];
    
    if([self.businessData.userCollected isEqualToString:@"1"]){ // 已收藏
        [param setObject:@"false" forKey:@"isFavoriteAdd"];
        [self.collectionImage setImageForName:@"homepage_favorite"];
        //请求
        WEAKSelf;
        [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/endUser/favoriteSeller.jhtml" dictionaryParam:param withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            if([code isEqualToString:@"0000"]){ // 成功
                //提示
                [DATAMODEL.progressManager showHint:@"成功"];
                weakSelf.businessData.userCollected = @"0";
                weakSelf.businessData.favoriteNum = [NSString stringWithFormat:@"%ld", [weakSelf.businessData.favoriteNum integerValue] - 1];
                weakSelf.collectionInfoLabel.text = [NSString stringWithFormat:@"收藏(%@)", weakSelf.businessData.favoriteNum];
            }else{
                //还原
                [weakSelf.collectionImage setImageForName:@"homepage_favorite_choose"];
            }
        }];
    }else{
        [param setObject:@"true" forKey:@"isFavoriteAdd"];
        [self.collectionImage setImageForName:@"homepage_favorite_choose"];
        //请求
        WEAKSelf;
        [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/endUser/favoriteSeller.jhtml" dictionaryParam:param withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            if([code isEqualToString:@"0000"]){ // 成功
                //提示
                [DATAMODEL.progressManager showHint:@"成功"];
                weakSelf.businessData.userCollected = @"1";
                weakSelf.businessData.favoriteNum = [NSString stringWithFormat:@"%ld", [weakSelf.businessData.favoriteNum integerValue] + 1];
                weakSelf.collectionInfoLabel.text = [NSString stringWithFormat:@"收藏(%@)", weakSelf.businessData.favoriteNum];
            }else{
                //还原
                [weakSelf.collectionImage setImageForName:@"homepage_favorite"];
            }
        }];
    }
}

///购买
- (void)onBuyAction:(UIButton *)sender
{
    QL_PayBillViewController *pbVC = [[QL_PayBillViewController alloc] init];
    pbVC.hidesBottomBarWhenPushed = YES;
    pbVC.businessData = self.businessData;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:pbVC animated:YES];
}

#pragma mark -- getter,setter

///收藏按钮
- (UIButton *)collcetionButton
{
    if(!_collcetionButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" backgroundNormalImage:@"public_tool_bar_icon_background" backgroundPressImage:@"public_tool_bar_icon_background" target:self action:@selector(onCollectionAction:)];
        [self addSubview:_collcetionButton = button];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_favorite"];
        [self addSubview:_collectionImage = image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(15));
        }];
        UILabel *label = [UILabel createLabelWithText:@"收藏(0)" font:kFontSize_22 textColor:kFontColorGray];
        [self addSubview:_collectionInfoLabel = label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-6));
        }];
    }
    return _collcetionButton;
}

///购买按钮
- (UIButton *)buyButton
{
    if(!_buyButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即买单" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onBuyAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleColor:kFontColorWhite forState:UIControlStateNormal];
        [self addSubview:_buyButton = button];
    }
    return _buyButton;
}

///设置商家信息
-(void)setBusinessData:(QL_BussinessDetialsDataModel *)businessData
{
    _businessData = businessData;
    if([businessData.favoriteNum isEqualToString:@""]){
        self.collectionInfoLabel.text = @"收藏(0)";
    }else{
        self.collectionInfoLabel.text = [NSString stringWithFormat:@"收藏(%@)", businessData.favoriteNum];
    }
    if([businessData.userCollected isEqualToString:@"1"]){ // 收藏
        [self.collectionImage setImageForName:@"homepage_favorite_choose"];
    }else{
        [self.collectionImage setImageForName:@"homepage_favorite"];
    }
}

@end
