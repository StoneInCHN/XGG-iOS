//
//  GC_LeBeanDeductibleTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/6/27.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  乐豆抵扣 - cell
//

#import "GC_LeBeanDeductibleTableViewCell.h"
#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"


@interface GC_LeBeanDeductibleTableViewCell ()<UITextFieldDelegate>
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///内容
@property (nonatomic, weak) UILabel *contentLabel;
///开关
@property (nonatomic, weak) UIButton *switchButton;
///输入框
@property (nonatomic, weak) UITextField *textField;

///说明
@property (nonatomic, weak) UIButton *leBeanDescButton;

@end

@implementation GC_LeBeanDeductibleTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_LeBeanDeductibleTableViewCell";
    GC_LeBeanDeductibleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_LeBeanDeductibleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(180);
}


///初始化
-(void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    
    [self.leBeanDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(54));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(30));
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.leBeanDescButton.mas_right);
    }];
    
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.titleLabel);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(85));
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
}

#pragma mark -- UITextFeildDelegate
///输入框 回调 方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
    if([textField.text floatValue] > [DATAMODEL.userInfoData.curLeBean floatValue]){
        [DATAMODEL.progressManager showHint:@"您的乐豆不足！"];
        textField.text = DATAMODEL.userInfoData.curLeBean;
    }
    
    
    if(self.onInputTextFieldBlock){
        self.onInputTextFieldBlock(textField.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField endEditing:YES];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -- private
///是否开启乐豆 抵扣
- (void)setIsOpenleBeanDeDuc:(BOOL)isDeDuc
{
    [self.switchButton setSelected:isDeDuc];
}

///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO
{
    self.textField.userInteractionEnabled = isNO;
}

#pragma mark -- action

///说明回调
- (void)onLeBeanDescAction:(UIButton *)sender
{
    
}

///开关回调
- (void)onSwitchAction:(UIButton *)sender
{
    
    if([self.contentInfo floatValue] <= 0){
        [DATAMODEL.progressManager showHint:HenLocalizedString(@"您当前乐豆为0，无法开启抵扣！")];
        return;
    }
    NSString *isSwitch = @"0";
    
    if(sender.isSelected){
        [sender setSelected:NO];
        isSwitch = @"1";
    }
    
    if(self.onSwitchBlock){
        self.onSwitchBlock(sender.isSelected,isSwitch);
    }
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"乐豆抵扣" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"乐豆余额：0.0000" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}




///说明
- (UIButton *)leBeanDescButton
{
    if(!_leBeanDescButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onLeBeanDescAction:)];
        [self.contentView addSubview:_leBeanDescButton = button];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_exclamatory"];
        [button addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
        }];
    }
    return _leBeanDescButton;
    
}

///开关
- (UIButton *)switchButton
{
    if(!_switchButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"homepage_switch_off" pressImage:@"homepage_switch_on" target:self action:@selector(onSwitchAction:)];
        [self.contentView addSubview:_switchButton = button];
    }
    return _switchButton;
}




///输入框

- (UITextField *)textField
{
    if(!_textField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = kFontSize_28;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textColor = kFontColorGray;
        textField.ry_inputType = RYFloatInputType;
        textField.ry_inputZeroBeginning = 1;
        textField.ry_floatDecimal = 4;
        [self.contentView addSubview:_textField = textField];
    }
    return _textField;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}


- (void)setInputInfo:(NSString *)inputInfo
{
    _inputInfo = inputInfo;
    self.textField.text = inputInfo;
}

- (void)setContentInfo:(NSString *)contentInfo
{
    _contentInfo = contentInfo;
    
    self.contentLabel.text = [NSString stringWithFormat:@"乐豆余额：%@",[DATAMODEL.henUtil string:contentInfo showDotNumber:4]];
}
@end
