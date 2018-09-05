//
//  UIproessMy.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIproessMy : UIView
@property(strong,nonatomic)UIView *leftView;
@property(strong,nonatomic)UIView *rightView;
@property(assign,nonatomic)float rate;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color;

@end
