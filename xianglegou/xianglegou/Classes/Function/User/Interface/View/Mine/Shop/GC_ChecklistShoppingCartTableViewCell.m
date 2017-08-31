//
//  GC_ChecklistShoppingCartTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/12.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_ChecklistShoppingCartTableViewCell.h"

@interface GC_ChecklistShoppingCartTableViewCell ()
///复选框
@property (nonatomic, weak) UIButton *checkBoxButton;

///昵称
@property (nonatomic, weak) UILabel *nameLabel;
///删除按钮
@property (nonatomic, weak) UIButton *deleteButton;
///分割线
@property (nonatomic, weak) UIImageView *fgImageView;
///手机号
@property (nonatomic, weak) UILabel *mobileLabel;
///创建时间
@property (nonatomic, weak) UILabel *createDateLabel;
///让利金额
@property (nonatomic, weak) UILabel *noneOtherPriceLabel;
///消费金额
@property (nonatomic, weak) UILabel *payMoneyLabel;

///订单ID
@property (nonatomic, strong) NSString *orderId;
@end

@implementation GC_ChecklistShoppingCartTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ChecklistShoppingCartTableViewCell";
    GC_ChecklistShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_ChecklistShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(240);
}



///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.checkBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(37));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(37));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(90));
        make.centerY.equalTo(self.checkBoxButton);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.centerY.equalTo(self.checkBoxButton);
    }];
    
    [self.fgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.checkBoxButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(90));
        make.top.equalTo(self.fgImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mobileLabel);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
    }];
    
    [self.noneOtherPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(90));
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(90));
        make.top.equalTo(self.noneOtherPriceLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
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
///更新UI
- (void)updateUiForSellerOrderCartListData:(GC_MResSellerOrderCartListDataModel *)data
{
    if(data){
        //昵称
        self.nameLabel.text = data.endUser.nickName;
        //手机号
        self.mobileLabel.text = data.endUser.cellPhoneNum;
        //时间
        self.createDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        //让利金额
        self.noneOtherPriceLabel.text = [NSString stringWithFormat:@"让利金额：￥%@",data.rebateAmount];
        
        //消费金额
        NSString *text = [NSString stringWithFormat:@"消费金额：￥%@",data.amount];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(5,data.amount.length + 1)];
        
        self.payMoneyLabel.attributedText = str;
        [self setIsSelectedState:data.isSelected];
        
        
        self.orderId = data.id;
    }
}


///选中状态改变
-(void)setIsSelectedState:(BOOL)isSelected
{
    if(isSelected){
        [self.checkBoxButton setSelected:YES];
    }else{
        [self.checkBoxButton setSelected:NO];
    }
}


#pragma mark -- action
///复选框
- (void)onCheckBoxAction:(UIButton*)sender
{
    
    
    
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    if(self.onIsSelectedBlock){
        self.onIsSelectedBlock(sender.isSelected, sender.tag);
    }
    
}


///删除
- (void)onDeleteAction:(UIButton *)sender
{
    if(self.onDeletedUIButtonBlock){
        self.onDeletedUIButtonBlock(sender.tag, self.orderId);
    }
}

#pragma mark -- getter,setter
///复选框
- (UIButton *)checkBoxButton
{
    if(!_checkBoxButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"public_remind_select" pressImage:@"public_remind_select_choose" target:self action:@selector(onCheckBoxAction:)];
        [self.contentView addSubview:_checkBoxButton = button];
    }
    return _checkBoxButton;
}

///昵称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"王五" font:kFontSize_34];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///删除按钮
- (UIButton *)deleteButton
{
    if(!_deleteButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"public_delete" pressImage:@"public_delete" target:self action:@selector(onDeleteAction:)];
        [self.contentView addSubview:_deleteButton = button];
    }
    return _deleteButton;
}

///分割线
- (UIImageView *)fgImageView
{
    if(!_fgImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
        [self.contentView addSubview:_fgImageView = image];
    }
    return _fgImageView;
}


///手机号
- (UILabel *)mobileLabel
{
    if(!_mobileLabel){
        UILabel *label = [UILabel createLabelWithText:@"13540258546" font:kFontSize_28];
        [self.contentView addSubview:_mobileLabel = label];
    }
    return _mobileLabel;
}


///创建时间
- (UILabel *)createDateLabel
{
    if(!_createDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"2015-06-26" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_createDateLabel = label];
    }
    return _createDateLabel;
}


///让利金额
- (UILabel *)noneOtherPriceLabel
{
    if(!_noneOtherPriceLabel){
        UILabel *label = [UILabel createLabelWithText:@"让利金额：￥10" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_noneOtherPriceLabel = label];
    }
    return _noneOtherPriceLabel;
}


///消费金额
- (UILabel *)payMoneyLabel
{
    if(!_payMoneyLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费金额：￥30.5" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_payMoneyLabel = label];
    }
    return _payMoneyLabel;
}


@end
