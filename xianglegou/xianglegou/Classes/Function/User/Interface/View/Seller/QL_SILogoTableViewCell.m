//
//  QL_SILogoTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SILogoTableViewCell.h"
#import "Hen_PhotoCollectManager.h"

@interface QL_SILogoTableViewCell()<Hen_PhotoCollectManagerDelegate>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///logo背景
@property(nonatomic, weak) UIImageView *logoBgImage;
///logo
@property(nonatomic, weak) UIImageView *logoImage;
///下一步
@property(nonatomic, weak) UIImageView *nextImage;

///图片采集器
@property(nonatomic, strong) Hen_PhotoCollectManager *photoCollectManager;

@end

@implementation QL_SILogoTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SILogoTableViewCell";
    QL_SILogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SILogoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if(selected){
        [self.photoCollectManager showSelectInViewController:[DATAMODEL.henUtil getCurrentViewController]];
    }
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    [self.nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.contentView);
    }];
    [self.logoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImage).offset(WIDTH_TRANSFORMATION(-10));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(14));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-14));
        make.width.and.height.mas_equalTo(FITSCALE(104));
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.logoBgImage);
        make.width.and.height.mas_equalTo(FITSCALE(80));
    }];
}

///更新UI
- (void)updateUIForImage:(id)image
{
    if([image isKindOfClass:[NSString class]]){
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, image] defaultImageName:@"mine_shop"];
    }else if([image isKindOfClass:[UIImage class]]){
        self.logoImage.image = image;
    }
}

#pragma mark -- Hen_PhotoCollectManagerDelegate

///成功采集照片
-(void)successCollectPhoto:(NSMutableArray<UIImage*>*)photos
{
    self.logoImage.image = photos.firstObject;
    
    if(self.onPhotoCollectBlock){
        self.onPhotoCollectBlock(photos.firstObject);
    }
}

#pragma mark -- getter,setter

///logo背景
- (UIImageView *)logoBgImage
{
    if(!_logoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_head_bg_gray"];
        [self.contentView addSubview:_logoBgImage = image];
    }
    return _logoBgImage;
}

///logo
- (UIImageView *)logoImage
{
    if(!_logoImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_shop"];
        [image makeRadiusForWidth:FITSCALE(80)];
        [self.contentView addSubview:_logoImage = image];
    }
    return _logoImage;
}

///名称
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"店铺logo" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///下一步
- (UIImageView *)nextImage
{
    if(!_nextImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImage = image];
    }
    return _nextImage;
}

///图片采集器
- (Hen_PhotoCollectManager *)photoCollectManager
{
    if(!_photoCollectManager){
        _photoCollectManager = [[Hen_PhotoCollectManager alloc] init];
        _photoCollectManager.delegate = self;
        _photoCollectManager.maxPhotoCount = 1;
        _photoCollectManager.photoSize = 800;
    }
    return _photoCollectManager;
}

@end
