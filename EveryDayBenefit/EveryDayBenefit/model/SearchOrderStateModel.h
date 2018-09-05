//
//  SearchOrderStateModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface SearchOrderStateModel : BaseModel

@property (nonatomic,strong)NSString* uncommentcounts;//待评价
@property (nonatomic,strong)NSString* ungetcounts;//待收货
@property (nonatomic,strong)NSString* unpaycounts;//待付款
@property (nonatomic,strong)NSString* allcounts;    //全部订单
@property (nonatomic,strong)NSString* unsendcounts; //待发货

/*
 {"uncommentcounts":0,"ungetcounts":0,"unpaycounts":0}
 */
@end
