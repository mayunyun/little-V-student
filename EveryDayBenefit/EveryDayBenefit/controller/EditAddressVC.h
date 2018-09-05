//
//  EditAddressVC.h
//  EveryDayBenefit
//
//  Created by 钱龙 on 2018/1/29.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "InviteCodeAddrModel.h"
#import "AddressManageModel.h"
@interface EditAddressVC : BaseViewController
@property (nonatomic,strong)InviteCodeAddrModel* selectAddModel;
@property (nonatomic,strong)AddressManageModel * addModel;
@end
