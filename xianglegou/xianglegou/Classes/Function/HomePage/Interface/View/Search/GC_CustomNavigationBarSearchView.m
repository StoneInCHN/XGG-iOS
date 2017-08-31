//
//  GC_CustomNavigationBarSearchView.m
//  Ask
//
//  Created by mini3 on 16/11/25.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "GC_CustomNavigationBarSearchView.h"

@interface GC_CustomNavigationBarSearchView ()<UISearchBarDelegate>

///搜索条
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation GC_CustomNavigationBarSearchView

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

-(void)initDefault
{
    self.frame = CGRectMake(0, 0, FITWITH(563/2), 32);
    
    [self addSubview:self.searchBar];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
///设置搜索条背景
-(void)setSearchBarBackgroundImage:(NSString*)imageName
{
    // Change search bar background
    [self.searchBar setBackgroundImage:[UIImage imageNamed:imageName]];
    for (UIView *view in self.searchBar.subviews[0].subviews) {
        UIColor *color = nil;
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            color = view.backgroundColor;
        }
        for (UIView *backView in self.searchBar.subviews[0].subviews[1].subviews) {
            if ([backView isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                [backView removeFromSuperview];
            }
        }
    }
}

///设置占位符
-(void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color
{
    self.searchBar.placeholder = placeholder;
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    // Change the search bar placeholder text color
    [searchField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

///设置搜索内容字体颜色
-(void)setSearchContentTextColor:(UIColor*)color
{
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = color;
}

///设置搜索 弹出 键盘
-(void)setEjectKeyboard
{
    //self.searchBar.text = @"";
    [self.searchBar becomeFirstResponder];
}
#pragma mark ----------------- searchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 修改UISearchBar右侧的取消按钮文字
    UIButton *button;
    // po recursiveDescription
    for (UIView *view in self.searchBar.subviews[0].subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            button = (UIButton *)view;
            if (button) {
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:kFont_28];
                break;
            }
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;
    
    if(self.onStartSearchBlock){
        self.onStartSearchBlock(searchBar.text);
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;
}

#pragma mark ----------------- getter, setter

-(UISearchBar*)searchBar
{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEIGHT_TRANSFORMATION(56))];
        _searchBar.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        //修改搜索输入框内左侧的指示图标
        [_searchBar setImage:[UIImage imageNamed:@"public_icon_search1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        [_searchBar setImage:[UIImage imageNamed:@"login_delete2"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
  
        // Change search bar background
        UIImage *bgImage = [UIImage imageNamed:@"public_icon_search_bg1"];
        [_searchBar setBackgroundImage:[DATAMODEL.henUtil reSizeImage:bgImage toSize:CGSizeMake(self.frame.size.width, HEIGHT_TRANSFORMATION(56))]];
        for (UIView *view in _searchBar.subviews[0].subviews) {
            UIColor *color = nil;
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                color = view.backgroundColor;
            }
            for (UIView *backView in _searchBar.subviews[0].subviews[1].subviews) {
                if ([backView isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                    [backView removeFromSuperview];
                }
            }
        }
        
        // Get the instance of the UITextField of the search bar
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        // Change search bar text color
        searchField.textColor = kFontColorWhite;
        // Change the search bar placeholder text color
        [searchField setValue:kFontColorGray forKeyPath:@"_placeholderLabel.textColor"];
        
        //[_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

@end
