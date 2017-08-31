//
//  QL_HPTopSearchView.m
//  Rebate
//
//  Created by mini2 on 17/3/20.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPTopSearchView.h"

#import "QL_CityChooiceViewController.h"
#import "QL_SearchHistoryViewController.h"
#import "GC_NoticeListViewController.h"
#import "QL_CodeScanningViewController.h"

@interface QL_HPTopSearchView()

///背景
@property(nonatomic, weak) UIImageView *bgImage;
///城市图标
@property(nonatomic, weak) UIButton *cityIconButton;
///城市名
@property(nonatomic, weak) UILabel *cityNameLabel;
///城市名箭头
@property(nonatomic, weak) UIImageView *cityNameArrowImage;
///搜索按钮
@property(nonatomic, weak) UIButton *searchButton;

///扫一扫按钮
@property(nonatomic, weak) UIButton *scanButton;
///消息按钮
@property(nonatomic, weak) UIButton *messageButton;

@end

@implementation QL_HPTopSearchView

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
    self.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(140));
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(FITWITH(367/2));
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    

    [self.cityIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchButton);
        make.left.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(10));
        make.right.equalTo(self.searchButton.mas_left);
        make.height.mas_equalTo(44);
    }];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchButton);
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(50));
        make.width.mas_equalTo(FITWITH(130/2));
    }];
    [self.cityNameArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityNameLabel);
        make.right.equalTo(self.searchButton.mas_left).offset(POSITION_WIDTH_FIT_TRANSFORMATION(4));
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchButton);
        make.right.equalTo(self);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchButton);
//        make.right.equalTo(self.messageButton.mas_left);
        make.right.equalTo(self);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
}

///更新城市名
- (void)updateCityName
{
    self.cityNameLabel.text = DATAMODEL.cityName;
}

#pragma mark -- event response

///点击按钮
- (void)onButtonClick:(UIButton *)sender
{
    if(sender.tag == 1){ // 城市图标
        QL_CityChooiceViewController *ccVC = [[QL_CityChooiceViewController alloc] init];
        ccVC.hidesBottomBarWhenPushed = YES;
        WEAKSelf;
        //回调
        ccVC.onChoiceItemBlock = ^(QL_AreaDataModel *data){
            DATAMODEL.cityId = data.areaId;
            weakSelf.cityNameLabel.text = data.name;
            if(weakSelf.onCityChooiceBlock){
                weakSelf.onCityChooiceBlock();
            }
        };
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:ccVC animated:YES];
    }else if(sender.tag == 2){ // 搜索
        QL_SearchHistoryViewController *alVC = [[QL_SearchHistoryViewController alloc] init];
        alVC.hidesBottomBarWhenPushed = YES;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:alVC animated:YES];
    }else if(sender.tag == 3){ // 扫一扫
        QL_CodeScanningViewController *csVC = [[QL_CodeScanningViewController alloc] init];
        csVC.hidesBottomBarWhenPushed = YES;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:csVC animated:YES];
    }else if(sender.tag == 4){ // 消息
        GC_NoticeListViewController *noVC = [[GC_NoticeListViewController alloc] init];
        noVC.hidesBottomBarWhenPushed = YES;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:noVC animated:YES];
    }
}

#pragma mark -- getter,setter

///背景
- (UIImageView *)bgImage
{
    if(!_bgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_banner_gradual_change"];
        [self addSubview:_bgImage = image];
    }
    return _bgImage;
}

///城市图标
- (UIButton *)cityIconButton
{
    if(!_cityIconButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"homepage_icon_location" pressImage:@"homepage_icon_location" target:self action:@selector(onButtonClick:)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.tag = 1;
        [self addSubview:_cityIconButton = button];
    }
    return _cityIconButton;
}

///城市名
- (UILabel *)cityNameLabel
{
    if(!_cityNameLabel){
        NSString *name = [DATAMODEL.configDBHelper getCityNameForCityId:DATAMODEL.cityId];
        if([name isEqualToString:@""]){
            name = DATAMODEL.defaultCityName;
            DATAMODEL.cityId = [DATAMODEL.configDBHelper getCityIdForCityName:name];
        }
        UILabel *label = [UILabel createLabelWithText:name font:kFontSize_30 textColor:kFontColorWhite];
        [self addSubview:_cityNameLabel = label];
    }
    return _cityNameLabel;
}

///城市名箭头
- (UIImageView *)cityNameArrowImage
{
    if(!_cityNameArrowImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_choose_city"];
        [self addSubview:_cityNameArrowImage = image];
    }
    return _cityNameArrowImage;
}

///搜索按钮
- (UIButton *)searchButton
{
    if(!_searchButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"public_icon_search_bg" pressImage:@"public_icon_search_bg" target:self action:@selector(onButtonClick:)];
        button.tag = 2;
       
        UILabel   *searchTip=[UILabel createLabelWithText:@"搜索" font:kFontSize_26 textColor:kFontColorWhite];
        [button addSubview:searchTip];
        [searchTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.left.equalTo(button).offset(POSITION_WIDTH_FIT_TRANSFORMATION(10));
        }];
        
        [self addSubview:_searchButton = button];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_icon_search1"];
        [self addSubview:image];
      
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.right.equalTo(button).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-10));
        }];
    }
    return _searchButton;
}


///扫一扫按钮
- (UIButton *)scanButton
{
    if(!_scanButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"public_icon_scan" pressImage:@"public_icon_scan" target:self action:@selector(onButtonClick:)];
        button.tag = 3;
        [self addSubview:_scanButton = button];
    }
    return _scanButton;
}
///消息按钮
- (UIButton *)messageButton
{
    if(!_messageButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"public_icon_message" pressImage:@"public_icon_message" target:self action:@selector(onButtonClick:)];
        button.tag = 4;
        button.hidden = YES;
        [self addSubview:_messageButton = button];
    }
    return _messageButton;
}

@end
