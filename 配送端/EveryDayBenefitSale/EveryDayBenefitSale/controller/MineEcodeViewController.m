//
//  MineEcodeViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineEcodeViewController.h"
//#import "ORImageView.h"
#import "UIImage+MDQRCode.h"

@interface MineEcodeViewController ()

@end

@implementation MineEcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的邀请码";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    NSString* str = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* code = [NSString stringWithFormat:@"ps%@",str];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth - 300)/2, 30, 300, 300)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%@",code] size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
