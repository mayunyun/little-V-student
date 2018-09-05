//
//  PayForVC.h
//  lx
//
//  Created by 邱 德政 on 16/1/19.
//  Copyright © 2016年 lx. All rights reserved.
//

//ui隐藏
typedef enum {
    typeAliPay = 0,
    typeWXPay,
}	typePay;

#import "BaseViewController.h"

@interface PayForVC : BaseViewController

@property(nonatomic,assign)typePay paytype;//支付类型
//- - - - - 支付宝参数
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *mssage1;
@property(nonatomic,copy)NSString *orderMoney1;
@property(nonatomic,copy)NSString *orderno1;
@property(nonatomic,copy)NSString* orderstr;

// - - - - - 微信参数
@property (nonatomic,copy)NSString* WXmoney;//必填
@property (nonatomic,copy)NSString* WXorderno;//必填
@property (nonatomic,copy)NSString* WXbody;//必填

@end
