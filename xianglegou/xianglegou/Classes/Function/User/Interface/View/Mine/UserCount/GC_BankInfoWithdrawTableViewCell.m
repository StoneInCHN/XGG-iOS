//
//  GC_BankInfoWithdrawTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/28.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BankInfoWithdrawTableViewCell.h"


@interface GC_BankInfoWithdrawTableViewCell ()
///背景图片
@property (nonatomic, weak) UIImageView *bgImageView;
///logo bg 图片
@property (nonatomic, weak) UIImageView *logoBgImageView;
///logo图片
@property (nonatomic, weak) UIImageView *logoImageView;
///名称
@property (nonatomic, weak) UILabel *bankNameLabel;
///类型
@property (nonatomic, weak) UILabel *bankTypeLabel;
///卡号
@property (nonatomic, weak) UILabel *bankNumLabel;

@end


@implementation GC_BankInfoWithdrawTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_BankInfoWithdrawTableViewCell";
    
    GC_BankInfoWithdrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if(cell == nil){
        cell = [[GC_BankInfoWithdrawTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(479);
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.logoBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(130));
        make.centerX.equalTo(self.contentView);
        
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(142));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(142));
    }];
    
    
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoBgImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.bankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(9));
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankTypeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(9));
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

///更新界面
- (void)updateBankInfoUI:(GC_MResDefaultCardDataModel *)data
{
    if(data){
        self.bankNameLabel.text = data.bankName;
        self.bankTypeLabel.text = data.cardType;
        self.bankNumLabel.text = [DATAMODEL.henUtil getStringLastThree:data.cardNum andCharNum:4];
        
        ///[self.logoImageView sd_setImageWithUrlString:data.bankLogo defaultImageName:@"mine_bank_card"];
    }
}

#pragma mark -- getter,setter
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bg"];
        [self.contentView addSubview:_bgImageView = image];
    }
    return _bgImageView;
}

///Logo bg Image
- (UIImageView *)logoBgImageView
{
    if(!_logoBgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_bank1"];
        [self.contentView addSubview:_logoBgImageView = bgImage];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bank_card"];
        [self.contentView addSubview:_logoImageView = image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgImage);
        }];
    }
    return _logoBgImageView;
}

///logo
//- (UIImageView *)logoImageView
//{
//    if(!_logoImageView){
//        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bank_card"];
//        [self.contentView addSubview:_logoImageView = image];
//    }
//    return _logoImageView;
//}


///名称
- (UILabel *)bankNameLabel
{
    if(!_bankNameLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_bankNameLabel = label];
    }
    return _bankNameLabel;
}


///类型
- (UILabel *)bankTypeLabel
{
    if(!_bankTypeLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_bankTypeLabel = label];
    }
    return _bankTypeLabel;
}

///账号
- (UILabel *)bankNumLabel
{
    if(!_bankNumLabel){
         UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_bankNumLabel = label];
    }
    return _bankNumLabel;
}


@end
