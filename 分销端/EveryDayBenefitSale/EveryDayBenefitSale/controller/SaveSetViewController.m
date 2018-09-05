//
//  SaveSetViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "SaveSetViewController.h"
#import "MineTableViewCell.h"
#import "ResetPwdViewController.h"
#import "LoginViewController.h"

@interface SaveSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    UIView* _timeView;
}

@end

@implementation SaveSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全设置";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth, 44)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    [self.view addSubview:_tbView];
    
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.view addSubview:exitBtn];
    exitBtn.frame = CGRectMake(0, _tbView.bottom+60, mScreenWidth, 44);
    [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitBtn setBackgroundColor:[UIColor whiteColor]];
    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil]firstObject];
    }
    cell.imgView.image = [UIImage imageNamed:@"icon_03"];
    cell.titleLabel.text = @"密码找回";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResetPwdViewController* vc = [[ResetPwdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)exitBtnClick:(UIButton*)sender
{
    [self startAction];
}

- (UIView*)startAction{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _timeView.backgroundColor = MyAleartColor;
        [APPDelegate.window addSubview:_timeView];
        //
        UIView* bgView = [[UIView alloc]initWithFrame:_timeView.bounds];
        bgView.backgroundColor = [UIColor clearColor];
        [_timeView addSubview:bgView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closetime)];
        tap.numberOfTapsRequired = 1;
        [bgView addGestureRecognizer:tap];
        //
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(30, (mScreenHeight - 350)/2, mScreenWidth -60, 350)];
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.cornerRadius = 5;
        windowView.layer.masksToBounds = YES;
        windowView.userInteractionEnabled = YES;
        [_timeView addSubview:windowView];
        //
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, windowView.width, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"是否退出登录？";
        [windowView addSubview:label];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, windowView.height - 90, windowView.width, 90)];
        grayView.backgroundColor = BackGorundColor;
        [windowView addSubview:grayView];
        //
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,windowView.height - 90 , windowView.width, 1)];
        line.backgroundColor = GrayTitleColor;
        [windowView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(windowView.width/2,line.bottom , 1, 40)];
        line1.backgroundColor = GrayTitleColor;
        [windowView addSubview:line1];
        //
        UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom,(windowView.width - 1)/2, 60)];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [windowView addSubview:cancel];
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(windowView.width/2 +1, line.bottom, (windowView.width - 1)/2, 60)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [windowView addSubview:button];
        
    }
    return _timeView;
}


- (void)closetime
{

}

- (void)cancelBtnClick:(UIButton*)sender
{
    [_timeView removeFromSuperview];
    _timeView = nil;
}

- (void)sureBtnClick:(UIButton*)sender
{
    [self outlogin];
}

- (void)outlogin
{
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/outLogin.do"];
    NSLog(@"%@",urlstr);
    [DataPost requestAFWithUrl:urlstr params:nil finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"退出登录%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"退出登录"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AutoLogin];
        }
        [_timeView removeFromSuperview];
        _timeView = nil;
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"退出登录错误信息,%@",error.localizedDescription);
    }];
}






@end
