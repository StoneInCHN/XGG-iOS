//
//  QL_UPCInputCommentTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UPCInputCommentTableViewCell.h"
#import "QL_UPCInputCommentPngCollectionViewCell.h"
#import "Hen_PhotoCollectManager.h"

#define CommentContent_PlaceHole    @"请写下对商家服务的感受吧！"
#define Photo_Default   @"mine_comment_picture_add"
//#define Photo_Default   @"public_tool_bar_icon_homepage_choose"

@interface QL_UPCInputCommentTableViewCell()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Hen_PhotoCollectManagerDelegate>

///输入
@property(nonatomic, weak) UITextView *textView;
///图片
@property(nonatomic, weak) UICollectionView *collectionView;

///图片采集器
@property(nonatomic, strong) Hen_PhotoCollectManager *photoCollectManager;
///评价内容
@property(nonatomic, strong) NSString *commentContent;
///图片
@property(nonatomic, strong) NSMutableArray *imageArray;
///输入图片
@property(nonatomic, strong) NSMutableArray *inputImageArray;
///显示输入图片
@property(nonatomic, strong) NSMutableArray *showInputImageArray;

@end

@implementation QL_UPCInputCommentTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_UPCInputCommentTableViewCell";
    QL_UPCInputCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_UPCInputCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(180));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.textView.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150));
    }];
}

///更新UI
- (void)updateUIForCommentContent:(NSString *)content images:(NSMutableArray *)images
{
    self.textView.text = content;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *imageUrl in images) {
        [imageArray addObject:[NSString stringWithFormat:@"%@%@",PngBaseUrl,imageUrl]];
    }
    self.imageArray = imageArray;
    if(images.count > 0){
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(150 + 160 * ((images.count - 1)/4)));
        }];
    }else{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.collectionView reloadData];
}

#pragma mark -- private

///更新图片输入
- (void)updateImageInputShow
{
    [self.showInputImageArray removeAllObjects];
    if(self.inputImageArray.count > 0){
        if(self.inputImageArray.count >= 9){ // 限制9张图片
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSInteger i = 0; i < 9; i++){
                [tempArray addObject:self.inputImageArray[i]];
            }
            [self.inputImageArray removeAllObjects];
            [self.inputImageArray addObjectsFromArray:tempArray];
        }
        [self.showInputImageArray addObjectsFromArray:self.inputImageArray];
        if(self.inputImageArray.count < 9){
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

#pragma mark -- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.commentContent.length <= 0){
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.commentContent = textView.text;
    if(self.commentContent.length <= 0){
        textView.text = CommentContent_PlaceHole;
    }
    
    if(self.onCommentContentBlock){
        self.onCommentContentBlock(self.commentContent);
    }
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.imageArray){
        //显示大图
        [DATAMODEL.henUtil clickShowBigPicture:self.imageArray forView:self.contentView andCurrentTouch:indexPath.item];
    }else{
        if(indexPath.item >= self.inputImageArray.count){
            //显示图片采集
            [self.photoCollectManager showSelectInViewController:[DATAMODEL.henUtil getCurrentViewController]];
        }else{
            //显示大图
            [DATAMODEL.henUtil clickShowBigPicture:self.inputImageArray forView:self.contentView andCurrentTouch:indexPath.item];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.isEdit){
        return self.showInputImageArray.count;
    }
    return self.imageArray.count;
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
    
    if(self.isEdit){
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
    }else{
        [cell setDeleteButtonHidden:YES];
        [cell updateUIForImage:self.imageArray[indexPath.item]];
    }
    
    return cell;
}

#pragma mark -- getter,setter

///输入
- (UITextView *)textView
{
    if(!_textView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.text = CommentContent_PlaceHole;
        textView.textColor = kFontColorGray;
        textView.font = kFontSize_24;
        [self.contentView addSubview:_textView = textView];
    }
    return _textView;
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
        _photoCollectManager.maxPhotoCount = 9;
        _photoCollectManager.photoSize = 1024;
    }
    return _photoCollectManager;
}

///设置是否编辑
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;

    self.textView.userInteractionEnabled = isEdit;
}

@end
