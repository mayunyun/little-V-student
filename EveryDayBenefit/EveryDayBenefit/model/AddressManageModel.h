//
//  AddressManageModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface AddressManageModel : BaseModel

@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* cityname;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* provincename;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* servincename;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* village;
@property (nonatomic,strong)NSString* isdefault;
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)NSString* addressname;
@property (nonatomic,strong)NSString* doornumbername;//doornumber名称
@property (nonatomic,strong)NSString* doornumber;//doornumberId
@property (nonatomic,strong)NSString* comunity;
@property (nonatomic,strong)NSString* comunityid;
@property (nonatomic,strong)NSString* roomnumber;
@property (nonatomic,strong)NSString* roomnumberid;

/*
{"address":"刘智远","areaid":3146,"areaname":"高新区","cityid":138,"cityname":"济南市","custid":63,"id":250,"isdefault":0,"provinceid":15,"provincename":"山东省","serviceid":30,"servincename":"齐鲁软件园分区","villageid":100005,"villagename":"齐鲁软件园b业务中心"}
 */

@end
