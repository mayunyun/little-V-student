//
//  OrderManageViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderManageViewController : BaseViewController

//用来区分是从什么地方进来的订单管理页面
@property (nonatomic,strong)NSString* orderStatusFlag;

@end
