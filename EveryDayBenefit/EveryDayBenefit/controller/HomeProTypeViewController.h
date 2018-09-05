//
//  HomeProTypeViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
typedef enum {
    tGoods = 0,
    tPoint = 1,
}    tType;
#import "BaseViewController.h"

@interface HomeProTypeViewController : BaseViewController
@property (nonatomic,assign)tType type;
@property (nonatomic,strong)NSString* iconid;
@property (nonatomic,strong)NSString* titlename;

@end
