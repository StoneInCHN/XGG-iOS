//
//  QL_HPBusinessListTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/13.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPBusinessListTableViewCell.h"

@interface QL_HPBusinessListTableViewCell()

///内容背景
@property(nonatomic, weak) UIView *contentBgView;
///图片
@property(nonatomic, weak) UIImageView *pngImageView;
///支持乐豆抵扣
@property (nonatomic, weak) UIImageView *leBeandikouImageView;

///名称
@property(nonatomic, weak) UILabel *nameLabel;
///距离
@property(nonatomic, weak) UILabel *distanceLabel;
///标志
@property(nonatomic, weak) UILabel *markLabel;
///评分
@property(nonatomic, weak) UILabel *commentScoreLabel;
///消费
@property(nonatomic, weak) UILabel *consumptionLabel;
///地址
@property(nonatomic, weak) UILabel *addressLabel;
///消费提示
@property(nonatomic, weak) UILabel *consumptionInfoLabel;

@end

@implementation QL_HPBusinessListTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_HPBusinessListTableViewCell";
    QL_HPBusinessListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_HPBusinessListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(254 + 10);
}

///初始化
- (void)initDefault
{
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self contentBgView];
    [self.pngImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(23));
        make.left.equalTo(self).offset(OffSetToLeft);
        make.width.mas_equalTo(FITWITH(168/2));
        make.height.mas_equalTo(FITWITH(168/2));
    }];
    
    
    [self.leBeandikouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pngImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(12));
        make.top.equalTo(self.pngImageView).offset(HEIGHT_TRANSFORMATION(-4));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(39));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(39));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leBeandikouImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(12));
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-140));
        make.centerY.equalTo(self.leBeandikouImageView);
        make.width.mas_equalTo(FITWITH(410/2));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pngImageView);
        make.left.equalTo(self.pngImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(30));
    }];
    [self.commentScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pngImageView);
        make.left.equalTo(self.markLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(30));
    }];
    [self.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pngImageView);
        make.left.equalTo(self.commentScoreLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(90));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pngImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(32));
        make.bottom.equalTo(self.pngImageView);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.consumptionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
}

///更新ui
- (void)updateUIForData:(QL_BusinessListDataModel *)data
{
    if(data){
        [self.pngImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, data.storePictureUrl] defaultImageName:@""];
        self.nameLabel.text = data.sellerName;
        self.distanceLabel.text = data.distance.length > 0 ? [NSString stringWithFormat:@"%@km", data.distance] : @" ";
        self.markLabel.text = data.categoryName;
        self.commentScoreLabel.text = [NSString stringWithFormat:@"%@分",data.rateScore.length > 0 ? [DATAMODEL.henUtil string:data.rateScore showDotNumber:1] : @"0.0"];
        self.consumptionLabel.text = [NSString stringWithFormat:@"人均%@元", data.avg_price.length > 0 ? data.avg_price : @"1"];
        self.addressLabel.text = data.address.length > 0 ? data.address : @" ";
        self.consumptionInfoLabel.text = [NSString stringWithFormat:@"消费%@赠送%@积分", data.unitConsume, data.rebateUserScore];
        
        if([data.isBeanPay isEqualToString:@"1"]){
            self.leBeandikouImageView.hidden = NO;
            [self.leBeandikouImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(WIDTH_TRANSFORMATION(39));
            }];
            
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leBeandikouImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(12));
            }];
        }else{
            self.leBeandikouImageView.hidden = YES;
            [self.leBeandikouImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(WIDTH_TRANSFORMATION(0));
            }];
            
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leBeandikouImageView.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(0));
            }];
        }
    }
}


///更新收藏列表数据ui
-(void)setUpdateUiForCollectionListData:(GC_MResCollectionListDataModel*)data
{
    if(data){
        [self.pngImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.storePictureUrl] defaultImageName:@""];
        
        self.nameLabel.text = data.name;
        self.distanceLabel.text = data.distance.length > 0 ? [NSString stringWithFormat:@"%@km", data.distance] : @" ";
        self.markLabel.text = data.sellerCategory.categoryName;
        self.commentScoreLabel.text = [NSString stringWithFormat:@"%@分",data.rateScore.length > 0 ? data.rateScore : @"0"];
        self.consumptionLabel.text = [NSString stringWithFormat:@"人均%@元", data.avgPrice.length > 0 ? data.avgPrice : @"1"];
        
        self.addressLabel.text = data.address.length > 0 ? data.address : @" ";
        
        self.consumptionInfoLabel.text = [NSString stringWithFormat:@"消费%@赠送%@积分", data.unitConsume, data.rebateScore];
        
    }
}

#pragma mark -- getter,setter

///内容背景
- (UIView *)contentBgView
{
    if(!_contentBgView){
        UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(254)) backgroundColor:kCommonWhiteBg];
        [self.contentView addSubview:_contentBgView = view];
        
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.width.equalTo(view);
            make.bottom.equalTo(view);
        }];
    }
    return _contentBgView;
}

///图片
- (UIImageView *)pngImageView
{
    if(!_pngImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_pngImageView = image];
    }
    return _pngImageView;
}

///名称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"name" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///距离
- (UILabel *)distanceLabel
{
    if(!_distanceLabel){
        UILabel *label = [UILabel createLabelWithText:@"xkm" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_distanceLabel = label];
    }
    return _distanceLabel;
}

///标志
- (UILabel *)markLabel
{
    if(!_markLabel){
        UILabel *label = [UILabel createLabelWithText:@"主营" font:kFontSize_22 textColor:kFontColorRed];

        UIView *bgImage = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        //将图层的边框设置为圆脚
        bgImage.layer.cornerRadius = 2;
        bgImage.layer.masksToBounds = YES;
        bgImage.layer.borderColor = [kFontColorRed CGColor];
        bgImage.layer.borderWidth = 1;
        
        [self.contentView addSubview:bgImage];
        [self.contentView addSubview:_markLabel = label];
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(label);
            make.left.equalTo(label.mas_left).with.offset(WIDTH_TRANSFORMATION(-16));
            make.left.equalTo(label).with.priorityLow();
            make.right.equalTo(label.mas_right).with.offset(WIDTH_TRANSFORMATION(16));
            make.right.equalTo(label).with.priorityLow();
            make.top.equalTo(label.mas_top).with.offset(HEIGHT_TRANSFORMATION(-2));
            make.top.equalTo(label).with.priorityLow();
            make.bottom.equalTo(label.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(2));
            make.bottom.equalTo(label).with.priorityLow();
        }];
    }
    return _markLabel;
}

///评分
- (UILabel *)commentScoreLabel
{
    if(!_commentScoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"0分" font:kFontSize_26 textColor:kFontColorGray];
        [self.contentView addSubview:_commentScoreLabel = label];
    }
    return _commentScoreLabel;
}

///消费
- (UILabel *)consumptionLabel
{
    if(!_consumptionLabel){
        UILabel *label = [UILabel createLabelWithText:@"人均x元" font:kFontSize_26 textColor:kFontColorGray];
        [self.contentView addSubview:_consumptionLabel = label];
    }
    return _consumptionLabel;
}

///地址
- (UILabel *)addressLabel
{
    if(!_addressLabel){
        UILabel *label = [UILabel createLabelWithText:@"成都市" font:kFontSize_26 textColor:kFontColorGray];
        [self.contentView addSubview:_addressLabel = label];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_icon_location"];
        [self.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.equalTo(label.mas_left).offset(WIDTH_TRANSFORMATION(-4));
        }];
    }
    return _addressLabel;
}

///消费提示
- (UILabel *)consumptionInfoLabel
{
    if(!_consumptionInfoLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费xx赠送xx积分" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_consumptionInfoLabel = label];
    }
    return _consumptionInfoLabel;
}


///乐豆抵扣
- (UIImageView *)leBeandikouImageView
{
    if(!_leBeandikouImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_ledou"];
        
        image.hidden = YES;
        [self.contentView addSubview:_leBeandikouImageView = image];
    }
    return _leBeandikouImageView;
}

@end
