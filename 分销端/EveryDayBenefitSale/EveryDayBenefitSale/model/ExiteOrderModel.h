//
//  ExiteOrderModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ExiteOrderModel : BaseModel

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaprofit;
@property (nonatomic,strong)NSString* centerprofit;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* distributeprofit;
@property (nonatomic,strong)NSString* exiteaddress;
@property (nonatomic,strong)NSString* exitecount;
@property (nonatomic,strong)NSString* exiteno;
@property (nonatomic,strong)NSString* exitestatus;
@property (nonatomic,strong)NSString* exitmoney;
@property (nonatomic,strong)NSString* golds;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)NSString* linkerstatus;//审核未审核
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* partprofit;
@property (nonatomic,strong)NSString* platprofit;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* regionprofit;
@property (nonatomic,strong)NSString* senderprofit;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* isgolds;
@property (nonatomic,strong)NSString* sendstatus;
//
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSArray* prolist;

@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prono;
@property (nonatomic,strong)NSString* prounitid;
@property (nonatomic,strong)NSString* saleprice;
@property (nonatomic,strong)NSString* custphone;
@property (nonatomic,strong)NSString* orderno;

/*
{"areaid":1,"areaprofit":0.08,"centerprofit":6,"cityid":1,"createtime":1476786015000,"custid":63,"custname":"zzzz","distributeprofit":2,"exiteaddress":"北京市北京市东城区西城分区(null)默认地址","exitecount":2,"exiteid":"11","exitemoney":8,"exiteno":"th201610180006","exitestatus":0,"exitmoney":8,"folder":"tmp/","golds":8,"id":11,"linker":"宋丹丹","linkerid":22,"linkerstatus":0,"note":"11","partprofit":0.08,"picname":"147598384974181bingan.jpg","platprofit":0.2,"proid":35,"proname":"饼干","prono":"201609050001","prounitid":50,"provinceid":1,"regionprofit":0.04,"rn":1,"saleprice":4,"senderprofit":4,"serviceid":18,"specification":"一箱24包","villageid":13}
 */

@end
