//
//  GetCustInfoModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/22.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface GetCustInfoModel : BaseModel

@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custtypeid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* picsrc;
@property (nonatomic,strong)NSString* golds;

/*
 account = "\U4e09";
 createtime = 1474538123000;
 custtypeid = 0;
 golds = ".9";
 id = 63;
 isvalid = 1;
 linker = "\U5b8b\U4e39\U4e39";
 linkerid = 22;
 name = zzzz;
 password = "17:8a:4d:e3:91:8e:2a:9b";
 phone = 13111111111;
 picname = "14766740989859320161017111458.jpg";
 picsrc = "header/";
 */



@end
