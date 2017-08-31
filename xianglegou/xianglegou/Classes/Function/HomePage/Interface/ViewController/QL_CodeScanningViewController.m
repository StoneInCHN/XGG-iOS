//
//  QL_CodeScanningViewController.m
//  Rebate
//
//  Created by mini2 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_CodeScanningViewController.h"
#import "SGQRCode.h"

#import "QL_PayBillViewController.h"

@interface QL_CodeScanningViewController ()

@end

@implementation QL_CodeScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
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

- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;
    if ([string hasPrefix:@"{\"flag"]) {
        [self pageJumpForString:string];
    }else{
        // 提示
        [self showNotice];
    }
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    SGQRCodeLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    if ([string hasPrefix:@"{\"flag"]) {
        [self pageJumpForString:string];
    }else{
        // 提示
        [self showNotice];
    }
}

///页面跳转
- (void)pageJumpForString:(NSString *)string
{
    // 初始化解析错误
    NSError *error = nil;
    // JSON解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *flag = [dic getStringValueForKey:@"flag" defaultValue:@""];
    NSString *sellerId = [dic getStringValueForKey:@"sellerId" defaultValue:@""];
    
    if(![flag isEqualToString:@""] && ![sellerId isEqualToString:@""]){
        if([flag isEqualToString:[self md5:@"享个购"]]){
            QL_PayBillViewController *pbVC = [[QL_PayBillViewController alloc] init];
            pbVC.hidesBottomBarWhenPushed = YES;
            pbVC.sellerId = sellerId;
            
            [self.navigationController pushViewController:pbVC animated:YES];
        }else{
            // 提示
            [self showNotice];
        }
    }else{
        // 提示
        [self showNotice];
    }
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

///显示提示
- (void)showNotice
{
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"无效的商家二维码，是否重新扫描？"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [weakSelf ReScan];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
