//
//  RegisterSureViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/30.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "InviteCodeAddrModel.h"

@interface RegisterSureViewController : BaseViewController

@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* code;
@property(nonatomic,strong)NSString * aconunt;
@property (nonatomic,strong)NSString* linkerid;
@property (nonatomic,strong)InviteCodeAddrModel* selectAddModel;

@end
