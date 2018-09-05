//
//  HomeCityViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCustInfoAddressModel.h"

@interface HomeCityViewController : BaseViewController

@property (nonatomic,strong)NSString* proId;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)GetCustInfoAddressModel* addressmodel;

@end
