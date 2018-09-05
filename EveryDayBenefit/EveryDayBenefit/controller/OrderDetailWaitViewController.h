//
//  OrderDetailWaitViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeOrderCancel = 0,
    typeOrderDel = 1,
}	typeOrderWaitDetail;


#import "BaseViewController.h"

@interface OrderDetailWaitViewController : BaseViewController

@property (nonatomic,strong)NSString* orderNo;
@property (nonatomic,assign)typeOrderWaitDetail typeOrder;


//block声明
@property (nonatomic,strong)NSString* orderStatusFlag;
@property (nonatomic, copy) void (^transVaule)(NSString* orderStatusFlag);

@end
