//
//  OrderDetailReceiveViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderManageListModel.h"

@interface OrderDetailReceiveViewController : BaseViewController

@property (nonatomic,strong)NSString* orderNo;
//@property (nonatomic,strong)NSString* sendTime;

@property (nonatomic,strong)NSString* orderStatusFlag;
@property (nonatomic, copy) void (^transVaule)(NSString* orderStatusFlag);
@end