//
//  HomeHotGoodsViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/16.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeHomeHot = 0,        //热卖
    typeHomtBenefit = 1,    //每天特惠
}	typeHomeType;

#import "BaseViewController.h"

@interface HomeHotGoodsViewController : BaseViewController
@property(nonatomic,copy)NSString *Id;
@property (nonatomic,strong)NSString* text;
@property (nonatomic,assign)typeHomeType hometype;
@end
