//
//  GC_BankCardMobileInfoTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BankCardMobileInfoTableViewCell.h"

@interface GC_BankCardMobileInfoTableViewCell ()
//提示信息
@property (nonatomic, weak) UILabel *promptLabel;

@end

@implementation GC_BankCardMobileInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_BankCardMobileInfoTableViewCell";
    GC_BankCardMobileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_BankCardMobileInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


///获取cell高度
+(CGFloat)getCellHeightForContent:(NSString*)content
{
    NSString *str = [NSString stringWithFormat:@"绑定银行卡需要短信确认，验证码已发送至手机：%@，请按提示操作。",content];
    
    CGFloat worldHeight = [[Hen_Util getInstance] calculationHeightForString:str anTextWidth:kMainScreenWidth - FITSCALE(110) anFont:kFontSize_24];
    
    CGFloat cellHeight = HEIGHT_TRANSFORMATION(24) + worldHeight;
    
    return cellHeight > HEIGHT_TRANSFORMATION(80) ? cellHeight : HEIGHT_TRANSFORMATION(80);
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
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FITSCALE(110/2));
        make.right.equalTo(self.contentView).offset(FITSCALE(-110/2));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(12));
//        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-12));
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -- getter,setter
- (UILabel *)promptLabel
{
    if(!_promptLabel){
        UILabel *label = [UILabel createLabelWithText:@"绑定银行卡需要短信确认，验证码已发送至手机：19548254569，请按提示操作。" font:kFontSize_24 textColor:kFontColorGray];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_promptLabel = label];
    }
    return _promptLabel;
}

- (void)setMobileInfo:(NSString *)mobileInfo
{
    _mobileInfo = mobileInfo;
    self.promptLabel.text = [NSString stringWithFormat:@"绑定银行卡需要短信确认，验证码已发送至手机：%@，请按提示操作。",mobileInfo];
    
}


@end
