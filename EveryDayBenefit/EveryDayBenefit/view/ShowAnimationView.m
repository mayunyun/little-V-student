//
//  ShowAnimationView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/9.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ShowAnimationView.h"

@interface ShowAnimationView ()

@property (nonatomic, strong) UIView  *contentView;
@end

@implementation ShowAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
    bgView.alpha = 0.3;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    [bgView addGestureRecognizer:tapGesture];
    
    /*创建显示View*/
//    _contentView = [[UIView alloc] init];
//    _contentView.frame = CGRectMake(0, 0, self.frame.size.width - 40, 180);
//    _contentView.backgroundColor=[UIColor whiteColor];
//    _contentView.layer.cornerRadius = 4;
//    _contentView.layer.masksToBounds = YES;
//    [self addSubview:_contentView];
    /*可以继续在其中添加一些View 虾米的*/
//    UITextField* text = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, mScreenWidth - 20, 40)];
//    text.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:text];
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    [self dismissContactView];
}

-(void)dismissContactView
{
//    __weak typeof(self)weakSelf = self;
//    [UIView animateWithDuration:0.5 animations:^{
//        weakSelf.alpha = 0;
//    } completion:^(BOOL finished) {
//        [weakSelf removeFromSuperview];
//    }];
}

// 这里加载在了window上
-(void)showView
{
//    UIWindow * window = [UIApplication sharedApplication].windows[0];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    NSInteger i = 0;
    for (UIView* view in window.subviews) {
        if ([view isKindOfClass:[ShowAnimationView class]]) {
            i++;
        }
    }
    if (i==0) {
        [window addSubview:self];
        NSLog(@"添加---%@",self);
    }
}

- (void)hideView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    for (id view in window.subviews) {
        NSLog(@"window上面的%@",view);
        if ([view isKindOfClass:[ShowAnimationView class]]) {
            [self removeFromSuperview];
            NSLog(@"删除---%@",self);
        }
    }
}


@end
