//
//  GC_NoticeMsgViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  消息处理 -- View Model
//

#import "Hen_BaseViewModel.h"
#import "GC_NoticeModel.h"

@interface GC_NoticeMsgViewModel : Hen_BaseViewModel

///获取消息列表 参数
@property (nonatomic, strong) NSMutableDictionary *noticeMsgParam;
///获取消息列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResNoticesMsgDataModel*>* noticeMsgDatas;
///获取消息列表 方法
-(void)getNoticesMsgDatasWithResultBlock:(RequestResultBlock)resultBlock;


///阅读消息 参数
@property (nonatomic, strong) NSMutableDictionary *readMessageParam;
///阅读消息 方法
-(void)setReadMessageDataWithResultBlock:(RequestResultBlock)resultBlock;


///删除消息 参数
@property (nonatomic, strong) NSMutableDictionary *deleteMsgsParam;
///删除消息 方法
-(void)setDeleteMsgsDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
