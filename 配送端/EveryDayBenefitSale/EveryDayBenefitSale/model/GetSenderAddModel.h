//
//  GetSenderAddModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/7.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface GetSenderAddModel : BaseModel

@property(nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* area;
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* city;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isdefault;
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)NSString* province;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* servicecenter;
@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* village;
@property (nonatomic,strong)NSString* villageid;


/*
 address = 444;
 area = "\U9ad8\U65b0\U533a";
 areaid = 3146;
 city = "\U6d4e\U5357\U5e02";
 cityid = 138;
 custid = 114;
 id = 291;
 isdefault = 0;
 linker = myy;
 linkerid = 113;
 province = "\U5c71\U4e1c\U7701";
 provinceid = 15;
 servicecenter = "\U9f50\U9c81\U8f6f\U4ef6\U56ed\U5206\U533a";
 serviceid = 30;
 village = "\U9f50\U9c81\U8f6f\U4ef6\U56edc\U4e1a\U52a1\U4e2d\U5fc3";
 villageid = 100012;
 */

@end
