//
//  GetCustInfoAddressModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/22.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface GetCustInfoAddressModel : BaseModel

@property (nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* area;
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* city;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* province;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* servicecenter;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* village;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* isdefault;//1默认地址
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;

@property (nonatomic,strong)NSString* comunity;
@property (nonatomic,strong)NSString* xiaoqu;
@property (nonatomic,strong)NSString* roomnumber;
@property (nonatomic,strong)NSString* louhao;
@property (nonatomic,strong)NSString* phone;//用在自取的商品上面。

/*
 {
 address = "\U60f3";
 area = "\U4e1c\U57ce\U533a";
 areaid = 1;
 city = "\U5317\U4eac\U5e02";
 cityid = 1;
 custid = 61;
 id = 71;
 province = "\U5317\U4eac\U5e02";
 provinceid = 1;
 servicecenter = "a+\U4e1a\U52a1\U4e2d\U5fc3";
 serviceid = 18;
 village = "\U4e8c\U6210\U5c0f\U533a";
 villageid = 13;
 linker = fxzx2;
 linkerid = 104;
  isdefault = 1;
 }

 */

@end
