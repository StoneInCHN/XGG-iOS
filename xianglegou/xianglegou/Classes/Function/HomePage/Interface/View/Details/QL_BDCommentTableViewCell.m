//
//  QL_BDCommentTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BDCommentTableViewCell.h"
#import "QL_BDConmmentPngCollectionViewCell.h"

@interface QL_BDCommentTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///头像
@property(nonatomic, weak) UIImageView *headImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///时间
@property(nonatomic, weak) UILabel *timeLabel;
///内容
@property(nonatomic, weak) UILabel *contentLabel;
///图片
@property(nonatomic, weak) UICollectionView *collectionView;

///数据
@property(nonatomic, strong) QL_BusinessCommentListDataModel *commentData;

///星级
@property(nonatomic, strong) NSMutableArray *starImageArray;

///回复评论
@property (nonatomic, weak) UILabel *replyCommentLabel;

@end

@implementation QL_BDCommentTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_BDCommentTableViewCell";
    QL_BDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_BDCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    self.backgroundColor = kCommonWhiteBg;
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(12));
        make.width.mas_equalTo(FITSCALE(83/2));
        make.height.mas_equalTo(FITSCALE(83/2));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(14));
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
    }];
    
    
    for(NSInteger i = 0; i < 5; i++){
        UIImageView *image = [self starImage];
        
        [self.starImageArray addObject:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timeLabel);
            make.right.equalTo(self.contentView).offset(-POSITION_WIDTH_FIT_TRANSFORMATION(47) * (4.7-i));
        }];
    }
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(130));
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-60));
//        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150));
    }];
    
    [self.replyCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
    }];
}

///更新UI
- (void)updateUIForData:(QL_BusinessCommentListDataModel *)data
{
    self.commentData = data;
    if(data){
        [self.headImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, data.endUser.userPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
        self.nameLabel.text = data.endUser.nickName;
        self.timeLabel.text = [DATAMODEL.henUtil timeStampToString:data.createDate];
        self.contentLabel.text = data.content;
        [self setStarScore:data.score];
        
        
        if(data.sellerReply.length <= 0){
            self.replyCommentLabel.hidden = YES;
            [self.replyCommentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(0));
            }];
        }else{
            self.replyCommentLabel.hidden = NO;
            [self.replyCommentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
            }];
            self.replyCommentLabel.text = [NSString stringWithFormat:@"商家回复：%@",data.sellerReply];
        }
        
        if(self.commentData.evaluateImages.count > 0){
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150 + 160 * ((self.commentData.evaluateImages.count - 1)/3)));
            }];
        }else{
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        if(self.onUpdateHeightBlock){
            self.onUpdateHeightBlock();
        }
    }
    
    [self.collectionView reloadData];
}
///设置星级分数
- (void)setStarScore:(NSString *)starScore
{
    
    //清除
    for(UIImageView *image in self.starImageArray){
        [image setImageForName:@"homepage_comment_star"];
    }
    
    
    CGFloat score = [starScore floatValue] > 5 ? 5 : [starScore floatValue];
    
    if(score <= 0){
        for (UIImageView *image in self.starImageArray) {
            image.hidden = YES;
        }
    }else{
        for (UIImageView *image in self.starImageArray) {
            image.hidden = NO;
        }
    }
    
    
    for(NSInteger i = 0; i < (int)score; i++){
        [((UIImageView*)self.starImageArray[i]) setImageForName:@"homepage_comment_star_choose"];
    }
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for(QL_EvaluateImageDataModel *model in self.commentData.evaluateImages){
        [array addObject:[NSString stringWithFormat:@"%@%@", PngBaseUrl,model.source]];
    }
    //点击显示大图
    [DATAMODEL.henUtil clickShowBigPicture:array forView:self.contentView andCurrentTouch:indexPath.item];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commentData.evaluateImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kMainScreenWidth - FITWITH(190/2) - 2 * WIDTH_TRANSFORMATION(20)) / 3, HEIGHT_TRANSFORMATION(150));
    return size;
}

///设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(20);
}

///设置列间距，配合item宽度来设置
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return WIDTH_TRANSFORMATION(10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_BDConmmentPngCollectionViewCell *cell = [QL_BDConmmentPngCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.pngUrl = ((QL_EvaluateImageDataModel *)self.commentData.evaluateImages[indexPath.item]).source;
    
    return cell;
}

#pragma mark -- getter,setter

///头像
- (UIImageView *)headImage
{
    if(!_headImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_head_bg_acquiescent"];
        [image makeRadiusForWidth:FITSCALE(83/2)];
        [self.contentView addSubview:_headImage = image];
    }
    return _headImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"Name" font:kFontSize_34];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *label = [UILabel createLabelWithText:@"2017-01-02" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_timeLabel = label];
    }
    return _timeLabel;
}

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"Content" font:kFontSize_26];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}

///图片
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self];
        collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView = collectionView];
        //注册
        [QL_BDConmmentPngCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}


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

///回复评论
- (UILabel *)replyCommentLabel
{
    if(!_replyCommentLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_26 textColor:kFontColorBlack];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_replyCommentLabel = label];
    }
    return _replyCommentLabel;
}
@end
