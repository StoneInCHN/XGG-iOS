//
//  GC_ShopReplyCommentTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_ShopReplyCommentTableViewCell.h"

@interface GC_ShopReplyCommentTableViewCell ()<UITextViewDelegate>
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///输入回复内容
@property (nonatomic, weak) UITextView *inputTextView;

///回复内容
@property (nonatomic, weak) UILabel *commentLabel;
@end

@implementation GC_ShopReplyCommentTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ShopReplyCommentTableViewCell";
    GC_ShopReplyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[GC_ShopReplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
//+(CGFloat)getCellHeight
//{
//    
//}



///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(6));
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-16));
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.right.equalTo(self).offset(OffSetToRight);
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-60));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.content.length <= 0){
        self.inputTextView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content = textView.text;
    
    if(self.onInputFinishBlock){
        self.onInputFinishBlock(textView.text);
    }
    
    if(textView.text.length <= 0){
        self.inputTextView.text = self.placeholder;
    }
}


////隐藏键盘，实现UITextViewDelegate
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//
//{
//    if (textView.text.length >= self.maxCount && text.length > range.length)
//    {
//        return NO;
//    }
//    return YES;
//}


///回复信息输入 的显隐
- (void)setSellerReplyInputHidden:(BOOL)hidden
{
    self.titleLabel.hidden = hidden;
    self.inputTextView.hidden = hidden;
    if(hidden){
        self.commentLabel.hidden = NO;
    }else{
        self.commentLabel.hidden = YES;
    }
}



#pragma mark -- getter,setter
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"商家回复：" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

- (UITextView *)inputTextView
{
    if(!_inputTextView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.font = kFontSize_24;
        [textView setTextColor:kFontColorGray];
        [self.contentView addSubview:_inputTextView = textView];
    }
    return _inputTextView;
}

- (UILabel *)commentLabel
{
    if(!_commentLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorRed];
        [label lableAutoLinefeed];
        label.hidden = YES;
        [self.contentView addSubview:_commentLabel = label];
    }
    return _commentLabel;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    if(content.length > 0){
        self.inputTextView.text = content;
    }
}


-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if(self.content.length <= 0){
        self.inputTextView.text = placeholder;
    }
}

- (void)setSellerReplyInfo:(NSString *)sellerReplyInfo
{
    _sellerReplyInfo = sellerReplyInfo;
    self.commentLabel.text = [NSString stringWithFormat:@"商家回复：%@",sellerReplyInfo];
}
@end
