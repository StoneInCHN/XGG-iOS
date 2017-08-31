//
//  GC_AddWarningTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/24.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_AddWarningTableViewCell.h"

@interface GC_AddWarningTableViewCell ()
///警告
@property (nonatomic, weak) UILabel *warningLabel;

@end

@implementation GC_AddWarningTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"Hen_BaseTableViewCell";
    GC_AddWarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_AddWarningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(100);
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///警告
- (UILabel *)warningLabel
{
    if(!_warningLabel){
        UILabel *label = [UILabel createLabelWithText:@"请确认手机号是店铺法人的手机号，否则店铺有可能绑定到别的会员账号，请慎重填写。" font:kFontSize_24 textColor:kFontColorRed];
        [label lableAutoLinefeed];
        
        NSString *labelText = label.text;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:HEIGHT_TRANSFORMATION(8)];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        label.attributedText = attributedString;
        [label sizeToFit];
        [self.contentView addSubview:_warningLabel = label];
    }
    return _warningLabel;
}
@end
