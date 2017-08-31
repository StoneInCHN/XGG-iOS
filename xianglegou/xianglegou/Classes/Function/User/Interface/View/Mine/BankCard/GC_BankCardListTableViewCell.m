//
//  GC_BankCardListTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BankCardListTableViewCell.h"

@interface GC_BankCardListTableViewCell ()
///背景
@property (nonatomic, weak) UIImageView *bgImageView;
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///名称
@property (nonatomic, weak) UILabel *nameLabel;
///类型
@property (nonatomic, weak) UILabel *typeLabel;
///卡号
@property (nonatomic, weak) UILabel *cardNoLabel;
///设置默认卡
@property (nonatomic, weak) UIButton *setUpDefaultButton;
///删除按钮
@property (nonatomic, weak) UIButton *deleteButton;

///银行卡ID
@property (nonatomic, strong) NSString *cardId;
@end

@implementation GC_BankCardListTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_BankCardListTableViewCell";
    GC_BankCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_BankCardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(162);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.contentView.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(20));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(116));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(72));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(15));
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-190));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(15));
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-21));
    }];
    
    [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-21));
    }];
    
    [self.setUpDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-13));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.setUpDefaultButton);
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-21));
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
-(void)updateUiForMyCardListData:(GC_MResBankCardMyCardListDataModel *)data
{
    if(data){
        //图标
        ///[self.iconImageView sd_setImageWithUrlString:data.bankLogo defaultImageName:@""];
        
        //名称
        self.nameLabel.text = data.bankName;
        //类型
        self.typeLabel.text = data.cardType;
        
        //卡号
        
        self.cardNoLabel.text = [DATAMODEL.henUtil getStringLastThree:data.cardNum andCharNum:4];
        //是否是默认银行卡
        
        
        if([data.isDefault isEqualToString:@"1"]){      //
            [self.setUpDefaultButton setSelected:YES];
        }else{
            [self.setUpDefaultButton setSelected:NO];
        }
        
        self.cardId = data.id;
    }
}


///屏蔽
- (void)setShieldFeatures
{
    self.deleteButton.hidden = YES;
    self.setUpDefaultButton.hidden = YES;
}


///设置为默认提现卡
- (void)onSetUpDefaultAction:(UIButton *)sender
{
    if(sender.isSelected){
        [sender setSelected:YES];
    }else{
        if(self.onSetUpDefault){
            self.onSetUpDefault(self.cardId, sender.tag);
        }
    }
    
    
    
}

///删除 按钮回调
- (void)onDeleteAction:(UIButton *)sender
{
    WEAKSelf;
     [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要删除此账号吗？删除后不可恢复！"];
     
     [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
         if(buttonIndex == 0){
             [weakSelf onDeleteBankInfo];
         }
     }];
}


///删除银行卡 方法
- (void)onDeleteBankInfo
{
    //参数
    [self.viewModel.delBankCardParm setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.delBankCardParm setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.delBankCardParm setObject:self.cardId forKey:@"entityId"];
    WEAKSelf;
    [self.viewModel setDelBankCardDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            if(weakSelf.onDeleteSuccessBlock){
                weakSelf.onDeleteSuccessBlock();
            }
            
        }else{
            [DATAMODEL.progressManager showHint:desc];
        }
    }];
}

#pragma mark -- getter,setter
///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_bank2"];
        [self.contentView addSubview:_bgImageView = bgImage];
    }
    return _bgImageView;
}

///图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bank_card"];
        ///[image makeRadiusForWidth:HEIGHT_TRANSFORMATION(110)];
        [self.contentView addSubview:_iconImageView = image];
    }
    return _iconImageView;
}

///名称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///类型
- (UILabel *)typeLabel
{
    if(!_typeLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_typeLabel = label];
    }
    return _typeLabel;
}


///卡号
- (UILabel *)cardNoLabel
{
    if(!_cardNoLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_cardNoLabel = label];
    }
    return _cardNoLabel;
}

///设置默认
- (UIButton *)setUpDefaultButton
{
    if(!_setUpDefaultButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onSetUpDefaultAction:)];
        [button setTitle:@" 设为默认提现卡" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mine_choose_no"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mine_choose"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"mine_choose"] forState:UIControlStateSelected];
        [self.contentView addSubview:_setUpDefaultButton = button];
    }
    return _setUpDefaultButton;
}

///删除 按钮
- (UIButton *)deleteButton
{
    if(!_deleteButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"删除" target:self action:@selector(onDeleteAction:)];
        [button setTitleClor:kFontColorRed];
        [self.contentView addSubview:_deleteButton = button];
    }
    return _deleteButton;
}

@end


