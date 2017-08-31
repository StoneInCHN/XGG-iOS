//
//  GC_UserHelpDetailViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_UserHelpDetailViewController.h"
#import "GC_UserHelpViewModel.h"

@interface GC_UserHelpDetailViewController ()<UITextViewDelegate>
@property (nonatomic, weak) UITextView *textView;
///VIewModel
@property (nonatomic, strong) GC_UserHelpViewModel *viewModel;
@end

@implementation GC_UserHelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
    [self loadUserHelpDetailData];
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


///加载帮助信息数据
- (void)loadUserHelpDetailData
{
    //参数
    [self.viewModel.userHelpDetailParam setObject:self.entityId forKey:@"entityId"];
    
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    //请求
    [self.viewModel getUserHelpDetailDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            if(weakSelf.viewModel.userHelpDetailData.title.length > 0 && ![weakSelf.viewModel.userHelpDetailData.title isEqualToString:@""]){
                weakSelf.navigationItem.title = weakSelf.viewModel.userHelpDetailData.title;
            }
            
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[weakSelf.viewModel.userHelpDetailData.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            
            weakSelf.textView.attributedText = attributedString;
        }else{
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

///ViewModel
- (GC_UserHelpViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_UserHelpViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.navigationItem.title = titleInfo;
}


@end
