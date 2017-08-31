//
//  QL_SettledShopViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SettledShopViewController.h"

#import "GC_AddWarningTableViewCell.h"
#import "QL_ItemTableViewCell.h"
#import "QL_SSLoadLogoTableViewCell.h"
#import "QL_SSLoadImageTableViewCell.h"
#import "QL_SSInfoInputTableViewCell.h"
#import "Hen_CustomPickerView.h"
#import "QL_SettledShopViewModel.h"
#import "QL_AreaPickerView.h"
#import "QL_DetailsAddressInputTableViewCell.h"
#import "QL_ShopAddressLocationViewController.h"

@interface QL_SettledShopViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///入驻按钮
@property(nonatomic, weak) UIButton *settledButton;

///审核中view
@property(nonatomic, weak) UIView *auditingView;
///审核失败view
@property(nonatomic, weak) UIView *auditeFailView;

///标题
@property(nonatomic, strong) NSMutableArray *titleArray;
///view model
@property(nonatomic, strong) QL_SettledShopViewModel *viewModel;
///选择view
@property(nonatomic, strong) Hen_CustomPickerView *pickerView;
///行业类别数据
@property(nonatomic, strong) NSMutableArray<Hen_CustomPickerModel *> *industryTypeArray;
///折扣数据
@property(nonatomic, strong) NSMutableArray<Hen_CustomPickerModel *> *discountArray;
///地区选择view
@property(nonatomic, strong) QL_AreaPickerView *areaPickerView;
///显示地区
@property(nonatomic, strong) NSString *showArae;

///手机号 验证状态
@property (nonatomic, strong) NSString *mobile_code;
@property (nonatomic, strong) NSString *mobile_desc;
@end

@implementation QL_SettledShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self initMapUitl];
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
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

- (void)onGoBackClick:(id)sender
{
    if(!self.isAuditing && !self.isAuditeFail){
        if([self.viewModel.settledParam.contactCellPhone isEqualToString:@""] &&
           [self.viewModel.settledParam.sellerName isEqualToString:@""] &&
           [self.viewModel.settledParam.categoryId isEqualToString:@""] &&
           [self.viewModel.settledParam.discount isEqualToString:@""] &&
           [self.viewModel.settledParam.storePhone isEqualToString:@""] &&
           [self.viewModel.settledParam.areaId isEqualToString:@""] &&
           [self.viewModel.settledParam.address isEqualToString:@""] &&
           [self.viewModel.settledParam.licenseNum isEqualToString:@""] &&
           !self.viewModel.businessLicenseImage &&
           !self.viewModel.logoImage &&
           self.viewModel.environmentalPhotos.count <= 0 &&
           self.viewModel.commitmentPhotos.count <= 0){
            [super onGoBackClick:sender];
            [DATAMODEL.baiduMapUtil cleanMap];
        }else{
            //提示
            [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要返回吗？返回后资料将被清空。"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){ // 确定
                    [super onGoBackClick:sender];
                    [DATAMODEL.baiduMapUtil cleanMap];
                }
            }];
        }
    }else{
        [super onGoBackClick:sender];
        [DATAMODEL.baiduMapUtil cleanMap];
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = HenLocalizedString(@"新增商家");
    self.view.backgroundColor = kCommonBackgroudColor;
    
    if(self.isAuditeFail){ // 审核失败
        [self auditeFailView];
    
//////        self.viewModel.settledParam.applyId = DATAMODEL.userInfoData.applyId;
    }else{
        if(self.isAuditing){ // 审核中
            [self auditingView];
        }else{
            [self.settledButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
            }];
            
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.settledButton.mas_top);
            }];
        }
    }
}

///选择行业类别
- (void)selectIndustryType
{
    WEAKSelf;
    
    if(self.industryTypeArray.count > 0){
        [self.pickerView showPickerViewWithDataSource:@[self.industryTypeArray] unitArray:nil];
        [self.pickerView setFirstSelectedBy:@[self.viewModel.settledParam.categoryId]];
    }else{
        //显示加载
        [self showPayHud:@""];
        //请求行业类别
        [self.viewModel getSellerCategoryWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            //取消加载
            [weakSelf hideHud];
            if([code isEqualToString:@"0000"]){ // 成功
                for(QL_SellerCategoryDataModel *model in weakSelf.viewModel.sellerCategoryDatas){
                    Hen_CustomPickerModel *selectModel = [[Hen_CustomPickerModel alloc] initWithDictionary:@{}];
                    selectModel.itemId = model.id;
                    selectModel.name = model.categoryName;
                    [weakSelf.industryTypeArray addObject:selectModel];
                }
                //显示
                [weakSelf.pickerView showPickerViewWithDataSource:@[weakSelf.industryTypeArray] unitArray:nil];
                [weakSelf.pickerView setFirstSelectedBy:@[weakSelf.viewModel.settledParam.categoryId]];
            }else{
                //提示
                [weakSelf showHint:desc];
            }
        }];
    }
    //回调
    self.pickerView.onCustomPickerSelectBlock = ^(NSMutableDictionary *selectedDict){
        Hen_CustomPickerModel *model = selectedDict[@"0"];
        weakSelf.viewModel.settledParam.categoryId = model.itemId;
        
        [weakSelf.tableView reloadData];
    };
}

///选择折扣
- (void)selectDiscount
{
    WEAKSelf;
    [self.pickerView showPickerViewWithDataSource:@[self.discountArray] unitArray:nil];
    [self.pickerView setFirstSelectedBy:@[self.viewModel.settledParam.discount]];
    //回调
    self.pickerView.onCustomPickerSelectBlock = ^(NSMutableDictionary *selectedDict){
        Hen_CustomPickerModel *model = selectedDict[@"0"];
        weakSelf.viewModel.settledParam.discount = model.itemId;
        
        [weakSelf.tableView reloadData];
    };
}

///获取折扣信息
- (NSString *)getDiscountInfo
{
    if(self.viewModel.settledParam.discount.length > 0){
        for(Hen_CustomPickerModel *model in self.discountArray){
            if([model.itemId isEqualToString:self.viewModel.settledParam.discount]){
                return model.name;
            }
        }
    }
    return @"店铺折扣";
}

///获取经纬度
- (void)getLongitudeLatitude
{
    [DATAMODEL.baiduMapUtil mapSearchForAddress:[NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.settledParam.address]];
}

///地址定位
- (void)addressLocation
{
    QL_ShopAddressLocationViewController *alVC = [[QL_ShopAddressLocationViewController alloc] init];
    alVC.hidesBottomBarWhenPushed = YES;
    alVC.longitude = self.viewModel.settledParam.longitude;
    alVC.latitude = self.viewModel.settledParam.latitude;
    alVC.address = [NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.settledParam.address];
    alVC.sellerName = self.viewModel.settledParam.sellerName;
    //回调
    WEAKSelf;
    alVC.onFinishWithAreaBlock = ^(NSString *longitude, NSString *latitude, NSString *address, NSString *proName, NSString *cityName, NSString *areaName){
        weakSelf.viewModel.settledParam.longitude = longitude;
        weakSelf.viewModel.settledParam.latitude = latitude;
        
        if(![areaName isEqualToString:@""]){
            NSString *areaId = [DATAMODEL.configDBHelper getCityIdForCityName:areaName];
            if(![areaId isEqualToString:@""]){
                weakSelf.viewModel.settledParam.areaId = areaId;
                if([proName isEqualToString:cityName]){
                    weakSelf.showArae = [NSString stringWithFormat:@"%@%@", proName, areaName];
                }else{
                    weakSelf.showArae = [NSString stringWithFormat:@"%@%@%@", proName, cityName, areaName];
                }
            }
        }else if([cityName isEqualToString:@""]){
            NSString *areaId = [DATAMODEL.configDBHelper getCityIdForCityName:cityName];
            if(![areaId isEqualToString:@""]){
                weakSelf.viewModel.settledParam.areaId = areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@", proName, cityName];
            }
        }
        
        weakSelf.viewModel.settledParam.address = [address stringByReplacingOccurrencesOfString:weakSelf.showArae withString:@""];
        
        [weakSelf.tableView reloadData];
    };
    
    [self.navigationController pushViewController:alVC animated:YES];
}



///验证手机号是否已注册会员或成为商家
- (void)setEndUserVerifyMobile
{
    //参数
    //用户ID
    [self.viewModel.verifyMobileParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.verifyMobileParam setObject:DATAMODEL.token forKey:@"token"];
    
    
    WEAKSelf;
    [self.viewModel setEndUserVerifyMobileDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        
        weakSelf.mobile_code = code;
        weakSelf.mobile_desc = desc;
        if([code isEqualToString:@"0009"]){   //表示会员存在，提示确定绑定此商家

            if(desc.length <= 0){
                desc = @"此会员已经存在,确定要绑定此会员为商家吗?";
            }
            [DATAMODEL.alertManager showTwoButtonWithMessage:desc];
            
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                
            }];
            
        }else if([code isEqualToString:@"1000"]){    //手机号已注册并已经是商家
            [weakSelf showHint:desc];
           
        }
    }];
}



#pragma mark -- event response

///入驻
- (void)onSettledAction:(UIButton *)sender
{
    //检查
    if([self.viewModel.settledParam.contactCellPhone isEqualToString:@""] ||
       [self.viewModel.settledParam.sellerName isEqualToString:@""] ||
       [self.viewModel.settledParam.categoryId isEqualToString:@""] ||
       [self.viewModel.settledParam.discount isEqualToString:@""] ||
       [self.viewModel.settledParam.storePhone isEqualToString:@""] ||
       [self.viewModel.settledParam.areaId isEqualToString:@""] ||
       [self.viewModel.settledParam.address isEqualToString:@""] ||
       [self.viewModel.settledParam.licenseNum isEqualToString:@""] ||
       !self.viewModel.businessLicenseImage ||
       !self.viewModel.logoImage ||
       self.viewModel.environmentalPhotos.count <= 0 ||
       self.viewModel.commitmentPhotos.count <= 0){
        //提示
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    if(self.viewModel.commitmentPhotos.count < 2){
        
        [self showHint:@"商家承诺书和业务员承诺书至少2张！"];
        return;
    }
    
    
    if([self.mobile_code isEqualToString:@"1000"]){
        [self showHint:self.mobile_desc];
        return;
    }
    
    
    self.viewModel.settledParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.settledParam.token = DATAMODEL.token;
    self.viewModel.settledParam.address = [NSString stringWithFormat:@"%@%@", self.showArae, self.viewModel.settledParam.address];
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.viewModel settledShopWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            //提示
            [weakSelf showHint:@"成功！"];
            
            weakSelf.isAuditing = YES;
            [weakSelf loadSubView];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///重新入驻
- (void)onResetSettledAction:(UIButton *)sender
{
    self.isAuditeFail = NO;
    self.auditeFailView.hidden = YES;
    [self loadSubView];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.titleArray[indexPath.row];
    if([title isEqualToString:@"行业类别"]){
        [self selectIndustryType];
    }else if([title isEqualToString:@"店铺折扣"]){
        [self selectDiscount];
    }else if([title isEqualToString:@"店铺所在地"]){
        [self.areaPickerView showPickerView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
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
    
    if([title isEqualToString:@"logo"]){
        QL_SSLoadLogoTableViewCell *cell = [QL_SSLoadLogoTableViewCell cellWithTableView:tableView];
        
        cell.bottomLongLineImage.hidden = NO;
        cell.topLongLineImage.hidden = NO;
        //回调
        cell.onPhotoCollectBlock = ^(UIImage *images){
            weakSelf.viewModel.logoImage = images;
        };
        
        return cell;
    }else if([title isEqualToString:@"营业执照照片"]){
        QL_SSLoadImageTableViewCell *cell = [QL_SSLoadImageTableViewCell cellWithTableView:tableView];
         [cell setNotice:@"(最大上传2000*2000的像素)"];
        [cell setNoticeLabelHidden:NO];
        cell.title = title;
        cell.maxImageCount = 1;
        cell.bottomLongLineImage.hidden = NO;
        //回调
        cell.onPhotoCollectBlock = ^(NSMutableArray *images){
            weakSelf.viewModel.businessLicenseImage = images.firstObject;
        };
        
        return cell;
    }else if([title isEqualToString:@"商家承诺书和业务员承诺书"]){
        QL_SSLoadImageTableViewCell *cell = [QL_SSLoadImageTableViewCell cellWithTableView:tableView];
        
        [cell setNotice:@"(至少2张)"];
        [cell setNoticeLabelHidden:NO];
        cell.title = title;
        cell.maxImageCount = 2;
        cell.bottomLongLineImage.hidden = NO;
        //回调
        cell.onPhotoCollectBlock = ^(NSMutableArray *images){
            weakSelf.viewModel.commitmentPhotos = images;
        };
        
        return cell;
    }else if([title isEqualToString:@"环境照片"]){
        QL_SSLoadImageTableViewCell *cell = [QL_SSLoadImageTableViewCell cellWithTableView:tableView];
        
        [cell setNoticeLabelHidden:YES];
        cell.title = title;
        cell.maxImageCount = 4;
        cell.bottomLongLineImage.hidden = NO;
        //回调
        cell.onPhotoCollectBlock = ^(NSMutableArray *images){
            weakSelf.viewModel.environmentalPhotos = images;
        };
        
        return cell;
    }else if([title isEqualToString:@"店铺简介"]){
        QL_SSInfoInputTableViewCell *cell = [QL_SSInfoInputTableViewCell cellWithTableView:tableView];
        
        //回调
        cell.onInfoContentBlock = ^(NSString *content){
            weakSelf.viewModel.settledParam.note = content;
        };
        
        return cell;
    }else if([title isEqualToString:@"详情地址"]){
        QL_DetailsAddressInputTableViewCell *cell = [QL_DetailsAddressInputTableViewCell cellWithTableView:tableView];
        
        cell.title = title;
        cell.placeholder = @"店铺详情地址";
        cell.info = self.viewModel.settledParam.address.length > 0 ? self.viewModel.settledParam.address : @"";
        //回调
        cell.onInputFinishBlock = ^(NSString *inputStr){
            weakSelf.viewModel.settledParam.address = inputStr;
            
            [weakSelf getLongitudeLatitude];
        };
        cell.onInputChangeBlock = ^(NSString *inputStr){
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        cell.onLocationBlock = ^(){
            [weakSelf addressLocation];
        };
        
        return cell;
    }else if([title isEqualToString:@"warning"]){       //手机号填写 警告
        GC_AddWarningTableViewCell *cell = [GC_AddWarningTableViewCell cellWithTableView:tableView];
        cell.bottomLongLineImage.hidden = NO;
        return cell;
        
    }else{
        QL_ItemTableViewCell *cell = [QL_ItemTableViewCell cellWithTableView:tableView];
        
        [cell setClearButtonHidden:YES];
        cell.title = title;
        [cell setNextImageHidden:YES];
        [cell setLocationHidden:YES];
        [cell setInfoLabelHidden:NO];
        [cell setTextFieldHidden:YES];
        [cell setTextFieldUserInteractionEnabled:YES];
        cell.bottomLongLineImage.hidden = NO;
        if([title isEqualToString:@"手机号"]){
            cell.placeholder = @"店铺联系人手机号";
            [cell setTextFieldKeyboardType:UIKeyboardTypeNumberPad];
            
            if(self.shopMobile.length > 0){
                [cell setTextFieldUserInteractionEnabled:NO];
            }
            
            cell.info = self.viewModel.settledParam.contactCellPhone;
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.settledParam.contactCellPhone = inputStr;
                [weakSelf.viewModel.verifyMobileParam setObject:inputStr forKey:@"cellPhoneNum"];
                //验证手机号是否已注册会员或成为商家
                [weakSelf setEndUserVerifyMobile];
            };
        }else if([title isEqualToString:@"店铺名称"]){
            [cell setTextFieldKeyboardType:UIKeyboardTypeDefault];
            cell.placeholder = @"店铺名称";
            cell.info = self.viewModel.settledParam.sellerName;
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.settledParam.sellerName = inputStr;
            };
        }else if([title isEqualToString:@"行业类别"]){
            [cell setNextImageHidden:NO];
            [cell setTextFieldHidden:YES];
            cell.info = [self.viewModel getTypeInfo];
        }else if([title isEqualToString:@"店铺折扣"]){
            [cell setNextImageHidden:NO];
            [cell setTextFieldHidden:YES];
            cell.info = [self getDiscountInfo];
        }else if([title isEqualToString:@"店铺电话"]){
            [cell setTextFieldKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            cell.placeholder = @"店铺电话";
            
            cell.info = self.viewModel.settledParam.storePhone;
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.settledParam.storePhone = inputStr;
            };
        }else if([title isEqualToString:@"店铺所在地"]){
            [cell setNextImageHidden:NO];
            [cell setTextFieldHidden:YES];
            cell.info = self.showArae.length > 0 ? self.showArae : @"店铺所在地";
        }/*else if([title isEqualToString:@"详情地址"]){
            cell.placeholder = @"详情地址";
            cell.info = self.viewModel.settledParam.address.length > 0 ? self.viewModel.settledParam.address : @"";
            [cell setLocationHidden:NO];
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.settledParam.address = inputStr;
                
                [weakSelf getLongitudeLatitude];
            };
            cell.onLocationBlock = ^(){
                [weakSelf addressLocation];
            };
        }*/else if([title isEqualToString:@"营业执照号"]){
            [cell setTextFieldKeyboardType:UIKeyboardTypeDefault];
            cell.placeholder = @"营业执照号";
            cell.info = self.viewModel.settledParam.licenseNum;
            //回调
            cell.onInputFinishBlock = ^(NSString *inputStr){
                weakSelf.viewModel.settledParam.licenseNum = inputStr;
            };
        }
        
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

///查看评价按钮
- (UIButton *)settledButton
{
    if(!_settledButton){
        UIButton *button = [UIButton createButtonWithTitle:@"申请审核" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onSettledAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [self.view addSubview:_settledButton = button];
    }
    return _settledButton;
}

///审核中view
- (UIView *)auditingView
{
    if(!_auditingView){
        UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) backgroundColor:kCommonBackgroudColor];
        [self.view addSubview:_auditingView = view];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_picture_under_review"];
        [view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(60));
        }];
        UILabel *label = [UILabel createLabelWithText:@"正在审核，请耐心等候！" font:kFontSize_28];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(image.mas_bottom).offset(HEIGHT_TRANSFORMATION(36));
        }];
        
    }
    return _auditingView;
}

///审核失败view
- (UIView *)auditeFailView
{
    if(!_auditeFailView){
        UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(690)) backgroundColor:kCommonBackgroudColor];
        [self.view addSubview:_auditeFailView = view];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_picture_under_review_fail"];
        [view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(60));
        }];
        UILabel *label = [UILabel createLabelWithText:@"非常抱歉！审核失败，请重新入驻。" font:kFontSize_28];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.bottom.equalTo(view).offset(HEIGHT_TRANSFORMATION(-160));
        }];
        
        
        
        UILabel *failurelabel = [UILabel createLabelWithText:[NSString stringWithFormat:@"失败原因：%@",self.failureReason] font:kFontSize_28];
        [failurelabel lableAutoLinefeed];
        [view addSubview:failurelabel];
        [failurelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.right.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(24));
        }];
        
        
        
        if(self.failureReason.length <= 0){
            failurelabel.hidden = YES;
        }else{
            failurelabel.hidden = NO;
        }
        
        
        
        UIButton *button = [UIButton createButtonWithTitle:@"重新入驻" backgroundNormalImage:@"public_botton_big_red" backgroundPressImage:@"public_botton_big_red_press" target:self action:@selector(onResetSettledAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(failurelabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(50));
        }];
    }
    return _auditeFailView;
}

///标题
- (NSMutableArray *)titleArray
{
    if(!_titleArray){
        _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_titleArray addObjectsFromArray:@[@"logo",@"手机号",@"warning",@"店铺名称",@"行业类别",@"店铺折扣",@"店铺电话",@"店铺所在地",@"详情地址",@"营业执照号",@"营业执照照片",@"商家承诺书和业务员承诺书",@"环境照片",@"店铺简介"]];
    }
    return _titleArray;
}

///view model
- (QL_SettledShopViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_SettledShopViewModel alloc] init];
    }
    return _viewModel;
}

///选择view
- (Hen_CustomPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[Hen_CustomPickerView alloc] init];
    }
    return _pickerView;
}

///行业类别数据
- (NSMutableArray<Hen_CustomPickerModel *> *)industryTypeArray
{
    if(!_industryTypeArray){
        _industryTypeArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _industryTypeArray;
}

///地图类
- (void)initMapUitl
{
    WEAKSelf;
    DATAMODEL.baiduMapUtil.onMapSearchCoordinate2DBlock = ^(NSString *longitude, NSString *latitude){
        if([longitude isEqualToString:@""]){
            if(weakSelf.showArae.length > 0){
                [DATAMODEL.baiduMapUtil mapSearchForAddress:weakSelf.showArae];
            }
        }else{
            weakSelf.viewModel.settledParam.longitude = longitude;
            weakSelf.viewModel.settledParam.latitude = latitude;
        }
    };
}


///折扣数据
- (NSMutableArray<Hen_CustomPickerModel *> *)discountArray
{
    if(!_discountArray){
        _discountArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(NSInteger i = 1; i < 21; i++){
            CGFloat temp = 10.0 - i * 0.1;
            Hen_CustomPickerModel *model = [[Hen_CustomPickerModel alloc] initWithDictionary:@{}];
            model.itemId = [NSString stringWithFormat:@"%0.1f", temp];
            model.name = [NSString stringWithFormat:@"%0.1f折", temp];
            [_discountArray addObject:model];
        }
    }
    return _discountArray;
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
                weakSelf.viewModel.settledParam.areaId = model3.areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@%@", model1.name, model2.name, model3.name];
            }else if(model2){
                weakSelf.viewModel.settledParam.areaId = model2.areaId;
                weakSelf.showArae = [NSString stringWithFormat:@"%@%@", model1.name, model2.name];
            }
            
            [weakSelf.tableView reloadData];
            
            if([weakSelf.viewModel.settledParam.longitude isEqualToString:@""]){
                [DATAMODEL.baiduMapUtil mapSearchForAddress:weakSelf.showArae];
            }
        };
    }
    return _areaPickerView;
}


- (void)setShopMobile:(NSString *)shopMobile
{
    _shopMobile = shopMobile;
    self.viewModel.settledParam.contactCellPhone = shopMobile;
    
}


- (void)setShopId:(NSString *)shopId
{
    _shopId = shopId;
    self.viewModel.settledParam.applyId = shopId;
}
@end
