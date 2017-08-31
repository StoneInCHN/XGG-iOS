//
//  GC_RecommendPoliteTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐有礼 -- cell
//

#import "GC_RecommendPoliteTableViewCell.h"

@interface GC_RecommendPoliteTableViewCell ()
///提示 信息
@property (nonatomic, weak) UILabel *promptInfoLabel;
///二维码 背景
@property (nonatomic, weak) UIImageView *qrCodeBgImageView;
///二维码
@property (nonatomic, weak) UIImageView *qrCodeImageView;

///分享按钮
@property (nonatomic, weak) UIButton *shareItButton;
///分享下载链接
@property (nonatomic, weak) UIButton *shareItDownloadlinkButton;

@end

@implementation GC_RecommendPoliteTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_RecommendPoliteTableViewCell";
    GC_RecommendPoliteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_RecommendPoliteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITSCALE(990/2);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = [UIColor clearColor];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.promptInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FITSCALE(38/2));
        make.left.equalTo(self.contentView).offset(FITSCALE(65/2));
        make.right.equalTo(self.contentView).offset(FITSCALE(-65/2));
       
    }];
    
    [self.qrCodeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptInfoLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.width.mas_equalTo(FITSCALE(407/2));
        make.height.mas_equalTo(FITSCALE(437/2));
        make.centerX.equalTo(self.contentView);
        
    }];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeBgImageView).offset(FITSCALE(60/2));
        make.centerX.equalTo(self.qrCodeBgImageView);
        make.width.mas_equalTo(FITSCALE(270/2));
        make.height.mas_equalTo(FITSCALE(270/2));
    }];
    
    [self.shareItButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.qrCodeBgImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(FITSCALE(195/2)));
    }];
    
    [self.shareItDownloadlinkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.shareItButton.mas_bottom).offset(FITSCALE(56/2));
        make.bottom.equalTo(self.contentView).offset(FITSCALE(-50/2));
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
- (void)setUpdateUiForQrCodeData:(GC_MResQrCodeDataModel*)data
{
    if(data.qrImage > 0 && ![data.qrImage isEqualToString:@""]){
        
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:data.qrImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.qrCodeImageView.image = [UIImage imageWithData:imageData];
    }
}


#pragma mark -- action
///立即分享
- (void)onShareItAction:(UIButton*)sender
{
    if(self.onShareItClickBlock){
        self.onShareItClickBlock(sender.tag);
    }
}

///分享下载链接
- (void)onShareItDownloadlinkAction:(UIButton*)sender
{
    if(self.onShareItDownloadlinkBlock){
        self.onShareItDownloadlinkBlock(sender.tag);
    }
}

#pragma mark -- getter,setter
///提示信息
- (UILabel *)promptInfoLabel
{
    if(!_promptInfoLabel){
        UILabel *promptLabel = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        
        
        NSString *ruleInfo = HenLocalizedString(@"邀请好友注册并填写您的邀请码，您可得到此好友每笔消费的收益！若此好友升级为商家，您也可得到此好友每笔交易的收益！");
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:ruleInfo];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:HEIGHT_TRANSFORMATION(16)];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [ruleInfo length])];
        [promptLabel setAttributedText:attributedString1];
        [promptLabel sizeToFit];
        
        [promptLabel setTextAlignment:NSTextAlignmentCenter];
        [promptLabel lableAutoLinefeed];

        
        [self.contentView addSubview:_promptInfoLabel = promptLabel];
    }
    return _promptInfoLabel;
}

- (UIImageView *)qrCodeBgImageView
{
    if(!_qrCodeBgImageView){
        
        UIImageView *qrCodebgRecommendImage = [UIImageView createImageViewWithName:@"mine_qr_code_bg_recommend"];
        qrCodebgRecommendImage.hidden = YES;
        [self.contentView addSubview:qrCodebgRecommendImage];
        
        UIImageView *qrBgImage = [UIImageView createImageViewWithName:@"mine_recommend_qr_code"];
        [self.contentView addSubview:_qrCodeBgImageView = qrBgImage];
        
        
        [qrCodebgRecommendImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qrBgImage.mas_bottom).offset(-FITSCALE(105/2));
            make.centerX.equalTo(qrBgImage);
            make.width.mas_equalTo(FITSCALE(750/2));
            make.height.mas_equalTo(FITSCALE(163/2));
        }];
    }
    return _qrCodeBgImageView;
}

///二维码
- (UIImageView *)qrCodeImageView
{
    if(!_qrCodeImageView){
        
        UILabel *mineQr = [UILabel createLabelWithText:@"我的二维码" font:kFontSize_28];
        [self.contentView addSubview:mineQr];
        
        
        UIImageView *qrCodeImage = [UIImageView createImageViewWithName:@"mine_shop_icon_qr_code"];
    
        [self.contentView addSubview:_qrCodeImageView = qrCodeImage];
        [mineQr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qrCodeImage);
            make.top.equalTo(qrCodeImage.mas_bottom).offset(FITSCALE(14/2));
        }];
    }
    return _qrCodeImageView;
}


///立即分享
- (UIButton *)shareItButton
{
    if(!_shareItButton){
        UIButton *shareItButton = [UIButton createButtonWithTitle:HenLocalizedString(@"立即分享") backgroundNormalImage:@"public_botton_big_red_press" backgroundPressImage:@"public_botton_big_red_press1" target:self action:@selector(onShareItAction:)];
        shareItButton.titleLabel.font = kFontSize_36;
        [shareItButton setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_shareItButton = shareItButton];
    }
    return _shareItButton;
}

///分享下载链接
- (UIButton *)shareItDownloadlinkButton
{
    if(!_shareItDownloadlinkButton){
        UIButton *button = [UIButton createButtonWithTitle:HenLocalizedString(@"分享下载链接") backgroundNormalImage:@"public_botton_big_red_press" backgroundPressImage:@"public_botton_big_red_press1" target:self action:@selector(onShareItDownloadlinkAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_shareItDownloadlinkButton = button];
    }
    return _shareItDownloadlinkButton;
}

@end
