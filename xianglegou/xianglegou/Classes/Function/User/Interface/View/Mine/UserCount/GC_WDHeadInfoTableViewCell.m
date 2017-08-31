//
//  GC_WDHeadInfoTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  提现 -- 头像信息
//



#import "GC_WDHeadInfoTableViewCell.h"

@interface GC_WDHeadInfoTableViewCell ()
///背景图片
@property (nonatomic, weak) UIImageView *bgImageView;
///头像图片
@property (nonatomic, weak) UIImageView *headerImageView;
///名称
@property (nonatomic, weak) UILabel *bankNameLabel;
///类型
@property (nonatomic, weak) UILabel *bankTypeLabel;
///卡号
@property (nonatomic, weak) UILabel *bankNum;

///提现账号：
@property (nonatomic, weak) UILabel *wechatAccountLabel;

@end


@implementation GC_WDHeadInfoTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_WDHeadInfoTableViewCell";
    GC_WDHeadInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_WDHeadInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(FITSCALE(160/2));
        make.height.mas_equalTo(FITSCALE(160/2));
    }];
    
    [self.wechatAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(FITSCALE(50/2));
        make.left.equalTo(self).offset(FITSCALE(200/2));
        make.right.equalTo(self).offset(FITSCALE(-200/2));
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
-(void)setUpdateForWithdrawInfoData:(GC_MResWithdrawInfoDataModel*)data
{
//    if(data){
//        [self.headerImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.userPhoto] defaultImageName:@"mine_moren"];
//        
//        self.wechatAccountLabel.text = [NSString stringWithFormat:@"提现微信账号：%@",data.wxNickName];
//        
//    }
}


#pragma mark -- getter,setter
///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_bg"];
        [self.contentView addSubview:_bgImageView = bgImage];
    }
    return _bgImageView;
}

///头像图
- (UIImageView *)headerImageView
{
    if(!_headerImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_toux"];
        [bgImage makeRadiusForWidth:FITSCALE(180/2)];
        [self addSubview:bgImage];
        
        
        UIImageView *headerImage = [UIImageView createImageViewWithName:@"mine_moren"];
        [headerImage makeRadiusForWidth:FITSCALE(160/2)];
        [self addSubview:_headerImageView = headerImage];
   
    
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerImage);
            make.width.mas_equalTo(FITSCALE(180/2));
            make.height.mas_equalTo(FITSCALE(180/2));
        }];
    }
    return _headerImageView;
}
///微信账号
- (UILabel *)wechatAccountLabel
{
    if(!_wechatAccountLabel){
        UILabel *label = [UILabel createLabelWithText:@"提现微信账号：快乐驿站杀杀杀杀" font:kFontSize_28 textColor:kFontColorWhite];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_wechatAccountLabel = label];
    }
    return _wechatAccountLabel;
}
@end
