//
//  QL_SSLoadImageTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SSLoadImageTableViewCell.h"
#import "QL_UPCInputCommentPngCollectionViewCell.h"
#import "Hen_PhotoCollectManager.h"

#define Photo_Default   @"mine_comment_picture_add"


@interface QL_SSLoadImageTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Hen_PhotoCollectManagerDelegate>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///提示
@property(nonatomic, weak) UILabel *noticeLabel;
///图片
@property(nonatomic, weak) UICollectionView *collectionView;

///图片采集器
@property(nonatomic, strong) Hen_PhotoCollectManager *photoCollectManager;
///输入图片
@property(nonatomic, strong) NSMutableArray *inputImageArray;
///显示输入图片
@property(nonatomic, strong) NSMutableArray *showInputImageArray;

@end

@implementation QL_SSLoadImageTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SSLoadImageTableViewCell";
    QL_SSLoadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SSLoadImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(WIDTH_TRANSFORMATION(4));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150));
    }];
}

///设置提示显隐
- (void)setNoticeLabelHidden:(BOOL)hidden
{
    self.noticeLabel.hidden = hidden;
}

#pragma mark -- private

///更新图片输入
- (void)updateImageInputShow
{
    [self.showInputImageArray removeAllObjects];
    if(self.inputImageArray.count > 0){
        if(self.inputImageArray.count >= self.maxImageCount){ // 限制9张图片
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSInteger i = 0; i < self.maxImageCount; i++){
                [tempArray addObject:self.inputImageArray[i]];
            }
            [self.inputImageArray removeAllObjects];
            [self.inputImageArray addObjectsFromArray:tempArray];
        }
        [self.showInputImageArray addObjectsFromArray:self.inputImageArray];
        if(self.inputImageArray.count < self.maxImageCount){
            [self.showInputImageArray addObject:[UIImage imageNamed:Photo_Default]];
        }
    }else{
        [self.showInputImageArray addObject:[UIImage imageNamed:Photo_Default]];
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150 + 160 * ((self.showInputImageArray.count - 1)/4)));
    }];
    [self.collectionView reloadData];
    
    if(self.onPhotoCollectBlock){
        self.onPhotoCollectBlock(self.inputImageArray);
    }
}

#pragma mark -- Hen_PhotoCollectManagerDelegate

///成功采集照片
-(void)successCollectPhoto:(NSMutableArray<UIImage*>*)photos
{
    [self.inputImageArray addObjectsFromArray:photos];
    
    [self updateImageInputShow];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item >= self.inputImageArray.count){
        //显示图片采集
        [self.photoCollectManager showSelectInViewController:[DATAMODEL.henUtil getCurrentViewController]];
    }else{
        //显示大图
        [DATAMODEL.henUtil clickShowBigPicture:self.inputImageArray forView:self.contentView andCurrentTouch:indexPath.item];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showInputImageArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kMainScreenWidth - WIDTH_TRANSFORMATION(60) - 5 * WIDTH_TRANSFORMATION(20)) / 4, HEIGHT_TRANSFORMATION(150));
    return size;
}

///设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

///设置列间距，配合item宽度来设置
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return WIDTH_TRANSFORMATION(10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_UPCInputCommentPngCollectionViewCell *cell = [QL_UPCInputCommentPngCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateUIForImage:self.showInputImageArray[indexPath.item]];
    [cell setDeleteButtonHidden:YES];
    if(indexPath.item < self.inputImageArray.count){
        [cell setDeleteButtonHidden:NO];
    }
    //删除回调
    WEAKSelf;
    cell.onDeleteBlock = ^(){
        [weakSelf.inputImageArray removeObjectAtIndex:indexPath.item];
        [weakSelf updateImageInputShow];
    };
    
    return cell;
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///提示
- (UILabel *)noticeLabel
{
    if(!_noticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"(最大上传2000*2000的像素)" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_noticeLabel = label];
    }
    return _noticeLabel;
}

///图片
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self];
        collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView = collectionView];
        //注册
        [QL_UPCInputCommentPngCollectionViewCell registerCollectionView:collectionView];
        
    }
    return _collectionView;
}

///输入图片
- (NSMutableArray *)inputImageArray
{
    if(!_inputImageArray){
        _inputImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _inputImageArray;
}

///显示输入图片
- (NSMutableArray *)showInputImageArray
{
    if(!_showInputImageArray){
        _showInputImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_showInputImageArray addObject:[UIImage imageNamed:Photo_Default]];
    }
    return _showInputImageArray;
}

///图片采集器
- (Hen_PhotoCollectManager *)photoCollectManager
{
    if(!_photoCollectManager){
        _photoCollectManager = [[Hen_PhotoCollectManager alloc] init];
        _photoCollectManager.delegate = self;
        _photoCollectManager.maxPhotoCount = self.maxImageCount;
        if(self.maxImageCount == 1){
            _photoCollectManager.photoSize = 2000;
        }
    }
    return _photoCollectManager;
}

///设置标题
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setNotice:(NSString *)notice
{

    self.noticeLabel.text=notice;
}


@end
