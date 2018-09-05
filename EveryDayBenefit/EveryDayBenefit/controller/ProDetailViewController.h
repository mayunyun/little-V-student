//
//  ProDetailViewController.h
//  lx
//
//  Created by 联祥 on 16/1/8.
//  Copyright © 2016年 lx. All rights reserved.
//  废弃的Controller

#import "BaseViewController.h"

@interface ProDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *proId;
@property(nonatomic,copy)NSString *isgroup;

//否为组合产品默认0为否，1为礼包、2为限时购、3为优惠活动、4为买x赠y


@property (nonatomic,assign)BOOL isCollection;

@end
