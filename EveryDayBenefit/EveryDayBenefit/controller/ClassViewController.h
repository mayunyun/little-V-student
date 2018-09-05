//
//  ClassViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
typedef enum {
    typeGoods = 0,
    typePoint = 1,
}    typeDetail;
#import "BaseViewController.h"

@interface ClassViewController : BaseViewController
@property (nonatomic,strong)NSString* proid;

@property (nonatomic,assign)typeDetail type;
@end
