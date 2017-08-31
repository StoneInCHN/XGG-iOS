//
//  GC_TransactionAmountTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/1.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_TransactionAmountTableViewCell.h"

@interface GC_TransactionAmountTableViewCell ()
///背景图
@property (nonatomic, weak) UIImageView *bgImageView;

///标题
@property (nonatomic, strong) NSMutableArray *titleLabelArray;

///内容
@property (nonatomic, strong) NSMutableArray *contentLabelArray;


///内容
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

@implementation GC_TransactionAmountTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_TransactionAmountTableViewCell";
    GC_TransactionAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_TransactionAmountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(43);
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
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.bottom.equalTo(self.contentView);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -- private
///更新 ui
- (void)updateUiForTransactionAmount
{
    
    [self.contentArray removeAllObjects];
    
    [self.contentArray addObjectsFromArray:@[@[@"9.5折",@"￥0.0000"],@[@"8.5折",@"￥0.0000"],@[@"7.5折",@"￥0.0000"],@[@"6.5折",@"￥0.0000"]]];
    
    if(self.contentArray.count > 0){
        //清楚视图
        for (UILabel *label in self.titleLabelArray) {
            [label removeFromSuperview];
        }
        [self.titleLabelArray removeAllObjects];
        [self setTitleLabelArray:nil];
        
        for (UILabel *label in self.contentLabelArray) {
            [label removeFromSuperview];
        }
        [self.contentLabelArray removeAllObjects];
        [self setContentLabelArray:nil];
        
        
        UILabel *titleTempLabel;
        UILabel *contentTempLabel;
        for (NSInteger i = 0; i < self.contentArray.count; i ++) {
            //标题
            UILabel *titleLabel = [UILabel createLabelWithText:(NSString *)self.contentArray[i][0] font:kFontSize_28 textColor:kFontColorBlack];
            UIImageView *image = [UIImageView createImageViewWithName:@"mine_money"];
            [titleLabel addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(titleLabel.mas_left).offset(WIDTH_TRANSFORMATION(-8));
                make.bottom.equalTo(titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(2));
            }];
            [self.contentView addSubview:titleLabel];
            [self.titleLabelArray addObject:titleLabel];
            
            //内容
            UILabel *contentLabel = [UILabel createLabelWithText:(NSString *)self.contentArray[i][1] font:kFontSize_28 textColor:kFontColorBlack];
            [self.contentView addSubview:contentLabel];
            [self.contentLabelArray addObject:contentLabel];
            
            
            if(i == 0){
                if(self.contentArray.count == 1){
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(87));
                        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(28));
                        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-40));
                    }];
                    
                    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(-36));
                        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(28));
                        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-40));
                    }];

                }else{
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(87));
                        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(28));
                    }];
                    
                    
                    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(-36));
                        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(28));
                    }];
                }
                
            }else if(i == self.contentArray.count - 1){
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleTempLabel);
                    make.top.equalTo(titleTempLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(28));
                    make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-40));
                }];
                
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(contentTempLabel);
                    make.top.equalTo(contentTempLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(28));
                    make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-40));
                }];
            }else{
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleTempLabel);
                    make.top.equalTo(titleTempLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(28));
                }];
                
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(contentTempLabel);
                    make.top.equalTo(contentTempLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(28));
                }];
            }
            
            titleTempLabel = titleLabel;
            contentTempLabel = contentLabel;
        }
        
    }
    

    
    
}

#pragma mark -- getter,setter

///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_page2"];
//        image.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_bgImageView = image];
    }
    return _bgImageView;
}


///标题
- (NSMutableArray *)titleLabelArray
{
    if(!_titleLabelArray){
        _titleLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _titleLabelArray;
}


///内容
- (NSMutableArray *)contentLabelArray
{
    if(!_contentLabelArray){
        _contentLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _contentLabelArray;
}

- (NSMutableArray *)contentArray
{
    if(!_contentArray){
        _contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _contentArray;
}
@end
