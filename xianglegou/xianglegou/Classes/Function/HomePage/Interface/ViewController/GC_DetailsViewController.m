//
//  GC_DetailsViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_DetailsViewController.h"


@interface GC_DetailsViewController ()<UITextViewDelegate>
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///时间
@property (nonatomic, weak) UILabel *timeLabel;
///Text View
@property (nonatomic, weak) UITextView *textView;
@end

@implementation GC_DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationBar];
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
///加载导航栏信息
-(void)loadNavigationBar
{
    self.navigationItem.title = @"详情介绍";
    self.view.backgroundColor = kCommonWhiteBg;
}

///加载子视图
-(void)loadSubView
{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(34));
        make.left.equalTo(self.view).offset(WIDTH_TRANSFORMATION(36));
        make.right.equalTo(self.view).offset(WIDTH_TRANSFORMATION(-36));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.left.equalTo(self.view).offset(WIDTH_TRANSFORMATION(36));
        make.right.equalTo(self.view).offset(WIDTH_TRANSFORMATION(-36));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
        make.left.equalTo(self.view).offset(WIDTH_TRANSFORMATION(36));
        make.right.equalTo(self.view).offset(WIDTH_TRANSFORMATION(-36));
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-50));
    }];

}


#pragma mark -- getter,setter
///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_36];
        titleLabel.text = self.noticeData.messageTitle;
        [titleLabel lableAutoLinefeed];
        [self.view addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *timeLabel = [UILabel createLabelWithText:@"2017-04-09" font:kFontSize_24 textColor:kFontColorGray];
        [self.view addSubview:_timeLabel = timeLabel];
    }
    return _timeLabel;
}

///TextView
- (UITextView *)textView
{
    if(!_textView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.text = @"杀马特杀马特杀马特杀马特杀马特杀马特杀马特杀马特杀马特";
        textView.editable = NO;
        textView.font = kFontSize_28;
        [self.view addSubview:_textView = textView];
    }
    return _textView;
}


- (void)setNoticeData:(GC_MResNoticesMsgDataModel *)noticeData
{
    _noticeData = noticeData;
    
    self.titleLabel.text = noticeData.messageTitle;
    self.timeLabel.text = [DATAMODEL.henUtil timeStampToString:noticeData.createDate];
    
    self.textView.text = noticeData.messageContent;
}
@end
