//
//  QL_CustomSearchView.m
//  MenLi
//
//  Created by mini2 on 16/6/25.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "QL_CustomSearchView.h"

#import "QL_SearchViewIndexView.h"
#import "QL_InditorView.h"
#import "QL_SearchHeaderView.h"
#import "QL_SearchViewTableViewCell.h"
#import "QL_HotCityView.h"

@implementation QL_CustomSearchModel

@end

@interface QL_CustomSearchView()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    
    NSMutableDictionary *_mainTableViewDataSource; /**< 构造后的tableview的数据源 */
    NSMutableArray *_searchResultArray;      /**< 搜索结果 */
    NSMutableDictionary *_searchReultDictData;
    NSInteger _lastIndex;
    NSInteger _lastSearchIndex;
}

///搜索
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *searchBgView;
@property(strong, nonatomic) UIImageView *searchBgLineImage;

///顶部view
@property(nonatomic, weak) UIView *fixedView;
///热门城市
@property(nonatomic, weak) UIView *hotCityView;
///内容
@property (strong, nonatomic) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *searchSectionData;
///判断是否在搜索状态
@property (nonatomic, assign) BOOL isSearchingOrNot;
@property (nonatomic, strong) NSMutableArray *sectionData;
///索引栏
@property (nonatomic, strong) QL_SearchViewIndexView *custonIndexView;
@property (nonatomic, strong) QL_InditorView *inditorView;

@end

@implementation QL_CustomSearchView

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

-(void)dealloc
{
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
    
    [self.searchBar removeFromSuperview];
    [self setSearchBar:nil];
    [self.searchBgView removeFromSuperview];
    [self setSearchBgView:nil];
    [self.searchBgLineImage removeFromSuperview];
    [self setSearchBgLineImage:nil];
    [self.mainTableView removeFromSuperview];
    [self setMainTableView:nil];
}

-(void)initDefault
{
    self.backgroundColor = kCommonBackgroudColor;
    
    [self addSubview:self.searchBgView];
    [self.searchBgView addSubview:self.searchBar];
    [self.searchBgView addSubview:self.searchBgLineImage];
    [self addSubview:self.mainTableView];
    [self addSubview:self.custonIndexView];
    
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self).offset(FITWITH(-30));
        make.top.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.searchBgView);
        make.width.mas_equalTo(FITWITH(563/2));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(56));
    }];
    [self.searchBgLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.searchBgView);
        make.centerX.equalTo(self.searchBgView);
        make.bottom.equalTo(self.searchBgView);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.searchBgView.mas_bottom).offset(HEIGHT_TRANSFORMATION(26));
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self);
    }];
    [self.custonIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(FITWITH(30));
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self initializeUserDataSources];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods
- (void)initializeUserDataSources {
    _lastIndex = 0;
    _isSearchingOrNot = NO;
    _searchSectionData = [@[] mutableCopy];
    _searchReultDictData = [@{} mutableCopy];
    _sectionData = [@[] mutableCopy];
    _mainTableViewDataSource = [@{} mutableCopy];
    _searchResultArray = [@[] mutableCopy];
}

- (void)initializeUserInterface
{
    WEAKSelf;
    [self.custonIndexView setSelectedBlock:^(NSString *title, NSInteger index) {
        weakSelf.inditorView.inditorLable.text = title;
        
        if (!weakSelf.isSearchingOrNot) {
            if ([weakSelf.sectionData containsObject:title]) {
                [weakSelf.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[weakSelf.sectionData indexOfObject:title]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        } else {
            if ([weakSelf.searchSectionData containsObject:title]) {
                [weakSelf.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[weakSelf.searchSectionData indexOfObject:title]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        }
    }];
    
    [self addSubview:self.inditorView];
}

#pragma mark
#pragma mark -- private methods
- (void)dealDataSources {
    _searchReultDictData = [@{} mutableCopy];
    _searchSectionData = [@[] mutableCopy];
    
    if (_isSearchingOrNot) {
        
        for (QL_CustomSearchModel *model in _searchResultArray) {
            NSString *first_ch = [model.englishName substringToIndex:1];
            if ([_searchSectionData containsObject:first_ch]) {
                [[_searchReultDictData objectForKey:first_ch] addObject:model];
                
                [self sortedArray2ByArray:[_searchReultDictData objectForKey:first_ch]];
            } else {
                NSMutableArray *array = [@[] mutableCopy];
                [_searchSectionData addObject:first_ch];
                [array addObject:model];
                [_searchReultDictData setObject:array forKey:first_ch];
            }
            
        }
        
        
        [self sortedArrayByArray:_searchSectionData];
        [self.mainTableView reloadData];
        
        return;
    }
    
    [_sectionData removeAllObjects];
    [_mainTableViewDataSource removeAllObjects];
    
    for (QL_CustomSearchModel *model in self.dataSource) {
        NSString *first_ch = [[model.englishName substringToIndex:1] uppercaseString];
        if ([_sectionData containsObject:first_ch]) {
            [[_mainTableViewDataSource objectForKey:first_ch] addObject:model];
            
            [self sortedArray2ByArray:[_mainTableViewDataSource objectForKey:first_ch]];
        } else {
            NSMutableArray *array = [@[] mutableCopy];
            [_sectionData addObject:first_ch];
            [array addObject:model];
            [_mainTableViewDataSource setObject:array forKey:first_ch];
        }
    }
    
    
    [self sortedArrayByArray:_sectionData];
    [self.mainTableView reloadData];
}

- (void)sortedArrayByArray:(NSMutableArray *)array {
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        const char *stringAsChar1 = [obj1 cStringUsingEncoding:[NSString defaultCStringEncoding]];
        const char *stringAsChar2 = [obj2 cStringUsingEncoding:[NSString defaultCStringEncoding]];
        const char str1 = stringAsChar1[0];
        const char str2 = stringAsChar2[0];
        if (str1 > str2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (str1  < str2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)sortedArray2ByArray:(NSMutableArray *)array {
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        NSString *nameStr1 = [((QL_CustomSearchModel*)obj1).englishName stringByTrimmingCharactersInSet:set];
        NSString *nameStr2 = [((QL_CustomSearchModel*)obj2).englishName stringByTrimmingCharactersInSet:set];
        const char *stringAsChar1 = [nameStr1 cStringUsingEncoding:[NSString defaultCStringEncoding]];
        const char *stringAsChar2 = [nameStr2 cStringUsingEncoding:[NSString defaultCStringEncoding]];
        
        if(!stringAsChar1 || !stringAsChar2){
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        NSInteger count = nameStr1.length > nameStr2.length ? nameStr2.length : nameStr1.length;
        for(NSInteger i = 0; i < count; i++){
            const char str1 = stringAsChar1[i];
            const char str2 = stringAsChar2[i];
            if (str1 > str2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if (str1  < str2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

///设置搜索占位符
-(void)setSearchBarPlaceholder:(NSString*)placeholder
{
    self.searchBar.placeholder = placeholder;
}

///设置顶部固定view 热门城市view
-(void)setTopFixedView:(UIView*)view andHotCityView:(UIView *)hotCityView
{
    UIView *headerView = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, view.frame.size.height + hotCityView.frame.size.height + HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
    [headerView addSubview:_fixedView = view];
    [headerView addSubview:_hotCityView = hotCityView];
    self.mainTableView.tableHeaderView = headerView;
    
    //回调
    WEAKSelf;
    ((QL_HotCityView*)hotCityView).onDataLoadFinishBlock = ^(){
        UIView *headerView = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, weakSelf.fixedView.frame.size.height + weakSelf.hotCityView.frame.size.height + HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
        [headerView addSubview:weakSelf.fixedView];
        [headerView addSubview:weakSelf.hotCityView];
        weakSelf.mainTableView.tableHeaderView = headerView;
    };
    
    
    [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(110));
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self);
    }];
}

/// Change search bar background
-(void)setChangeSearchBarBackgroundImage:(NSString *)image
{
    UIImage *bgImage = [UIImage imageNamed:image];
    [self.searchBar setBackgroundImage:[DATAMODEL.henUtil reSizeImage:bgImage toSize:CGSizeMake(FITWITH(563/2), HEIGHT_TRANSFORMATION(56))]];
}

///更新ui
- (void)updateUI
{
    [self.mainTableView reloadData];
}

#pragma mark ----------------- action

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    if(self.onTableViewHeaderActionBlock){
        self.onTableViewHeaderActionBlock();
    }
}

#pragma mark ---------------- tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isSearchingOrNot) {
        return [_searchReultDictData[_searchSectionData[section]] count];
    }
    
    return [_mainTableViewDataSource[_sectionData[section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearchingOrNot) {
        return _searchSectionData.count;
    }
    return _sectionData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QL_SearchHeaderView *headerView = [[QL_SearchHeaderView alloc] init];

    if (_isSearchingOrNot) {
        headerView.title = _searchSectionData[section];
    } else {
        headerView.title = _sectionData[section];
    }
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_SearchViewTableViewCell *cell = [QL_SearchViewTableViewCell cellWithTableView:tableView];
    
    //分界线
    cell.topShortLineImage.hidden = NO;
    cell.topLongLineImage.hidden = YES;
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = NO;
    }
    //数据
    QL_CustomSearchModel *data;
    if (_isSearchingOrNot) {
        data = _searchReultDictData[_searchSectionData[indexPath.section]][indexPath.row];
    } else {
        
        data = _mainTableViewDataSource[_sectionData[indexPath.section]][indexPath.row];
    }
    cell.name = data.Name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return HEIGHT_TRANSFORMATION(70);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QL_SearchViewTableViewCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_isSearchingOrNot) {
        if ([_searchSectionData containsObject:title]) {
            for (NSUInteger i = 0; i < _searchSectionData.count - 1; i ++) {
                if ([_searchSectionData[i] isEqualToString:title]) {
                    _lastSearchIndex = i;
                    return i;
                }
            }
            return _lastSearchIndex;
        }
    } else {
        if ([_sectionData containsObject:title]) {
            for (NSUInteger i = 0; i < _sectionData.count - 1; i ++) {
                if ([_sectionData[i] isEqualToString:title]) {
                    _lastIndex = i;
                    return i;
                }
            }
        }
        return _lastIndex;
    }
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_CustomSearchModel* model;
    if (_isSearchingOrNot) {
        model = _searchReultDictData[_searchSectionData[indexPath.section]][indexPath.row];
    } else {
        model = _mainTableViewDataSource[_sectionData[indexPath.section]][indexPath.row];
    }
    
    if(self.customSearchChoiceItme){
        self.customSearchChoiceItme(model);
    }
}

#pragma mark -- searchbar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchResultArray = [@[] mutableCopy];
    if([searchText isEqualToString:@""]){
        _isSearchingOrNot = NO;
    }else{
        _isSearchingOrNot = YES;
        
        NSString *searchString = searchText;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [cd] %@", searchString];
        
        for (NSString *key in _sectionData) {
            for (QL_CustomSearchModel *model in _mainTableViewDataSource[key] ) {
                if ([predicate evaluateWithObject:model.Name]) {
                    [_searchResultArray addObject:model];
                    continue;
                }
                if ([predicate evaluateWithObject:model.englishName]) {
                    [_searchResultArray addObject:model];
                    continue;
                }
            }
        }
    }
    [self dealDataSources];
    [self.mainTableView reloadData];
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 修改UISearchBar右侧的取消按钮文字
    UIButton *button;
    // po recursiveDescription
    for (UIView *view in self.searchBar.subviews[0].subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            button = (UIButton *)view;
            if (button) {
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button setTitleClor:kFontColorGray];
                button.titleLabel.font = kFontSize_26;
                break;
            }
        }
    }
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = kFontColorGray;
    searchField.font = kFontSize_26;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;
}

#pragma mark ----------------- getter, setter

-(UIView*)searchBgView
{
    if(!_searchBgView){
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor = kCommonBackgroudColor;
    }
    return _searchBgView;
}

-(UISearchBar*)searchBar
{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        //修改搜索输入框内左侧的指示图标
        [_searchBar setImage:[UIImage imageNamed:@"public_icon_search2"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        // Change search bar background
        UIImage *bgImage = [UIImage imageNamed:@"public_icon_search_bg1"];
        [_searchBar setBackgroundImage:[DATAMODEL.henUtil reSizeImage:bgImage toSize:CGSizeMake(FITWITH(563/2), HEIGHT_TRANSFORMATION(56))]];
        for (UIView *view in _searchBar.subviews[0].subviews) {
            UIColor *color = nil;
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                color = view.backgroundColor;
            }
            for (UIView *backView in _searchBar.subviews[0].subviews[1].subviews) {
                if ([backView isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                    [backView removeFromSuperview];
                }
            }
        }
        
        // Get the instance of the UITextField of the search bar
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        // Change the search bar placeholder text color
        [searchField setValue:kFontColorGray forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}

-(UIImageView*)searchBgLineImage
{
    if(!_searchBgLineImage){
        _searchBgLineImage = [UIImageView createImageViewWithName:@"public_line"];
    }
    return _searchBgLineImage;
}

-(UITableView*)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [UITableView createTableViewWithDelegateTarget:self];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = kCommonBackgroudColor;
    }
    return _mainTableView;
}

- (QL_SearchViewIndexView *)custonIndexView {
    if (!_custonIndexView) {
        NSMutableArray *arr = [@[] mutableCopy];
        for (char a = 'A'; a <= 'Z'; a ++) {
            [arr addObject:[NSString stringWithFormat:@"%c", a]];
        }
        _custonIndexView = [[QL_SearchViewIndexView alloc] initWithTitleArray:arr];
        _custonIndexView.backgroundColor = [UIColor whiteColor];
        _custonIndexView.indexColor = kFontColorRed;
        _custonIndexView.indexFontSize = kFont_24;
        
        _inditorView = [[QL_InditorView  alloc] initWithFrame:CGRectMake(0, 0, FITHEIGHT(40), FITWITH(60))];
        _inditorView.center = CGPointMake(kMainScreenWidth / 2, kMainScreenHeight / 2);
        _custonIndexView.inditorView = _inditorView;
    }
    return _custonIndexView;
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:dataSource];
    
    [self dealDataSources];
}

@end
