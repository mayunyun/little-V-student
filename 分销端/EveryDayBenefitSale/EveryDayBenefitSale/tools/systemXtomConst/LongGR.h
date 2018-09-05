//
//  LongGR.h
//  DDwork
//
//  Created by 山东三米 on 13-11-14.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongGR : UILongPressGestureRecognizer
@property(nonatomic,assign)UIViewController *temVC;
@property(nonatomic,assign)NSInteger touchRow;//用来标示行号
@property(nonatomic,assign)NSInteger touchI;//scroll中第几个
@end
