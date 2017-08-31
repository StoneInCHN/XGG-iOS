//
//  GC_WeChatInfoTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  微信信息 cell
//

#import "GC_WeChatInfoTableViewCell.h"

@interface GC_WeChatInfoTableViewCell ()
///提示信息
@property (nonatomic, weak) UILabel *promptInfoLabel;
///用户头像
@property (nonatomic, weak) UIImageView *userPhotoImageView;
///提现微信账号
@property (nonatomic, weak) UILabel *weChatTitleLabel;
///微信账号
@property (nonatomic, weak) UILabel *weChatInfoLabel;
@end

@implementation GC_WeChatInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_WeChatInfoTableViewCell";
    GC_WeChatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_WeChatInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITSCALE(555/2);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
//    self.backgroundColor = KCommonYellowBgColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.promptInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self).offset(FITSCALE(49/2));
    }];
    
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(FITSCALE(160/2));
        make.width.mas_equalTo(FITSCALE(160/2));
        make.top.equalTo(self.promptInfoLabel.mas_bottom).offset(FITSCALE(50/2));
    }];
    
    [self.weChatTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.userPhotoImageView.mas_bottom).offset(FITSCALE(56/2));
    }];
    
    [self.weChatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(50));
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(-50));
        make.top.equalTo(self.weChatTitleLabel.mas_bottom).offset(FITSCALE(28/2));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///更新ui
-(void)setUpdateUiForUserDate:(GC_MResUserInfoDataModel*)data
{
    if(data){
        [self.userPhotoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.userPhoto] defaultImageName:@"mine_moren"];
        self.weChatInfoLabel.text = data.wechatNickName;
    }
}


#pragma mark -- getter,setter
///提示信息
- (UILabel *)promptInfoLabel
{
    if(!_promptInfoLabel){
        UILabel *promptLabel = [UILabel createLabelWithText:HenLocalizedString(@"绑定微信后，能提现到此账户，还可以接受微信到账通知哦！") font:kFontSize_28 textColor:kFontColorBlack];
        [promptLabel lableAutoLinefeed];
        [self.contentView addSubview:_promptInfoLabel = promptLabel];
    }
    return _promptInfoLabel;
}

///头像
- (UIImageView *)userPhotoImageView
{
    if(!_userPhotoImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_head_bgred"];
        [bgImage makeRadiusForWidth:FITSCALE(208/2)];
        [self addSubview:bgImage];
        
        UIImageView *headerImage = [UIImageView createImageViewWithName:@"mine_moren"];
        [headerImage makeRadiusForWidth:FITSCALE(160/2)];
        [self addSubview:_userPhotoImageView = headerImage];
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerImage);
            make.width.mas_equalTo(FITSCALE(208/2));
            make.height.mas_equalTo(FITSCALE(208/2));
        }];
    }
    return _userPhotoImageView;
}

///提现账号
- (UILabel *)weChatTitleLabel
{
    if(!_weChatTitleLabel){
        UILabel *label = [UILabel createLabelWithText:HenLocalizedString(@"提现微信账号:") font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_weChatTitleLabel = label];
    }
    return _weChatTitleLabel;
}

///微信账号
- (UILabel *)weChatInfoLabel
{
    if(!_weChatInfoLabel){
        UILabel *weChatInfoLabel = [UILabel createLabelWithText:@"快乐驿站" font:kFontSize_38 textColor:kFontColorBlack];
        [weChatInfoLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_weChatInfoLabel = weChatInfoLabel];
    }
    return _weChatInfoLabel;
}
@end
