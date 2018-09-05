//
//  ViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AddressPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self creatUI];
}

- (void)creatUI
{
    AddressPickerView* view = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    [self.view addSubview:view];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
