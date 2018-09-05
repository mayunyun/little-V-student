//
//  BaseNavViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/9.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()<UINavigationControllerDelegate>
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;
@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    if(IOS7)
    {
//        self.navigationBar.barTintColor = [UIColor colorWithHexString:@"0074FF"];
        self.navigationBar.translucent = NO;
    }
    else
    {
//        self.navigationBar.tintColor = [UIColor colorWithHexString:@"0074FF"];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
//    if (self.pushing == YES) {
//        NSLog(@"被拦截");
//        return;
//    } else {
//        NSLog(@"push");
//        self.pushing = YES;
//    }
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    }
}


- (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 21);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSInteger countOfViewControllers = self.viewControllers.count;
    while (countOfViewControllers > 0) {
        
        [self popViewControllerAnimated:NO];
        countOfViewControllers--;
    }
    return nil;
}



//横竖屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}
- (BOOL)shouldAutorotate
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == 3)
    {
        return NO;
    }
    return NO;
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
}

@end
