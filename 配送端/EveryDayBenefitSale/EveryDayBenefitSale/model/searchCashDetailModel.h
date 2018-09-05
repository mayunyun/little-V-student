//
//  searchCashDetailModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface searchCashDetailModel : BaseModel

@property (nonatomic,strong)NSString* cashno;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isbudget;
@property (nonatomic,strong)NSString* money;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* type;

/*
 {"cashno":"tx201611010001","createtime":1477963877000,"custid":106,"id":36,"isbudget":0,"money":10,"note":"提现","rn":1,"type":6,"createtime":"2016-11-01 09:31:17.0"},
 */

@end
