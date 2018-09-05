//
//  FindViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarReaderViewController.h"//二维码

@interface FindViewController : BaseViewController<ZBarReaderDelegate>
{
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
}
@property (nonatomic, strong) UIImageView * line;//二维码
@end
