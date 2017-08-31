//
//  GC_NoticeModel.h
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_NoticeModel : Hen_JsonModel

@end

#pragma mark -- 消息通知列表数据
@interface GC_MResNoticesMsgDataModel : Hen_JsonModel
///是否已读标志
@property (nonatomic, strong) NSString *isRead;
///标题
@property (nonatomic, strong) NSString *messageTitle;
///Id
@property (nonatomic, strong) NSString *id;
///内容
@property (nonatomic, strong) NSString *messageContent;
///创建时间
@property (nonatomic, strong) NSString *createDate;
@end
