//
//  QL_SSLoadLogoTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SSLoadLogoTableViewCell.h"
#import "Hen_PhotoCollectManager.h"

@interface QL_SSLoadLogoTableViewCell()<Hen_PhotoCollectManagerDelegate>

///预览图片
@property(nonatomic, weak) UIImageView *previewImage;
///添加标示图片
@property(nonatomic, weak) UIImageView *addMarkImage;
///提示
@property(nonatomic, weak) UILabel *noticeLabel;

///图片采集器
@property(nonatomic, strong) Hen_PhotoCollectManager *photoCollectManager;

@end

@implementation QL_SSLoadLogoTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SSLoadLogoTableViewCell";
    QL_SSLoadLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SSLoadLogoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected){
        //显示图片采集
        [self.photoCollectManager showSelectInViewController:[DATAMODEL.henUtil getCurrentViewController]];
    }
    // Configure the view for the selected state
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.addMarkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(100));
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.addMarkImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.previewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(440));
    }];
}

#pragma mark -- Hen_PhotoCollectManagerDelegate

///成功采集照片
-(void)successCollectPhoto:(NSMutableArray<UIImage*>*)photos
{
    self.previewImage.image = photos.firstObject;
    
    if(self.onPhotoCollectBlock){
        self.onPhotoCollectBlock(photos.firstObject);
    }
}

#pragma mark -- getter,setter

///预览图片
- (UIImageView *)previewImage
{
    if(!_previewImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_previewImage = image];
    }
    return _previewImage;
}

///添加标示图片
- (UIImageView *)addMarkImage
{
    if(!_addMarkImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_shop_system_image"];
        [self.contentView addSubview:_addMarkImage = image];
    }
    return _addMarkImage;
}

///提示
- (UILabel *)noticeLabel
{
    if(!_noticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"请上传店铺logo或店铺图片" font:kFontSize_28];
        [self.contentView addSubview:_noticeLabel = label];
    }
    return _noticeLabel;
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
