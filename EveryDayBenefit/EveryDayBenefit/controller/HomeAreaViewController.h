//
//  HomeAreaViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCustInfoAddressModel.h"
@interface HomeAreaViewController : BaseViewController

@property (nonatomic,strong)NSString* cityId;
@property (nonatomic,strong)NSString* cityName;
@property (nonatomic,strong)GetCustInfoAddressModel* addressmodel;

@end
