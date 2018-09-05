//
//  PayTypeTbVC.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PayTypeTbVC : BaseViewController

@property(nonatomic,copy)NSString *name; //标题
@property(nonatomic,copy)NSString *mssage1;//描述
@property(nonatomic,copy)NSString *orderMoney1;//价格
@property(nonatomic,copy)NSString *orderno1;//订单号

@property(nonatomic,copy)NSString *ordernewUUid;

@property(nonatomic,copy)NSString *orderstr;
@property(nonatomic,copy)NSString *time;

@end
