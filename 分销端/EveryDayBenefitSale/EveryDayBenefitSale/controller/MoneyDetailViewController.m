//
//  MoneyDetailViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MoneyDetailViewController.h"

@interface MoneyDetailViewController ()
{
    UILabel* _totalMoneyLabel;
    UILabel* _monthLabel;
    UILabel* _monthMoneyLabel;
    UILabel* _AccumulatedAddLabel;
    UILabel* _AccumulatedReduceLabel;
}
@property (nonatomic,strong)UIDatePicker* datePicker;
@property (nonatomic,strong)UIView* timeView;
@property (nonatomic,strong)NSArray* currentDateArray;

@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金明细";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    [self dataRequest];
    [self searchfeesRequestData];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    UIScrollView* groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    groundView.backgroundColor = BackGorundColor;
    [self.view addSubview:groundView];
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    [groundView addSubview:headerView];
    
    UILabel* totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, headerView.width, 20)];
    totalLabel.text = @"总数";
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = GrayTitleColor;
    [groundView addSubview:totalLabel];
    _totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, totalLabel.bottom+5, totalLabel.width, 30)];
    _totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _totalMoneyLabel.textColor = NavBarItemColor;
    [groundView addSubview:_totalMoneyLabel];
    
    UIView* firstCellView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.bottom+30, mScreenWidth, 44)];
    firstCellView.backgroundColor = [UIColor whiteColor];
    [groundView addSubview:firstCellView];
    _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, firstCellView.height)];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.textColor = NavBarItemColor;
    [firstCellView addSubview:_monthLabel];
    _monthMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_monthLabel.right, 0, mScreenWidth - 60 - 30, _monthLabel.height)];
    _monthMoneyLabel.textColor = [UIColor blackColor];
    _monthMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [firstCellView addSubview:_monthMoneyLabel];
    UIButton* riliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    riliBtn.frame = CGRectMake(_monthMoneyLabel.right , 10, 30, 30);
    [riliBtn setImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    [firstCellView addSubview:riliBtn];
    [riliBtn addTarget:self action:@selector(riliBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
                     
    
    UIView* sencondView = [[UIView alloc]initWithFrame:CGRectMake(0, firstCellView.bottom+5, mScreenWidth, 90)];
    sencondView.backgroundColor = [UIColor whiteColor];
    [groundView addSubview:sencondView];
    
    UIImageView* redView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 10)];
    redView.backgroundColor = [UIColor redColor];
    [sencondView addSubview:redView];
    _AccumulatedAddLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, sencondView.width - 30, 45)];
    _AccumulatedAddLabel.textColor = GrayTitleColor;
    _AccumulatedAddLabel.font = [UIFont systemFontOfSize:13];
    [sencondView addSubview:_AccumulatedAddLabel];
    
    UIImageView* greenView = [[UIImageView alloc]initWithFrame:CGRectMake(redView.left, 45+15, 10, 10)];
    greenView.backgroundColor = [UIColor greenColor];
    [sencondView addSubview:greenView];
    _AccumulatedReduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, _AccumulatedAddLabel.bottom, sencondView.width - 30, 45)];
    _AccumulatedReduceLabel.textColor = GrayTitleColor;
    _AccumulatedReduceLabel.font = [UIFont systemFontOfSize:13];
    [sencondView addSubview:_AccumulatedReduceLabel];
    
    
    
}

- (void)riliBtnClick:(UIButton*)sender
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
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,100, mScreenWidth, 216)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.backgroundColor = [UIColor clearColor];
        [_timeView addSubview:_datePicker];
            //
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,windowView.height - 90 , windowView.width, 1)];
            line.backgroundColor = COLOR(240, 240, 240, 1);
            [windowView addSubview:line];
    
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(windowView.width/2,line.bottom , 1, 40)];
            line1.backgroundColor = COLOR(240, 240, 240, 1);
            [windowView addSubview:line1];
            //
            UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom,(windowView.width - 1)/2, 60)];
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
            [cancel addTarget:self action:@selector(closedatePickertime) forControlEvents:UIControlEventTouchUpInside];
            [windowView addSubview:cancel];
    
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(windowView.width/2 +1, line.bottom, (windowView.width - 1)/2, 60)];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16.0];
            [button addTarget:self action:@selector(closedatePickertime) forControlEvents:UIControlEventTouchUpInside];
            [windowView addSubview:button];
        
    }
    return _timeView;
}

- (void)closetime{
    
    [_timeView removeFromSuperview];
    _timeView = nil;
}

- (void)closedatePickertime
{
    if (self.datePicker) {
        [_timeView removeFromSuperview];
        _timeView = nil;
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc]init];
        [dateFormatter1 setDateFormat:@"MM"];
        NSDateFormatter *dateFormatter2 =[[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"dd"];
        NSString* yearstr = [dateFormatter stringFromDate:self.datePicker.date];
        NSString* monthStr = [dateFormatter1 stringFromDate:self.datePicker.date];
        NSString* dataStr = [dateFormatter2 stringFromDate:self.datePicker.date];
        _currentDateArray =@[yearstr,monthStr,dataStr];
        _monthLabel.text = [NSString stringWithFormat:@"%@月",_currentDateArray[1]];
    }

}


- (void)dateChange:(UIDatePicker*)sender{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter2 =[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd"];
    NSString* yearstr = [dateFormatter stringFromDate:sender.date];
    NSString* monthStr = [dateFormatter1 stringFromDate:sender.date];
    NSString* dataStr = [dateFormatter2 stringFromDate:sender.date];
    _currentDateArray =@[yearstr,monthStr,dataStr];
    _monthLabel.text = [NSString stringWithFormat:@"%@月",_currentDateArray[1]];
}

- (void)dataRequest
{
    _totalMoneyLabel.text = @"1000.00";
    _monthLabel.text = @"07月";
    _monthMoneyLabel.text = @"￥100.00";
    _AccumulatedAddLabel.text = @"累计佣金：￥10000.00";
    _AccumulatedReduceLabel.text = @"累计提现：￥10000.00";
}

- (void)searchfeesRequestData
{
    /*
     /fees/searchfees.do
     distributeid
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/fees/searchfees.do"];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* datastr = [NSString stringWithFormat:@"{\"distributeid\":\"%@\",\"page\":\"1\",\"rows\":\"20\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/fees/searchfees.do%@",str);
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];

}





@end
