//
//  GC_SettingConfigViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  配置数据信息界面
//

#import "GC_SettingConfigViewController.h"
#import "GC_ConfigurationViewModel.h"

@interface GC_SettingConfigViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

///View Model
@property (nonatomic, strong) GC_ConfigurationViewModel *viewModel;
@end

@implementation GC_SettingConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self loadConfigurationData];
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
    [self setViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
}

#pragma mark -- private

-(void)loadSubView
{
    self.view.backgroundColor = kCommonWhiteBg;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.view).offset(OffSetToLeft);
        make.right.equalTo(self.view).offset(OffSetToRight);
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-30));
    }];
}


///加载配置数据信息
-(void)loadConfigurationData
{
    //参数
    [self.viewModel.configParam setObject:self.configKey forKey:@"configKey"];
    ///显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel getConfigurationDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        
        if([code isEqualToString:@"0000"]){
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[weakSelf.viewModel.configurationData.configValue dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            
            weakSelf.textView.attributedText = attributedString;
            ////weakSelf.textView.text = ;
            
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


#pragma mark -- getter,setter
- (UITextView *)textView
{
    if(!_textView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.editable = NO;
        textView.font = kFontSize_28;
        [self.view addSubview:_textView = textView];
    }
    return _textView;
}


- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.navigationItem.title = titleInfo;
}

///View Model
- (GC_ConfigurationViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_ConfigurationViewModel alloc] init];
    }
    return _viewModel;
}
@end
