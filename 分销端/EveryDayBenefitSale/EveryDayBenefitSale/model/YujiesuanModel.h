//
//  YujiesuanModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/16.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface YujiesuanModel : BaseModel

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* cityname;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* danjuhao;
@property (nonatomic,strong)NSString* inmoney;
@property (nonatomic,strong)NSString* jiecun;
@property (nonatomic,strong)NSString* outmoney;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* provincename;
@property (nonatomic,strong)NSString* qichu;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* servicename;
@property (nonatomic,strong)NSString* settlement_id;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* villagename;

/*
 "areaid":10,"areaname":"高新区","cityid":5,"cityname":"济南市","createtime":1479261762000,"custid":153,"custname":"客户1","danjuhao":"dd201611160001","inmoney":260.9,"jiecun":260.9,"outmoney":0,"provinceid":1,"provincename":"山东省","qichu":0,"rn":1,"serviceid":29,"servicename":"工业南路58号","settlement_id":226,"villageid":58,"villagename":"东岭尚座2层206","createtime":"2016-11-16 10:02:42.0"},
 */

@end
