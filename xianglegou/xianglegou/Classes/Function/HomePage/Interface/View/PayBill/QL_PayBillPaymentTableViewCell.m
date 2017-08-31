//
//  QL_PayBillPaymentTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_PayBillPaymentTableViewCell.h"

@interface QL_PayBillPaymentTableViewCell()

///icon
@property(nonatomic, weak) UIImageView *iconImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///信息
@property(nonatomic, weak) UILabel *infoLabel;
///下一步
@property(nonatomic, weak) UIImageView *nextImage;

@end

@implementation QL_PayBillPaymentTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_PayBillPaymentTableViewCell";
    QL_PayBillPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_PayBillPaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(90);
}

///初始化
- (void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(OffSetToLeft);
        make.width.and.height.mas_equalTo(FITSCALE(47/2));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconImage.mas_right).offset(WIDTH_TRANSFORMATION(6));
    }];
    [self.nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.nextImage.mas_left).offset(WIDTH_TRANSFORMATION(-6));
    }];
}

///更新ui
- (void)updateUIForData:(QL_PayMentDataModel *)data
{
    if(data){
        self.nameLabel.text = data.configValue;
        self.infoLabel.hidden = YES;
        if([data.id isEqualToString:@"1"]){ // 微信
            [self.iconImage setImageForName:@"homepage_pay_icon_wechat"];
        }else if([data.id isEqualToString:@"2"]){ // 支付宝
            [self.iconImage setImageForName:@"homepage_pay_icon_alipay"];
        }else if([data.id isEqualToString:@"3"]){ // 快捷支付
            [self.iconImage setImageForName:@"homepage_pay_icon_quick"];
        }else if([data.id isEqualToString:@"5"]){ // 乐分
            [self.iconImage setImageForName:@"homepage_pay_icon_le"];
            self.infoLabel.hidden = NO;
            
            self.infoLabel.text = [NSString stringWithFormat:@"余额：%@", [DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeScore showDotNumber:4]];
        }
    }
}

#pragma mark -- getter,setter

///icon
- (UIImageView *)iconImage
{
    if(!_iconImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_iconImage = image];
    }
    return _iconImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///信息
- (UILabel *)infoLabel
{
    if(!_infoLabel){
        UILabel *label = [UILabel createLabelWithText:@"余额0.00" font:kFontSize_28];
        [self.contentView addSubview:_infoLabel = label];
    }
    return _infoLabel;
}

///下一步
- (UIImageView *)nextImage
{
    if(!_nextImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImage = image];
    }
    return _nextImage;
}

///设置名字
- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

///设置信息
- (void)setInfo:(NSString *)info
{
    self.infoLabel.text = info;
}

@end
