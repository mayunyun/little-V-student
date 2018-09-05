//
//  ProDetailTbViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeProGoods = 0,
    typeProPoint = 1,
}	typeProDetail;



#import "BaseViewController.h"

@interface ProDetailTbViewController : BaseViewController

@property (nonatomic,strong)NSString* proid;

@property (nonatomic,assign)typeProDetail typepro;



@end
