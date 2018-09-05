//
//  OrderCommentsListViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeOrderManage = 0,
    typeOrderPay = 1,
}	typeOrderComments;


#import "BaseViewController.h"

@interface OrderCommentsListViewController : BaseViewController

@property (nonatomic,strong)NSString* orderNo;
@property (nonatomic,assign)typeOrderComments commentType;

@property (nonatomic,strong)NSString* orderStatusFlag;
@property (nonatomic, copy) void (^transVaule)(NSString* orderStatusFlag);

@end
