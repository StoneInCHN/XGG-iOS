//
//  QL_ShopInformationViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ShopInformationViewController.h"
#import "QL_ItemTableViewCell.h"
#import "QL_SILoadImageTableViewCell.h"
#import "QL_SSInfoInputTableViewCell.h"
#import "QL_SILogoTableViewCell.h"
#import "QL_SIBusinessHoursTableViewCell.h"
#import "QL_SIOtherServiceTableViewCell.h"
#import "QL_DetailsAddressInputTableViewCell.h"

#import "QL_ShopInformationViewModel.h"
#import "QL_ShopAddressLocationViewController.h"
#import "QL_AreaPickerView.h"


@interface QL_ShopInformationViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///完成按钮
@property(nonatomic, weak) UIButton *finishButton;

///标题
@property(nonatomic, strong) NSMutableArray *titleArray;
///view model
@property(nonatomic, strong) QL_ShopInformationViewModel *viewModel;
///地区选择view
@property(nonatomic, strong) QL_AreaPickerView *areaPickerView;
///显示地区
@property(nonatomic, strong) NSString *showArae;

///是否修改
@property(nonatomic, assign) BOOL isEdit;

@end

@implementation QL_ShopInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
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
- (void)cleanUpData
{
    [self setViewModel:nil];
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

- (void)onGoBackClick:(id)sender
{
    if(self.isEdit){
        //提示
        [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要返回吗？返回后资料将被清空。"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){ // 确定
                [super onGoBackClick:sender];
            }
        }];
    }else{
        [super onGoBackClick:sender];
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"店铺信息";
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.finishButton.mas_top);
    }];
    
    [self initMapUitl];
}

///获取经纬度
- (void)getLongitudeLatitude
{
    [DATAMODEL.baiduMapUtil mapSearchForAddress:[NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.editParam.address]];
}

///地址定位
- (void)addressLocation
{
    QL_ShopAddressLocationViewController *alVC = [[QL_ShopAddressLocationViewController alloc] init];
    alVC.hidesBottomBarWhenPushed = YES;
    alVC.longitude = self.viewModel.editParam.longitude;
    alVC.latitude = self.viewModel.editParam.latitude;
    alVC.address = [NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.editParam.address];
    alVC.sellerName = self.viewModel.editParam.sellerName;
    //回调
    WEAKSelf;
    alVC.onFinishWithAreaBlock = ^(NSString *longitude, NSString *latitude, NSString *address, NSString *proName, NSString *cityName, NSString *areaName){
        weakSelf.viewModel.editParam.longitude = longitude;
        weakSelf.viewModel.editParam.latitude = latitude;
        
        if(![areaName isEqualToString:@""]){
            NSString *areaId = [DATAMODEL.configDBHelper getCityIdForCityName:areaName];
            if(![areaId isEqualToString:@""]){
                weakSelf.viewModel.editParam.areaId = areaId;
                if([proName isEqualToString:cityName]){
                    weakSelf.showArae = [NSString stringWithFormat:@"%@%@", proName, areaName];
                }else{
                    weakSelf.showArae = [NSString stringWithFormat:@"%@%@%@", proName, cityName, areaName];
                }
            }
        }else if([cityName isEqualToString:@""]){
            NSString *areaId = [DATAMODEL.configDBHelper getCityIdForCityName:cityName];
            if(![areaId isEqualToString:@""]){
                weakSelf.viewModel.editParam.areaId = areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@", proName, cityName];
            }
        }
        
        weakSelf.viewModel.editParam.address = [address stringByReplacingOccurrencesOfString:weakSelf.showArae withString:@""];
        
        [weakSelf.tableView reloadData];
        
        weakSelf.isEdit = YES;
    };
    
    [self.navigationController pushViewController:alVC animated:YES];
}

#pragma mark -- event response

- (void)onFinishAction:(UIButton *)sender
{
    //默认1元
    if([self.viewModel.editParam.avgPrice isEqualToString:@""]){
        self.viewModel.editParam.avgPrice = @"1";
    }
    //检查
    if(self.viewModel.editParam.storePhone.length <= 0 ||
       self.viewModel.editParam.sellerName.length <= 0 ||
       self.viewModel.editParam.address.length <= 0){
        //提示
        [self showHint:@"资料未填写完整！"];
        return;
    }
    self.viewModel.editParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.editParam.token = DATAMODEL.token;
    self.viewModel.editParam.address = [NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.editParam.address];
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.viewModel editShopInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            //提示
            [weakSelf showHint:@"成功！"];
            weakSelf.isEdit = NO;
            if(weakSelf.onEditSuccessBlock){
                weakSelf.onEditSuccessBlock();
            }
            //[weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.titleArray[indexPath.row];
    if([title isEqualToString:@"店铺所在地"]){
//        [self.areaPickerView showPickerView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSelf;
    NSString *title = self.titleArray[indexPath.row];
    
    if([title isEqualToString:@"店铺logo"]){
        QL_SILogoTableViewCell *cell = [QL_SILogoTableViewCell cellWithTableView:tableView];
        
        if(self.viewModel.logoImage){
            [cell updateUIForImage:self.viewModel.logoImage];
        }else{
            [cell updateUIForImage:self.shopInfoData.storePictureUrl];
        }
        //回调
        cell.onPhotoCollectBlock = ^(UIImage *images){
            weakSelf.viewModel.logoImage = images;
            
            weakSelf.isEdit = YES;
        };
        cell.bottomLongLineImage.hidden = NO;
        cell.topLongLineImage.hidden = NO;
        
        return cell;
    }else if([title isEqualToString:@"环境照片"]){
        QL_SILoadImageTableViewCell *cell = [QL_SILoadImageTableViewCell cellWithTableView:tableView];
        
        [cell setNoticeLabelHidden:YES];
        cell.title = title;
        cell.maxImageCount = 4;
        cell.bottomLongLineImage.hidden = NO;
        [cell updateUIForImageArray:self.shopInfoData.envImgs];
        //回调
        cell.onPhotoCollectBlock = ^(NSMutableArray *images){
            weakSelf.viewModel.environmentalPhotos = images;
            
            weakSelf.isEdit = YES;
        };
        
        return cell;
    }else if([title isEqualToString:@"店铺简介"]){
        QL_SSInfoInputTableViewCell *cell = [QL_SSInfoInputTableViewCell cellWithTableView:tableView];
        
        cell.content = self.viewModel.editParam.note;
        [cell hiddenNotice];
        //回调
        cell.onInfoContentBlock = ^(NSString *content){
            weakSelf.viewModel.editParam.note = content;
            
            weakSelf.isEdit = YES;
        };
        
        return cell;
    }else if([title isEqualToString:@"营业时段"]){
        QL_SIBusinessHoursTableViewCell *cell = [QL_SIBusinessHoursTableViewCell cellWithTableView:tableView];
        
        //回调
        cell.onSelectBlock = ^(NSString *businessHours){
            weakSelf.viewModel.editParam.businessTime = businessHours;
            
            weakSelf.isEdit = YES;
        };
        [cell updateUIForTime:self.viewModel.editParam.businessTime];
        
        return cell;
    }else if([title isEqualToString:@"其他服务"]){
        QL_SIOtherServiceTableViewCell *cell = [QL_SIOtherServiceTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForService:self.viewModel.editParam.featuredService];
        //回调
        cell.onSelectBlock = ^(NSString *select){
            weakSelf.viewModel.editParam.featuredService = select;
            
            weakSelf.isEdit = YES;
        };
        
        return cell;
    }else if([title isEqualToString:@"详情地址"]){
        QL_DetailsAddressInputTableViewCell *cell = [QL_DetailsAddressInputTableViewCell cellWithTableView:tableView];
        [cell setDisabledTextViewIsNo:NO];
        [cell setPositioningHidden:YES];
        cell.title = title;
        cell.placeholder = @"店铺详情地址";
        cell.info = self.viewModel.editParam.address;
        //回调
        cell.onInputFinishBlock = ^(NSString *inputStr){
            weakSelf.viewModel.editParam.address = inputStr;
            
            [weakSelf getLongitudeLatitude];
            
            weakSelf.isEdit = YES;
        };
        cell.onInputChangeBlock = ^(NSString *inputStr){
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        cell.onLocationBlock = ^(){
            [weakSelf addressLocation];
        };
        
        return cell;
    }else{
        QL_ItemTableViewCell *cell = [QL_ItemTableViewCell cellWithTableView:tableView];
        
        [cell setClearButtonHidden:YES];
        cell.title = title;
        [cell setNextImageHidden:YES];
        [cell setLocationHidden:YES];
        [cell setInfoLabelHidden:NO];
        [cell setTextFieldHidden:YES];
        cell.bottomLongLineImage.hidden = NO;
        if([title isEqualToString:@"店铺折扣"]){
            cell.info = [NSString stringWithFormat:@"%@折", self.shopInfoData.discount];
            [cell setTextFieldHidden:YES];
        }else if([title isEqualToString:@"人均消费"]){
            cell.placeholder = @"默认为1元";
            cell.info = self.viewModel.editParam.avgPrice;
            [cell setTextFieldKeyboardType:UIKeyboardTypeDecimalPad];
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.editParam.avgPrice = inputStr;
                
                weakSelf.isEdit = YES;
            };
        }else if([title isEqualToString:@"店铺电话"]){
            cell.placeholder = @"店铺电话";
            cell.info = self.viewModel.editParam.storePhone;
            [cell setTextFieldKeyboardType:UIKeyboardTypePhonePad];
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.editParam.storePhone = inputStr;
                
                weakSelf.isEdit = YES;
            };
        }else if([title isEqualToString:@"店铺名称"]){
            cell.placeholder = @"店铺名称";
            cell.info = self.viewModel.editParam.sellerName;
            [cell setTextFieldKeyboardType:UIKeyboardTypeDefault];
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.editParam.sellerName = inputStr;
                
                weakSelf.isEdit = YES;
            };
        }else if([title isEqualToString:@"店铺所在地"]){
            [cell setNextImageHidden:NO];
            [cell setTextFieldHidden:YES];
            cell.info = self.showArae.length > 0 ? self.showArae : @"店铺所在地";
        }/*else if([title isEqualToString:@"详情地址"]){
            cell.placeholder = @"店铺详情地址";
            cell.info = self.viewModel.editParam.address;
            [cell setLocationHidden:NO];
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.editParam.address = inputStr;
                
                [weakSelf getLongitudeLatitude];
            };
            cell.onLocationBlock = ^(){
                [weakSelf addressLocation];
            };
        }*/
        
        return cell;
    }
    
    return nil;
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(100)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///完成按钮
- (UIButton *)finishButton
{
    if(!_finishButton){
        UIButton *button = [UIButton createButtonWithTitle:@"完成" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onFinishAction:)];
        [button setTitleClor:kFontColorWhite];
        [self.view addSubview:_finishButton = button];
    }
    return _finishButton;
}

///标题
- (NSMutableArray *)titleArray
{
    if(!_titleArray){
        _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_titleArray addObjectsFromArray:@[@"店铺logo",@"店铺折扣",@"人均消费",@"营业时段",@"店铺电话",@"店铺名称",@"店铺所在地",@"详情地址",@"其他服务",@"环境照片",@"店铺简介"]];
    }
    return _titleArray;
}

///view model
- (QL_ShopInformationViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_ShopInformationViewModel alloc] init];
    }
    return _viewModel;
}

///地图类
- (void)initMapUitl
{
    WEAKSelf;
    DATAMODEL.baiduMapUtil.onMapSearchCoordinate2DBlock = ^(NSString *longitude, NSString *latitude){
        if([longitude isEqualToString:@""]){
            weakSelf.viewModel.editParam.longitude = weakSelf.shopInfoData.longitude;
            weakSelf.viewModel.editParam.latitude = weakSelf.shopInfoData.latitude;
        }else{
            weakSelf.viewModel.editParam.longitude = longitude;
            weakSelf.viewModel.editParam.latitude = latitude;
        }
    };
}

///地区选择view
- (QL_AreaPickerView *)areaPickerView
{
    if(!_areaPickerView){
        _areaPickerView = [[QL_AreaPickerView alloc] init];
        //回调
        WEAKSelf;
        _areaPickerView.onAreaPickerSelectBlock = ^(NSMutableDictionary *selectedDict){
            QL_AreaDataModel *model1 = selectedDict[@"0"];
            QL_AreaDataModel *model2 = selectedDict[@"1"];
            QL_AreaDataModel *model3 = selectedDict[@"2"];
            
            if(model3){
                weakSelf.viewModel.editParam.areaId = model3.areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@%@", model1.name, model2.name, model3.name];
            }else if(model2){
                weakSelf.viewModel.editParam.areaId = model2.areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@", model1.name, model2.name];
            }
            
            [weakSelf.tableView reloadData];
            
            if([weakSelf.viewModel.editParam.longitude isEqualToString:@""]){
                [DATAMODEL.baiduMapUtil mapSearchForAddress:weakSelf.showArae];
            }
            
            weakSelf.isEdit = YES;
        };
    }
    return _areaPickerView;
}

///设置商家信息
- (void)setShopInfoData:(QL_ShopInformationDataModel *)shopInfoData
{
    _shopInfoData = shopInfoData;
    
    self.viewModel.editParam.sellerId = shopInfoData.id;
    self.viewModel.editParam.sellerName = shopInfoData.name;
    self.viewModel.editParam.avgPrice = shopInfoData.avgPrice;
    self.viewModel.editParam.storePhone = shopInfoData.storePhone;
    self.viewModel.editParam.note = shopInfoData.Description;
    self.viewModel.editParam.latitude = shopInfoData.latitude;
    self.viewModel.editParam.longitude = shopInfoData.longitude;
    self.viewModel.editParam.featuredService = shopInfoData.featuredService;
    self.viewModel.editParam.businessTime = shopInfoData.businessTime;
//    self.viewModel.editParam.areaId = shopInfoData.area.id;
    self.showArae = [DATAMODEL.configDBHelper getProvinceCityAreaNameForAreaId:shopInfoData.area.id];
    self.viewModel.editParam.address = [shopInfoData.address stringByReplacingOccurrencesOfString:self.showArae withString:@""];
}


@end
