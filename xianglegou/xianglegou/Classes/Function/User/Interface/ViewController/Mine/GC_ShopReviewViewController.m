//
//  GC_ShopReviewViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/31.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_ShopReviewViewController.h"

@interface GC_ShopReviewViewController ()

///审核中view
@property(nonatomic, weak) UIView *auditingView;
///审核失败view
@property(nonatomic, weak) UIView *auditeFailView;

@end

@implementation GC_ShopReviewViewController

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



- (void)loadSubView
{
    
    self.navigationItem.title = @"入驻店铺";
    
    if(self.isReview == 1){
        [[self auditingView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }else{
        [[self auditeFailView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }
}


- (void)onMobileLabelTouchUpInside:(id)sender
{
    [DATAMODEL.henUtil customerPhone:DATAMODEL.userInfoData.salesmanCellphone];
}

#pragma mark -- getter,setter

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
        UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) backgroundColor:kCommonBackgroudColor];
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
            make.top.equalTo(image.mas_bottom).offset(HEIGHT_TRANSFORMATION(36));
        }];
        
        
        UILabel *label1 = [UILabel createLabelWithText:@"请联系您的业务员：" font:kFontSize_28];
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        }];
        

        UILabel *label2 = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        [view addSubview:label2];
        
        
        label2.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onMobileLabelTouchUpInside:)];
        [label2 addGestureRecognizer:labelTapGestureRecognizer];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.mas_right);
            make.centerY.equalTo(label1);
        }];
        
        NSString *textStr = DATAMODEL.userInfoData.salesmanCellphone;
        
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        //赋值
        label2.attributedText = attribtStr;
        
        if(DATAMODEL.userInfoData.failReason.length > 0){
            UILabel *label3 = [UILabel createLabelWithText:[NSString stringWithFormat:@"失败原因：%@",DATAMODEL.userInfoData.failReason] font:kFontSize_28];
            
            [label3 lableAutoLinefeed];
            [view addSubview:label3];
            
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label);
                make.right.equalTo(label);
                make.top.equalTo(label1.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
            }];
        }
        
    }
    return _auditeFailView;
}
@end
