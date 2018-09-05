//
//  ReturnDetailViewController.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "ExiteOrderModel.h"

@interface ReturnDetailViewController : BaseViewController

@property (nonatomic,strong)NSString* orderno;
@property (nonatomic,strong)NSString* Id;

@property (nonatomic,strong)NSString* sendstatus;
@property (nonatomic,strong)NSString* linkerstatus;

@property (nonatomic,strong)ExiteOrderModel* orderdetailModel;
@end
