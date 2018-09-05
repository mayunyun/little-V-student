//
//  HomevillageViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCustInfoAddressModel.h"

@interface HomevillageViewController : BaseViewController

@property (nonatomic,strong)NSString* centerId;
@property (nonatomic,strong)NSString* centerName;

@property (nonatomic,strong)GetCustInfoAddressModel* addressmodel;

@property (nonatomic, copy) void (^transVaule)(GetCustInfoAddressModel* model);



@end
