//
//  AllVC.m
//  BiaoBiao
//
//  Created by 山东三米 on 14-4-24.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//

#import "AllVC.h"
#import "XtomConst.h"

@interface AllVC ()

@end

@implementation AllVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout= UIRectEdgeNone;
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //[self.navigationController.navigationBar setBarTintColor:BB_Green_Color];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *mystr = NSStringFromClass([self.navigationController.viewControllers.lastObject class]);
       /*
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    */
    //NSLog(@"你妹呢：%@",mystr);
}
-(void)viewWillDisappear:(BOOL)animated
{
//    NSString *mystr = NSStringFromClass([self.navigationController.viewControllers.lastObject class]);
    [super viewWillDisappear:animated];
}
/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return YES;
    }else
    {
        return NO;
    }
}
 */
@end
