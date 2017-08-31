//
//  LZ_TransferViewController.h
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseTableViewController.h"

@interface LZ_TransferViewController : Hen_BaseViewController

///转账类型
@property (nonatomic ,strong) NSString  *transType;

///返回回调
@property (nonatomic, copy) void(^onGoBackSuccess)();

@end
