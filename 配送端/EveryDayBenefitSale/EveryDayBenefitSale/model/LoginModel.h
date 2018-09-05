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
@property (nonatomic,strong)NSString* linker;
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* qq;


/*
 [{"account":"小云","createtime":1474423102000,"custtypeid":1,"golds":"0","id":48,"isvalid":1,"linker":"宋叶强","linkerid":54,"name":"小云","password":"1f:da:c2:ff:ed:24:17:67","phone":"14578963215"}]
 */
@end
