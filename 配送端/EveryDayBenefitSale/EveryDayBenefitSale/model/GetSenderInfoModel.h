//
//  GetSenderInfoModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface GetSenderInfoModel : BaseModel
@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* accoutpic;
@property (nonatomic,strong)NSString* bankcard;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custtypeid;
@property (nonatomic,strong)NSString* custtypename;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* golds;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* invitecode;
@property (nonatomic,strong)NSString* isrest;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* picsrc;
@property (nonatomic,strong)NSString* qq;


/*
 [{"account":"pszx1","accoutpic":null,"bankcard":null,"createtime":1477375413000,"custtypeid":1,"custtypename":null,"email":null,"golds":null,"id":106,"invitecode":null,"isrest":null,"isvalid":1,"name":"pszx1","note":null,"password":"a4:c7:b8:93:e8:5e:ca:b7","phone":"15069019018","picname":null,"picsrc":null,"qq":null,"receiverjigou":null},{"addrlist":[]}]
 */

@end
