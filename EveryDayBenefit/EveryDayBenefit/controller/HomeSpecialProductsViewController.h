//
//  HomeSpecialProductsViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeSpecialProductsViewController : BaseViewController

@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *titlename;
@property(nonatomic,assign)NSInteger searchSign;

@property(nonatomic,copy)NSString *isgroup;  //否为组合产品默认0为否，1为礼包、2为限时购、3为优惠活动、4为买x赠y

@end
