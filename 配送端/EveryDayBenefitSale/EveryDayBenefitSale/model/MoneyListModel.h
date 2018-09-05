//
//  MoneyListModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MoneyListModel : BaseModel

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaprofit;
@property (nonatomic,strong)NSString* centerprofit;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* confirmcount;
@property (nonatomic,strong)NSString* createtime;   //创建时间
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* custphone;
@property (nonatomic,strong)NSString* distributeid;
@property (nonatomic,strong)NSString* distributeprofit;
@property (nonatomic,strong)NSString* golds;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isbudget;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* ordercount;
@property (nonatomic,strong)NSString* ordermoney;
@property (nonatomic,strong)NSString* orderno;      //订单号
@property (nonatomic,strong)NSString* orderstatus;
@property (nonatomic,strong)NSString* partprofit;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* receiveraddr;
@property (nonatomic,strong)NSString* regionprofit;
@property (nonatomic,strong)NSString* senderid;
@property (nonatomic,strong)NSString* senderprofit; //配送人员利润
@property (nonatomic,strong)NSString* sendstatus;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* villageid;



/*
 {"areaid":1,"areaprofit":0.3,"centerprofit":3,"cityid":1,"confirmcount":0,"createtime":1476087100000,"custid":61,"custname":"云云","custphone":"13122222222","distributeid":"54","distributeprofit":9,"golds":9,"id":96,"isbudget":0,"isvalid":1,"ordercount":3,"ordermoney":30,"orderno":"dd201610100007","orderstatus":0,"partprofit":0.3,"platprofit":0.75,"provinceid":1,"receiveraddr":"山东省济南市历下区七里河分区二成小区206","regionprofit":0.15,"rn":1,"senderid":"41","senderprofit":6,"sendstatus":1,"serviceid":18,"villageid":13}
 */




@end
