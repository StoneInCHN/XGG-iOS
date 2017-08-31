//
//  QL_MSShopManagerTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MSShopManagerTableViewCell.h"

@implementation QL_MSShopManagerTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_MSShopManagerTableViewCell";
    QL_MSShopManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_MSShopManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
//    return HEIGHT_TRANSFORMATION(168);
    return HEIGHT_TRANSFORMATION(336);
}

///初始化
- (void)initDefault
{
    self.topLongLineImage.hidden = NO;
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    UIButton *tempButton;
    for(NSInteger i = 0; i < 3; i++){
        UIButton *button = [self itemButtonForTag:i];
        if(i == 0){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(168));
                make.width.mas_equalTo(kMainScreenWidth / 3);
                make.left.and.top.equalTo(self);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempButton);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(168));
                make.width.mas_equalTo(kMainScreenWidth / 3);
                make.left.equalTo(tempButton.mas_right);
            }];
            
            UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line2"];
            [self.contentView addSubview:lineImage];
            [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_left);
                make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(32));
                make.bottom.equalTo(tempButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(-32));
            }];
        }
        tempButton = button;
    }
    
    
    
    UIButton *shopButtonTemp;
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *button = [self itemButtonForTag:i+3];
        if(i == 0){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempButton.mas_bottom);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(168));
                make.width.mas_equalTo(kMainScreenWidth / 3);
                make.left.equalTo(self);
            }];
            
            UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
            [self.contentView addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button);
                make.left.right.equalTo(self.contentView);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(shopButtonTemp);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(168));
                make.width.mas_equalTo(kMainScreenWidth / 3);
                make.left.equalTo(shopButtonTemp.mas_right);
            }];
            UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line2"];
            [self.contentView addSubview:lineImage];
            [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_left);
                make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(32));
                make.bottom.equalTo(shopButtonTemp.mas_bottom).offset(HEIGHT_TRANSFORMATION(-32));
            }];
        }
        shopButtonTemp = button;
    }
}

#pragma mark -- event response

///点击item
- (void)onItemAction:(UIButton *)sender
{
    if(self.onClickItemBlock){
        self.onClickItemBlock(sender.tag);
    }
}

#pragma mark -- getter,setter

- (UIButton *)itemButtonForTag:(NSInteger)tag
{
    UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onItemAction:)];
    button.tag = tag;
    [self.contentView addSubview:button];
    
    NSString *name = @"";
    NSString *icon = @"";
    if(tag == 0){ // 订单管理
        name = @"订单管理";
        icon = @"mine_shop_icon_order";
    }else if(tag == 1){ // 店铺信息
        name = @"店铺信息";
        icon = @"mine_shop_icon_details";
    }else if(tag == 2){ // 收款二维码
        name = @"收款二维码";
        icon = @"mine_shop_icon_qr_code";
    }else if(tag == 3){
        name = @"店铺货款";
        icon = @"mine_shop_icon_qr_loan";
    }else if(tag == 4){
        name = @"店铺录单";
        icon = @"mine_shop_icon_single";
    }
    UILabel *label = [UILabel createLabelWithText:name font:kFontSize_28];
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    UIImageView *image = [UIImageView createImageViewWithName:icon];
    [button addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(30));
    }];
    
    return button;
}



@end
