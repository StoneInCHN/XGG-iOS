//
//  RYNumberKeyBoard.m
//  RYNumberKeyboardDemo
//
//  Created by Resory on 16/2/20.
//  Copyright © 2016年 Resory. All rights reserved.
//

#import "RYNumberkeyboard.h"

@interface RYNumberKeyboard ()<UIKeyInput>

@property (strong, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *resignBtn;
///键盘类型
@property (nonatomic, assign) NSInteger enterType;
@end

@implementation RYNumberKeyboard

- (id)initWithInputType:(RYInputType)inputType
{
    self = [super init];
    
    if(self)
    {
        // 通知
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(editingDidBegin:)
//                                                     name:UITextFieldTextDidBeginEditingNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(editingDidEnd:)
//                                                     name:UITextFieldTextDidEndEditingNotification
//                                                   object:nil];
        
        // 添加keyboardview
        [[NSBundle mainBundle] loadNibNamed:@"RYNumberKeyboard" owner:self options:nil];
        self.frame = CGRectMake(0, 0, SYS_DEVICE_WIDTH, 216);
        self.keyboardView.frame = self.frame;
        [self addSubview:self.keyboardView];
        
        // 设置图片
        [self.deleteBtn setImage:[UIImage imageNamed:@"RYNumbeKeyboard.bundle/image/delete.png"]
                        forState:UIControlStateNormal];
        [self.resignBtn setImage:[UIImage imageNamed:@"RYNumbeKeyboard.bundle/image/resign.png"]
                        forState:UIControlStateNormal];
        self.inputType = inputType;
    }
    
    return self;
}

- (void)setInterval:(NSNumber *)interval
{
    _interval = interval;
}

- (void)setUnZeroBeg:(NSNumber *)unZeroBeg
{
    _unZeroBeg = unZeroBeg;
}

- (void)setFloatDecimal:(NSNumber *)floatDecimal
{
    _floatDecimal  = floatDecimal;
}

- (void)setInputType:(RYInputType)inputType
{
    UIButton *xBtn = [self viewWithTag:1011];
    UIButton *dotBtn = [self viewWithTag:1010];
    
    _inputType = inputType;
    
    switch (inputType)
    {
        // 浮点数键盘
        case RYFloatInputType:
        {
            xBtn.hidden = NO;
            dotBtn.hidden = NO;
            self.enterType = 1;
            [dotBtn setTitle:@"." forState:UIControlStateNormal];
            break;
        }
        // 身份证键盘
        case RYIDCardInputType:
        {
            xBtn.hidden = NO;
            dotBtn.hidden = NO;
            self.enterType = 2;
            [dotBtn setTitle:@"X" forState:UIControlStateNormal];
            break;
        }
        // 数字键盘
        default:
        {
            xBtn.hidden = NO;
            dotBtn.hidden = YES;
            break;
        }
    }
}

- (IBAction)keyboardViewAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    switch (tag)
    {
        case 1010:
        {
            if(self.enterType == 1){        // 浮点数键盘
                // 小数点
                if(self.textInput.text.length > 0 && ![self.textInput.text containsString:@"."]){
                    [self.textInput insertText:@"."];
                }
            }else if(self.enterType == 2){  // 身份证键盘
                if(self.textInput.text.length > 0 && ![self.textInput.text containsString:@"X"]){     // 身份证X
                    [self.textInput insertText:@"X"];
                }
            }
        }
            break;
        case 1011:
        {
            //消失
            [self.textInput resignFirstResponder];
        }
            break;
        case 1012:
        {
            // 删除
            if(self.textInput.text.length > 0)
                [self.textInput deleteBackward];
        }
            break;
        case 1013:
        {
            // 确认
            [self.textInput resignFirstResponder];
        }
            break;
        default:
        {
            // 数字
            NSString *text = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
            
            
            //输入两位以上数字不能已0开头
            NSMutableString * futureString = [NSMutableString stringWithString:[self.textInput.text stringByAppendingString:text]];
            
            
            if([self.unZeroBeg integerValue] == 1){
                
                if(futureString.length > 1 && [futureString hasPrefix:@"0"]){
                    if([futureString rangeOfString:@"."].location == NSNotFound){
                        return;
                    }
                }
            }
            
            if(self.textInput.text.length > 0 && [self.textInput.text containsString:@"."]){
                
                NSInteger flag=0;
                const NSInteger limited = [self.floatDecimal integerValue];
                for (NSInteger i = futureString.length-1; i>=0; i--) {
                    
                    if ([futureString characterAtIndex:i] == '.') {
                        
                        if (flag > limited) {
                            return;
                        }
                        
                        break;
                    }
                    flag++;
                }
            }
            
            [self.textInput insertText:text];
            
            if(self.interval && (self.textInput.text.length+1) % ([self.interval integerValue] + 1) == 0)
                [self.textInput insertText:@" "];
        }
            break;
    }
}

#pragma mark -
#pragma mark - Notification Action
//- (void)editingDidBegin:(NSNotification *)notification {
//    if (![notification.object conformsToProtocol:@protocol(UITextInput)])
//    {
//        self.textInput = nil;
//        return;
//    }
//    self.textInput = notification.object;
//}
//
//- (void)editingDidEnd:(NSNotification *)notification
//{
//    self.textInput = nil;
//}

#pragma mark -
#pragma mark - UIKeyInput Protocol


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
