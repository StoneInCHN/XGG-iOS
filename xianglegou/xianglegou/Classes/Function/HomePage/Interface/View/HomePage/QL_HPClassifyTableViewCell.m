//
//  QL_HPClassifyTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPClassifyTableViewCell.h"
#import "QL_HPClassifyCollectionViewCell.h"

@interface QL_HPClassifyTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///内容
@property(nonatomic, weak) UICollectionView *collectionView;
///圆点
@property(nonatomic, weak) UIPageControl *page;
///当前位置
@property(nonatomic, assign) NSInteger currentItem;

///数据
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation QL_HPClassifyTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_HPClassifyTableViewCell";
    QL_HPClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_HPClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(280);
}

///初始化
- (void)initDefault
{
    self.backgroundColor = kCommonWhiteBg;
    [self unShowClickEffect];
    
    self.topLongLineImage.hidden = NO;
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(250));
        make.top.equalTo(self).offset(2);
    }];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(10));
    }];
}

///更新ui
- (void)updateUIForData:(NSMutableArray *)array
{
    [self.dataArray removeAllObjects];
    for(NSInteger i = 0; i < array.count / 10 + 1; i++){
        NSMutableArray *itemArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSInteger j = 0; j < 10; j++){
            if(j + i * 10 < array.count){
                [itemArray addObject:array[j + i * 10]];
            }else{
                break;
            }
        }
        [self.dataArray addObject:itemArray];
    }
    
    self.page.hidden = YES;
    if(self.dataArray.count > 1){
        self.page.hidden = NO;
        self.page.numberOfPages = self.dataArray.count;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

///滑动结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / kMainScreenWidth;
    self.page.currentPage = index;
    self.currentItem = index;
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(kMainScreenWidth, HEIGHT_TRANSFORMATION(250));
    return size;
}

///设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

///设置列间距，配合item宽度来设置
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_HPClassifyCollectionViewCell *cell = [QL_HPClassifyCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateUIForData:self.dataArray[indexPath.item]];
    
    return cell;
}

#pragma mark -- getter,setter

///内容
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self forScrollDirection:UICollectionViewScrollDirectionHorizontal];
        collectionView.pagingEnabled = YES;
        [self.contentView addSubview:_collectionView = collectionView];
        //注册
        [QL_HPClassifyCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}

///圆点
-(UIPageControl*)page
{
    if(!_page){
        UIPageControl *page = [UIPageControl createPageControl];
        page.numberOfPages = 0;
        page.currentPageIndicatorTintColor = kFontColorRed;
        page.pageIndicatorTintColor = kFontColorGray;
        [self addSubview:_page = page];
    }
    return _page;
}

///数据
- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

@end
