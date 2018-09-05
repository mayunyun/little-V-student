//
//  LoginModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/22.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel

@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* custtypeid;//客户端
@property (nonatomic,strong)NSString* Id;       //用户id
@property (nonatomic,strong)NSString* isvalid;  //有效id
@property (nonatomic,strong)NSString* linker;   //绑定分销人
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* phone;//手机号
//
@property (nonatomic,strong)NSString* name;

/*
 [{"createtime":1474507309000,"custtypeid":0,"id":61,"isvalid":1,"linker":"宋叶强","linkerid":54,"password":"a4:c7:b8:93:e8:5e:ca:b7","phone":"18353130831"}]
 */



@end
