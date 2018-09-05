//
//  LoginModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel

@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* custtypeid;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* qq;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* bankcard;
@property (nonatomic,strong)NSString* accoutpic;


/*
[{"account":"fxzx2","accoutpic":null,"bankcard":null,"createtime":1477375253000,"custtypeid":2,"custtypename":null,"email":null,"golds":null,"id":104,"invitecode":null,"isrest":null,"isvalid":1,"name":"fxzx2","note":null,"password":"a4:c7:b8:93:e8:5e:ca:b7","phone":"15069019010","picname":null,"picsrc":null,"qq":null,"receiverjigou":null}]
 */
@end
