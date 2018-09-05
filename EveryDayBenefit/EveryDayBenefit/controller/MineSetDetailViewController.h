//
//  MineSetDetailViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
@interface MineSetDetailViewController : BaseViewController

@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,retain)GetCustInfoAddressModel* addressModel;

@end
