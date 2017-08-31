//
//  GC_IdentityCardInfoTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_IdentityCardInfoTableViewCell.h"

@interface GC_IdentityCardInfoTableViewCell ()<Hen_PhotoCollectManagerDelegate>

///说明
@property (nonatomic, weak) UILabel *descriptionLabel;

///边框图
@property (nonatomic, weak) UIImageView *frameImageView;
///背景图
@property (nonatomic, weak) UIImageView *bgImageView;


///身份证正面照片
@property (nonatomic, weak) UIImageView *positiveImageView;
///身份证背面照片
@property (nonatomic, weak) UIImageView *backImageView;

///图片采集器
@property(nonatomic, strong) Hen_PhotoCollectManager *photoCollectManager;


///添加图片
@property (nonatomic, weak) UIButton *addZMImageButton;
@property (nonatomic, weak) UILabel *addZMLabel;

@property (nonatomic, weak) UIButton *addBMImageButton;
@property (nonatomic, weak) UILabel *addBMLabel;


///删除 图片
@property (nonatomic, weak) UIButton *delZMImageButton;
@property (nonatomic, weak) UIButton *delBMImageButton;


///正面图
@property (nonatomic, weak) UIImage *positiveImage;
///背面图
@property (nonatomic, weak) UIImage *backImage;


///采集图片类型
@property (nonatomic, assign) NSInteger picType;
@end

@implementation GC_IdentityCardInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_IdentityCardInfoTableViewCell";
    
    GC_IdentityCardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_IdentityCardInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(840);
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.contentView).offset(FITSCALE(112/2));
        make.right.equalTo(self.contentView).offset(FITSCALE(-112/2));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(665));
    }];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.contentView).offset(FITSCALE(112/2));
        make.right.equalTo(self.contentView).offset(FITSCALE(-112/2));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(665));
    }];

    
    [self.positiveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView);
        make.left.equalTo(self.bgImageView);
        make.width.equalTo(self.bgImageView);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(331));
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bgImageView);
        make.top.equalTo(self.positiveImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(2));
        make.left.equalTo(self.bgImageView);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(332));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- action

///删除图片
- (void)onDeleteImageAction:(UIButton *)sender
{
    if(sender.tag == 1){            //正面图
        self.positiveImage = nil;
        
        self.delZMImageButton.hidden = YES;
        self.addZMImageButton.hidden = NO;
        self.addZMLabel.hidden = NO;

        
    }else if(sender.tag == 2){      //背面图
        self.backImage = nil;
        
        self.delBMImageButton.hidden = YES;
        self.addBMImageButton.hidden = NO;
        self.addBMLabel.hidden = NO;
    }
    
    [self updateImageInputShow];
}

///添加图片
- (void)onAddImageAction:(UIButton *)sender
{
    [self.photoCollectManager showSelectInViewController:[DATAMODEL.henUtil getCurrentViewController]];
    
    if(sender.tag == 1){             //正面图
        HenLog(@"添加正面图！");
        //显示图片采集
        self.picType = 1;
        
    }else if(sender.tag == 2){       //背面图
        HenLog(@"添加背面图！");
        self.picType = 2;
    }
}


///页面显示
- (void)updateImageInputShow
{
    [self.positiveImageView setImage:self.positiveImage];
    [self.backImageView setImage:self.backImage];
    
    //回调 正面
    if(self.onPositivePicBlock){
        self.onPositivePicBlock(self.positiveImage);
    }
    //回调 背面
    if(self.onBackPicBlock){
        self.onBackPicBlock(self.backImage);
    }
}


#pragma mark -- Hen_PhotoCollectManagerDelegate

///成功采集照片
-(void)successCollectPhoto:(NSMutableArray<UIImage*>*)photos
{
    if(self.picType == 1){
        
        self.delZMImageButton.hidden = NO;
        self.addZMImageButton.hidden = YES;
        self.addZMLabel.hidden = YES;
        
        self.positiveImage = photos.firstObject;
        
    }else if(self.picType == 2){
        
        self.delBMImageButton.hidden = NO;
        self.addBMImageButton.hidden = YES;
        self.addBMLabel.hidden = YES;
        
        self.backImage = photos.firstObject;
    }
    [self updateImageInputShow];
}


#pragma mark -- getter,setter
///说明
- (UILabel *)descriptionLabel
{
    if(!_descriptionLabel){
        UILabel *label = [UILabel createLabelWithText:@"请上传您本人真实有效的身份证照片，否则将会影响您的提现哦！" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_descriptionLabel = label];
    }
    return _descriptionLabel;
}


///边框图
- (UIImageView *)frameImageView
{
    if(!_frameImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bank_idcard_frame"];
        [self.contentView addSubview:_frameImageView = image];
    }
    return _frameImageView;
}


///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_bank_idcard_sample"];
        [self.contentView addSubview:_bgImageView = bgImage];
    }
    return _bgImageView;
}



///正面图
- (UIImageView *)positiveImageView
{
    if(!_positiveImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_positiveImageView = image];
        
        
        UIButton *delButton = [UIButton createButtonWithTitle:@"" normalImage:@"mine_comment_picture_delete1" pressImage:@"mine_comment_picture_delete1" target:self action:@selector(onDeleteImageAction:)];
        delButton.tag = 1;
        delButton.hidden = YES;
        [self.contentView addSubview:_delZMImageButton = delButton];
        

        
        UIButton *addButton = [UIButton createButtonWithTitle:@"" normalImage:@"mine_bank_idcard_add" pressImage:@"mine_bank_idcard_add" target:self action:@selector(onAddImageAction:)];
        addButton.tag = 1;
        [self.contentView addSubview:_addZMImageButton = addButton];
        
        
        UILabel *label = [UILabel createLabelWithText:@"上传身份证正面" font:kFontSize_28];
        [self.contentView addSubview:_addZMLabel = label];
        
        
        [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image);
            make.right.equalTo(image);
        }];
        
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image).offset(HEIGHT_TRANSFORMATION(65));
            make.centerX.equalTo(image);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(22));
            make.centerX.equalTo(image);
        }];
    }
    return _positiveImageView;
}

///背面图
- (UIImageView *)backImageView
{
    if(!_backImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_backImageView = image];
        
        
        
        UIButton *delButton = [UIButton createButtonWithTitle:@"" normalImage:@"mine_comment_picture_delete1" pressImage:@"mine_comment_picture_delete1" target:self action:@selector(onDeleteImageAction:)];
        delButton.tag = 2;
        delButton.hidden = YES;
        [self.contentView addSubview:_delBMImageButton = delButton];
        
        
        
        UIButton *addButton = [UIButton createButtonWithTitle:@"" normalImage:@"mine_bank_idcard_add" pressImage:@"mine_bank_idcard_add" target:self action:@selector(onAddImageAction:)];
        addButton.tag = 2;
        [self.contentView addSubview:_addBMImageButton = addButton];
        
        UILabel *label = [UILabel createLabelWithText:@"上传身份证反面" font:kFontSize_28];
        [self.contentView addSubview:_addBMLabel = label];
        
        
        [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image);
            make.right.equalTo(image);
        }];
        
        
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image).offset(HEIGHT_TRANSFORMATION(65));
            make.centerX.equalTo(image);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(22));
            make.centerX.equalTo(image);
        }];
    }
    return _backImageView;
}





///图片采集器
- (Hen_PhotoCollectManager *)photoCollectManager
{
    if(!_photoCollectManager){
        _photoCollectManager = [[Hen_PhotoCollectManager alloc] init];
        _photoCollectManager.delegate = self;
        _photoCollectManager.maxPhotoCount = 1;
        _photoCollectManager.photoSize = 1024;
    }
    return _photoCollectManager;
}


@end
