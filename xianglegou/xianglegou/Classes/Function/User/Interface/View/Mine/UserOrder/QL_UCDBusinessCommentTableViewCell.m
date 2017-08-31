//
//  QL_UCDBusinessCommentTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UCDBusinessCommentTableViewCell.h"

@interface QL_UCDBusinessCommentTableViewCell()

///内容
@property(nonatomic, weak) UILabel *contentLabel;

@end

@implementation QL_UCDBusinessCommentTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_UCDBusinessCommentTableViewCell";
    QL_UCDBusinessCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_UCDBusinessCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-60));
    }];
}

#pragma mark -- getter,setter

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"商家回复：" font:kFontSize_24 textColor:kFontColorRed];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}


- (void)setSellerReplyInfo:(NSString *)sellerReplyInfo
{
    _sellerReplyInfo = sellerReplyInfo;
    if(sellerReplyInfo.length <= 0 || [sellerReplyInfo isEqualToString:@""]){
        self.contentLabel.text = @"  ";
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"商家回复：%@",sellerReplyInfo];
    }
    
}
@end
