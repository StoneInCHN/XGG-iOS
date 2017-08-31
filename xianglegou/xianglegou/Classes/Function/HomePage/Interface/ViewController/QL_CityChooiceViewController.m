//
//  QL_CityChooiceViewController.m
//  Peccancy
//
//  Created by mini2 on 16/10/26.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "QL_CityChooiceViewController.h"
#import "QL_HotCityView.h"

@interface QL_CityChooiceViewController ()

///搜索界面
@property(nonatomic, strong) QL_CustomSearchView* searchView;

///定位城市
@property(nonatomic, strong) UILabel *loctionCityLabel;
///热门城市view
@property(nonatomic, strong) QL_HotCityView *hotCityView;

///地区数据
@property(nonatomic, strong) NSMutableArray<QL_AreaDataModel*> *areaDatas;
///选择数据
@property(nonatomic, strong) NSMutableArray *selectAreaDatas;

@end

@implementation QL_CityChooiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kCommonBackgroudColor;
    
    if(self.barTitel.length <= 0){
        self.navigationItem.title = @"城市";
    }
    
    [self loadSubView];
    [self loadData];
    [self getLoctionCity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [DATAMODEL.baiduMapUtil cleanMap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [DATAMODEL.baiduMapUtil cleanMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- override

///清除数据
-(void)cleanUpData
{
    [self.areaDatas removeAllObjects];
    [self setAreaDatas:nil];
    [self.selectAreaDatas removeAllObjects];
    [self setSelectAreaDatas:nil];
}

///清除强引用视图
-(void)cleanUpStrongSubView
{
    [self.searchView removeFromSuperview];
    [self setSearchView:nil];
    [self.loctionCityLabel removeFromSuperview];
    [self setLoctionCityLabel:nil];
}

#pragma mark -- private

-(void)loadSubView
{
    [self.view addSubview:self.searchView];

    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

///加载数据
-(void)loadData
{
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [DATAMODEL.henUtil asynchronousLoadingBlock:^{
        //获取城市数据
        weakSelf.areaDatas = [DATAMODEL.configDBHelper getCityDatas];
        //数据转换
        for(QL_AreaDataModel *data in weakSelf.areaDatas){
            QL_CustomSearchModel *model = [[QL_CustomSearchModel alloc] init];
            model.Id = ((QL_AreaDataModel*)data).areaId;
            model.Name = ((QL_AreaDataModel*)data).name;
            model.englishName = ((QL_AreaDataModel*)data).zhName;
            [self.selectAreaDatas addObject:model];
        }
        
    } finishBlock:^{
        //取消加载
        [weakSelf hideHud];
        [weakSelf.searchView setDataSource:weakSelf.selectAreaDatas];
    }];
    
    [self.hotCityView loadHotCityData];
}

///获取定位
-(void)getLoctionCity
{
    if(DATAMODEL.locationCityName.length <= 0){
        [self location];
    }else{
        self.loctionCityLabel.text = DATAMODEL.locationCityName;
    }
}

///定位
-(void)location
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){ // 未开启权限
        self.loctionCityLabel.text = @"失败，请重试";
    }else{
        self.loctionCityLabel.text = @"定位中...";
        
        //回调
        WEAKSelf;
        DATAMODEL.baiduMapUtil.onLocationCityBlock = ^(NSString* cityName){
            weakSelf.loctionCityLabel.text = [cityName isEqualToString:@""] ? @"失败，请重试" : cityName;
            DATAMODEL.locationCityName = cityName;
        };
        [DATAMODEL.baiduMapUtil loadLocation];
    }
    
}

///点击定位
- (void)clickLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){ // 未开启权限
        self.loctionCityLabel.text = @"失败，请重试";
        //提示
        [DATAMODEL.alertManager showCustomButtonTitls:@[@"暂不", @"去设置"] message:@"定位服务未开启，请在系统设置中开启定位服务。"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
    }else{
        self.loctionCityLabel.text = @"定位中...";
        
        //回调
        WEAKSelf;
        DATAMODEL.baiduMapUtil.onLocationCityBlock = ^(NSString* cityName){
            weakSelf.loctionCityLabel.text = [cityName isEqualToString:@""] ? @"失败，请重试" : cityName;
            DATAMODEL.locationCityName = cityName;
        };
        [DATAMODEL.baiduMapUtil loadLocation];
    }
}

#pragma mark -- event response

-(void)onLoctionClickAction:(id)sender
{
    //定位城市
    NSString *city = self.loctionCityLabel.text;
    if([city isEqualToString:@"失败，请重试"]){
        [self clickLocation];
    }else if([city isEqualToString:@"定位中..."]){
        
    }else{
        QL_AreaDataModel *data = [[QL_AreaDataModel alloc] initWithDictionary:@{}];
        
        data.name = city;
        data.areaId = [DATAMODEL.configDBHelper getCityIdForCityName:city];
        if(self.onChoiceItemBlock){
            self.onChoiceItemBlock(data);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ---------------------getter, setter

-(QL_CustomSearchView*)searchView
{
    if(!_searchView){
        _searchView = [[QL_CustomSearchView alloc] init];
        [_searchView setTopFixedView:[self loactionView] andHotCityView:self.hotCityView];
        [_searchView setChangeSearchBarBackgroundImage:@"public_icon_search_bg2"];
        //设置回调
        WEAKSelf;
        _searchView.customSearchChoiceItme = ^(QL_CustomSearchModel* model){
            
            if(weakSelf.onChoiceItemBlock){
                for(QL_AreaDataModel *data in weakSelf.areaDatas){
                    if([data.areaId isEqualToString:model.Id]){
                        weakSelf.onChoiceItemBlock(data);
                        break;
                    }
                }
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _searchView;
}

-(UIView*)loactionView
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(100)) backgroundColor:kCommonWhiteBg];
    
    UIImageView *iconImage = [UIImageView createImageViewWithName:@"public_icon_location"];
    [view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    UILabel *label = [UILabel createLabelWithText:@"自动定位" font:kFontSize_26 textColor:kFontColorGray];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(iconImage.mas_right).offset(WIDTH_TRANSFORMATION(10));
    }];
    
    self.loctionCityLabel = [UILabel createLabelWithText:@"" font:kFontSize_26];
    [view addSubview:self.loctionCityLabel];
    [self.loctionCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(WIDTH_TRANSFORMATION(200));
    }];
    
    UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
    [view addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view);
        make.centerX.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoctionClickAction:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:singleTap];
    
    return view;
}

///热门城市view
- (QL_HotCityView *)hotCityView
{
    if(!_hotCityView){
        _hotCityView = [[QL_HotCityView alloc] init];
        //回调
        WEAKSelf;
        _hotCityView.onSelectBlock = ^(NSString *cityId){
            QL_AreaDataModel *data = [[QL_AreaDataModel alloc] initWithDictionary:@{}];
            
            data.name = [DATAMODEL.configDBHelper getCityNameForCityId:cityId];
            data.areaId = cityId;
            if(weakSelf.onChoiceItemBlock){
                weakSelf.onChoiceItemBlock(data);
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _hotCityView;
}

-(NSMutableArray<QL_AreaDataModel*>*)areaDatas
{
    if(!_areaDatas){
        _areaDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _areaDatas;
}

-(NSMutableArray*)selectAreaDatas
{
    if(!_selectAreaDatas){
        _selectAreaDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectAreaDatas;
}

-(void)setBarTitel:(NSString *)barTitel
{
    _barTitel = barTitel;
    if(barTitel.length > 0){
        self.navigationItem.title = barTitel;
    }else{
        self.navigationItem.title = @"城市";
    }
}

@end
