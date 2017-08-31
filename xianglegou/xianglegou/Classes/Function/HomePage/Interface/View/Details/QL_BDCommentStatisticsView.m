//
//  QL_BDCommentStatisticsView.m
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BDCommentStatisticsView.h"

@interface QL_BDCommentStatisticsView()

///星级
@property(nonatomic, strong) NSMutableArray *starImageArray;
///评分
@property(nonatomic, weak) UILabel *scoreLabel;
///条数
@property(nonatomic, weak) UILabel *countLabel;
///下一步
@property(nonatomic, weak)  UIImageView *nextImage;

@end

@implementation QL_BDCommentStatisticsView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

- (void)dealloc
{
    [self.starImageArray removeAllObjects];
    [self setStarImageArray:nil];
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(70));
    self.backgroundColor = kCommonWhiteBg;
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    for(NSInteger i = 0; i < 5; i++){
        UIImageView *image = [self starImage];
        if(i == 0){
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(OffSetToLeft);
            }];
        }else{
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(((UIImageView*)self.starImageArray[i-1]).mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(14));
            }];
        }
        [self.starImageArray addObject:image];
    }
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(((UIImageView*)self.starImageArray.lastObject).mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(40));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-60));
    }];
    
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

///隐藏下一步
- (void)hiddenNextImage
{
    self.nextImage.hidden = YES;
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
    }];
}

#pragma mark -- getter,setter

///星级
- (NSMutableArray *)starImageArray
{
    if(!_starImageArray){
        _starImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _starImageArray;
}

///星星
- (UIImageView *)starImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"homepage_comment_star"];
    [self addSubview:image];
    
    return image;
}

///评分
- (UILabel *)scoreLabel
{
    if(!_scoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"0分" font:kFontSize_26 textColor:kFontColorRed];
        [self addSubview:_scoreLabel = label];
    }
    return _scoreLabel;
}

///条数
- (UILabel *)countLabel
{
    if(!_countLabel){
        UILabel *label = [UILabel createLabelWithText:@"条评论" font:kFontSize_24];
        [self addSubview:_countLabel = label];
        
        UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next"];
        [self addSubview:_nextImage = nextImage];
        [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.left.equalTo(label.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(8));
        }];
    }
    return _countLabel;
}

- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self addSubview:image];
    
    return image;
}

///设置星级分数
- (void)setStarScore:(NSString *)starScore
{
    CGFloat score = [starScore floatValue] > 5 ? 5 : [starScore floatValue];
    for(NSInteger i = 0; i < (int)score; i++){
        [((UIImageView*)self.starImageArray[i]) setImageForName:@"homepage_comment_star_choose"];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分", starScore.length > 0 ? starScore : @"0"];
}

///设置评论总数
- (void)setCommentTotal:(NSString *)commentTotal
{
    _commentTotal = commentTotal;
    if([commentTotal isEqualToString:@""]){
        self.countLabel.text = @"0条评论";
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"%@条评论", commentTotal];
    }
}

@end
