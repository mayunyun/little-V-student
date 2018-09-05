//
//  InviteCodeAddrModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/9.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface InviteCodeAddrModel : BaseModel

//@property (nonatomic,strong)NSString* add_areaid;
//@property (nonatomic,strong)NSString* add_areaname;
//@property (nonatomic,strong)NSString* add_cityid;
//@property (nonatomic,strong)NSString* add_cityname;
//@property (nonatomic,strong)NSString* add_provinceid;
//@property (nonatomic,strong)NSString* add_provincename;
//@property (nonatomic,strong)NSString* add_serviceid;
//@property (nonatomic,strong)NSString* add_servicename;
//@property (nonatomic,strong)NSString* add_villageid;
//@property (nonatomic,strong)NSString* add_villagename;

@property (nonatomic,strong)NSString* province;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* city;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* area;
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* servicecenter;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* housenumber;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* community;
@property (nonatomic,strong)NSString* xiaoqu;
@property (nonatomic,strong)NSString* roomnumber;
@property (nonatomic,strong)NSString* louhao;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;

/*
{"address":"详细","area":"小店区","areaid":221,"city":"太原市","cityid":16,"community":"小店小区","custid":169,"housenumber":"56号","id":426,"isdefault":0,"linker":"小店分销one","linkerid":166,"louhao":5,"province":"山西省","provinceid":4,"roomnumber":"99号楼","servicecenter":"小店街","serviceid":38,"villageid":11,"xiaoqu":6}
 */

@end
