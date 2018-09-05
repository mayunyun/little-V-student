//
//  searchCustomerModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/2/6.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface searchCustomerModel : BaseModel

@property (nonatomic,strong)NSString* count;        //成交订单
@property (nonatomic,strong)NSString* createtime;   //当前时间
@property (nonatomic,strong)NSString* money;        //消费金额
@property (nonatomic,strong)NSString* name;         //名字
@property (nonatomic,strong)NSString* phone;        //电话
@property (nonatomic,strong)NSString* picname;      //头像
@property (nonatomic,strong)NSString* picsrc;       //头像的文件夹

/*
 "count":null,"createtime":1481252156000,"money":null,"name":null,"phone":"18755555555","picname":null,"picsrc":null,"rn":1
 */
@end
