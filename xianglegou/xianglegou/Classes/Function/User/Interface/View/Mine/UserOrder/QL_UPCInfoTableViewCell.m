//
//  QL_UPCInfoTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UPCInfoTableViewCell.h"

@interface QL_UPCInfoTableViewCell()

///logo
@property(nonatomic, weak) UIImageView *logoImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///地址
@property(nonatomic, weak) UILabel *addressLabel;
///评分提示
@property(nonatomic, weak) UILabel *scoreNoticeLabel;
///评分按钮
@property(nonatomic, strong) NSMutableArray *commentButtonArray;
///地址图标
@property (nonatomic, weak) UIImageView *adrIconImageView;
@end

@implementation QL_UPCInfoTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_UPCInfoTableViewCell";
    QL_UPCInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_UPCInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.width.and.height.mas_equalTo(FITSCALE(40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(40));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(18));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    [self.scoreNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(45));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
    for(NSInteger i = 0; i < 5; i++){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"homepage_comment_star" pressImage:@"homepage_comment_star_choose" target:self action:@selector(onStarAction:)];
        button.tag = i+1;
        button.userInteractionEnabled = NO;
        [self.contentView addSubview:button];
        [self.commentButtonArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scoreNoticeLabel);
            make.right.equalTo(self.contentView).offset(-35 * (4-i));
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(80));
            make.width.mas_equalTo(35);
        }];
    }
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}





#pragma mark -- private
///更新 ui
-(void)setUpdateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data
{
    if(data){
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl ,data.seller.storePictureUrl] defaultImageName:@""];
        
        self.nameLabel.text = data.seller.name;
        self.addressLabel.text = data.seller.address;
    }
}


///更新商户评价 ui
-(void)setUpdateUiForEvaluateByOrderData:(GC_MResEvaluateByOrderDataModel*)data
{
    self.adrIconImageView.hidden = YES;
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
    }];
    
    [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.endUser.userPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
    
    self.nameLabel.text = data.endUser.nickName;
    
    ///支付金额
    if(data.order.amount.length <= 0 || [data.order.amount isEqualToString:@""]){
        data.order.amount = @"0";
    }
    NSString *payMoney = [NSString stringWithFormat:@"%@%@",@"支付金额：￥",data.order.amount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:payMoney];
    [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(5,data.order.amount.length + 1)];
    
    self.addressLabel.attributedText = str;
}

#pragma mark -- event response

///星级点击
- (void)onStarAction:(UIButton *)sender
{
    if(sender.isSelected){
        [sender setSelected:YES];
        
        for(NSInteger i = sender.tag; i < 5; i++){
            [((UIButton *)self.commentButtonArray[i]) setSelected:NO];
        }
        if(self.onCommentScoreBlock){
            self.onCommentScoreBlock(sender.tag);
        }
    }else{
        [sender setSelected:YES];
        for(NSInteger i = 0; i < sender.tag; i++){
            [((UIButton *)self.commentButtonArray[i]) setSelected:YES];
        }
        if(self.onCommentScoreBlock){
            self.onCommentScoreBlock(sender.tag);
        }
    }
}

#pragma mark -- getter,setter

///logo
- (UIImageView *)logoImage
{
    if(!_logoImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_logoImage = image];
    }
    return _logoImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///地址
- (UILabel *)addressLabel
{
    if(!_addressLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_addressLabel = label];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_icon_location"];
        [self.contentView addSubview:_adrIconImageView = image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.equalTo(label.mas_left).offset(WIDTH_TRANSFORMATION(-4));
        }];
    }
    return _addressLabel;
}

///评分提示
- (UILabel *)scoreNoticeLabel
{
    if(!_scoreNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"服务评分" font:kFontSize_28];
        [self.contentView addSubview:_scoreNoticeLabel = label];
    }
    return _scoreNoticeLabel;
}

///评分按钮
- (NSMutableArray *)commentButtonArray
{
    if(!_commentButtonArray){
        _commentButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentButtonArray;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    
    return image;
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    for(UIButton *button in self.commentButtonArray){
        button.userInteractionEnabled = isEdit;
    }
}

- (void)setScore:(NSString *)score
{
    _score = score;
    
    for (UIButton *button in self.commentButtonArray) {
        if(button.tag <= [score intValue]){
            [button setSelected:YES];
        }
    }
}
@end
