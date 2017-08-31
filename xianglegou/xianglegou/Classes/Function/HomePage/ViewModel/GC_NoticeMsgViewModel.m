//
//  GC_NoticeMsgViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_NoticeMsgViewModel.h"

@implementation GC_NoticeMsgViewModel

///获取消息列表 方法
-(void)getNoticesMsgDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:message_getMsgList dictionaryParam:self.noticeMsgParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResNoticesMsgDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.noticeMsgParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.noticeMsgDatas removeAllObjects];
            }
            
            [self.noticeMsgDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}


///阅读消息 方法
-(void)setReadMessageDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:message_readMessage dictionaryParam:self.readMessageParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///删除消息 方法
-(void)setDeleteMsgsDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:message_deleteMsgs dictionaryParam:self.deleteMsgsParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        };
    }];
}


#pragma mark -- getter,setter
///获取消息列表 参数
- (NSMutableDictionary *)noticeMsgParam
{
    if(!_noticeMsgParam){
        _noticeMsgParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_noticeMsgParam setObject:@"" forKey:@"userId"];
        //用户token
        [_noticeMsgParam setObject:@"" forKey:@"token"];
        //分页：页数
        [_noticeMsgParam setObject:@"" forKey:@"pageNumber"];
        //分页：每页大小
        [_noticeMsgParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _noticeMsgParam;
}

- (NSMutableArray<GC_MResNoticesMsgDataModel *> *)noticeMsgDatas
{
    if(!_noticeMsgDatas){
        _noticeMsgDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _noticeMsgDatas;
}

///阅读消息 参数
- (NSMutableDictionary *)readMessageParam
{
    if(!_readMessageParam){
        _readMessageParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_readMessageParam setObject:@"" forKey:@"userId"];
        //用户token
        [_readMessageParam setObject:@"" forKey:@"token"];
        //消息ID
        [_readMessageParam setObject:@"" forKey:@"msgId"];
        
    }
    return _readMessageParam;
}

///删除消息 参数
- (NSMutableDictionary *)deleteMsgsParam
{
    if(!_deleteMsgsParam){
        _deleteMsgsParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_deleteMsgsParam setObject:@"" forKey:@"userId"];
        //用户token
        [_deleteMsgsParam setObject:@"" forKey:@"token"];
        //消息ID数组
        [_deleteMsgsParam setObject:@[] forKey:@"msgIds"];
    }
    return _deleteMsgsParam;
}
@end
