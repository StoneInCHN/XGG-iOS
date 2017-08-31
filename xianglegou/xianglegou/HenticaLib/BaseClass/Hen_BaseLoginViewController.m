//
//  Hen_BaseLoginViewController.m
//  Peccancy
//
//  Created by mini2 on 16/11/9.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_BaseLoginViewController.h"

@interface Hen_BaseLoginViewController ()

@end

@implementation Hen_BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [Hen_MessageManager shareMessageManager].isToLogin = NO;
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

@end
