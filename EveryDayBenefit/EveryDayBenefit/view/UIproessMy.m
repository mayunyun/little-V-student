//
//  UIproessMy.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "UIproessMy.h"

@implementation UIproessMy
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width*self.rate, frame.size.height)];
        self.leftView.backgroundColor = color;
        self.rightView=[[UIView alloc]initWithFrame:CGRectMake(self.leftView.right, 0,frame.size.width - self.leftView.width, frame.size.height)];
        self.rightView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
    }
    return self;
}

- (void)setRate:(float)rate
{
    _rate = rate;
    self.leftView.frame = CGRectMake(0, 0, self.width*_rate, self.height);
    self.rightView.frame = CGRectMake(self.leftView.right, 0,self.width - self.leftView.width, self.height);
}




@end

