//
//  MineViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#define Rate 0.0025
#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "CashWaterViewController.h"
#import "MoneyDetailListViewController.h"
#import "YuJieSuanDetailViewController.h"
#import "SaveSetViewController.h"
#import "MineEcodeViewController.h"
#import "LoginViewController.h"
#import "searchCashDetailModel.h"
#import "CashSearchyueModel.h"
#import "GetSenderInfoModel.h"
#import "ReportFenxiaoModel.h"
#import "OrderTimeOutViewController.h"
#import "OrderMineCustViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView* _tbView;
    UILabel* _moneyLabel;
    UILabel* _benyuelabel;
    UILabel* _upyueLabel;
    UIButton* _takeMoneyBtn;
    UIView* _myAleareView;
    UITextField* _moneyTextField;
    UILabel* _trueMoneyLabel;
    UITextView* _noteTextView;
    NSMutableArray* _searchCashDetailArray;
    
    NSString* _addcashMax;
    NSString* _busymoney;
}

@property (nonatomic,strong)NSArray* titleArray;
@property (nonatomic,strong)NSArray* iconsArray;
@property (nonatomic,strong)CashSearchyueModel* searchyueModel;
@property (nonatomic,strong)GetSenderInfoModel* senderModel;
@property (nonatomic,strong)ReportFenxiaoModel* reportModel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchCashDetailArray = [[NSMutableArray alloc]init];
    _titleArray = @[@[@"佣金明细",@"提现流水",@"结算查询",@"超时预警",@"安全设置",@"我的客户"],@[@"我的邀请码"]];
    _iconsArray = @[@[@"icon-yongjin",@"icon-tixian",@"icon-yujiesuan",@"icon-yujing",@"icon-shezhi",@"minecust"],@[@"icon-yaoqing"]];
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 120)];
    headerView.backgroundColor = NavBarItemColor;
    [self.view addSubview:headerView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 100, 20)];
    label.text = @"可提现金额:￥";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, label.bottom, 40, 40)];
    imageView.image = [UIImage imageNamed:@"money"];
    [headerView addSubview:imageView];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 50, mScreenWidth - 100 - label.width - 60, 20)];
    _moneyLabel.adjustsFontSizeToFitWidth = YES;
    _moneyLabel.text = @"money";
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_moneyLabel];
    _benyuelabel = [[UILabel alloc]initWithFrame:CGRectMake(60, _moneyLabel.bottom, (mScreenWidth - 100 - 60)/2, 20)];
    _benyuelabel.text = @"本月预结算：";
    _benyuelabel.adjustsFontSizeToFitWidth = YES;
    _benyuelabel.numberOfLines = 0;
    _benyuelabel.font = [UIFont systemFontOfSize:12];
    _benyuelabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_benyuelabel];
    
    _upyueLabel = [[UILabel alloc]initWithFrame:CGRectMake(_benyuelabel.left, _benyuelabel.bottom, _benyuelabel.width, _benyuelabel.height)];
    _upyueLabel.textColor = [UIColor whiteColor];
    _upyueLabel.text = @"上月预结算：";
    _upyueLabel.adjustsFontSizeToFitWidth = YES;
    _upyueLabel.numberOfLines = 0;
    _upyueLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:_upyueLabel];
    
    
    
    _takeMoneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _takeMoneyBtn.frame = CGRectMake(_moneyLabel.right+20, (headerView.height - 30)/2, 60, 30);
    [_takeMoneyBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_takeMoneyBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [_takeMoneyBtn addTarget:self action:@selector(takeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_takeMoneyBtn setBackgroundColor:[UIColor whiteColor]];
    _takeMoneyBtn.layer.masksToBounds = YES;
    _takeMoneyBtn.layer.cornerRadius = 5;
    [headerView addSubview:_takeMoneyBtn];
    
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, mScreenWidth, mScreenHeight - headerView.bottom - 49)];//
    _tbView.contentSize = CGSizeMake(mScreenWidth, 20+60*7);
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.rowHeight = 60;
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    [self.view addSubview:_tbView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    [self getPersonContent];
//    [self searchyueRequestData];
    [self loadfenxiaoemployeeprofitRequestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else if(section == 1) {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil]firstObject];
    }
    cell.imgView.image = [UIImage imageNamed:_iconsArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        //佣金明细
            MoneyDetailListViewController* vc = [[MoneyDetailListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
        //提现流水
            CashWaterViewController* vc = [[CashWaterViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            //预结算查询
            YuJieSuanDetailViewController* yuVC = [[YuJieSuanDetailViewController alloc]init];
            if (!IsEmptyValue(_reportModel.Id)) {
                yuVC.Id = _reportModel.Id;
                [self.navigationController pushViewController:yuVC animated:YES];
            }else{
                [self showAlert:@"没有预结算的单子"];
            }
        }else if (indexPath.row == 4){
            //安全设置
            SaveSetViewController* vc = [[SaveSetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            OrderTimeOutViewController* vc = [[OrderTimeOutViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 5){
            OrderMineCustViewController* vc = [[OrderMineCustViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if(indexPath.section == 1){
        //我的邀请码
        MineEcodeViewController* vc = [[MineEcodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}

- (void)takeMoneyClick:(UIButton*)sender
{
    if (!([_moneyLabel.text doubleValue] == 0)) {
        [self addCashUI];
    }else{
        [self showAlert:@"金额为空或已占用，请刷新个人中心金额"];
    }
}
//提现申请UI
- (UIView*)addCashUI
{
    if (_myAleareView == nil) {
        _myAleareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleareView.backgroundColor = [UIColor clearColor];
        //        [APPDelegate.window addSubview:_myAleareView];
        [self.view addSubview:_myAleareView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleareView.width, _myAleareView.height)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleareView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closemyAleartViewTap:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleareView.height - 260)/2, _myAleareView.width- 80, 260)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        [_myAleareView addSubview:windowView];
        
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        titleView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:titleView];
        
        UILabel* moneylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, titleView.height)];
        moneylabel.font = [UIFont systemFontOfSize:10];
        moneylabel.textColor = [UIColor whiteColor];
        moneylabel.adjustsFontSizeToFitWidth = YES;
        moneylabel.numberOfLines = 0;
        moneylabel.text = [NSString stringWithFormat:@"可提现:%@ |已申请:%@",_addcashMax,_busymoney];
        [windowView addSubview:moneylabel];
        
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(titleView.width - 60, 0, 60, titleView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* tixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, titleView.bottom+20, 60, 30)];
        tixianLabel.text = @"提现金额";
        tixianLabel.textColor = GrayTitleColor;
        tixianLabel.font = [UIFont systemFontOfSize:14];
        [windowView addSubview:tixianLabel];
        _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(tixianLabel.right, titleView.bottom+20, windowView.width- 10 - tixianLabel.right, 30)];
        _moneyTextField.delegate = self;
        _moneyTextField.placeholder = @"请输入金额";
        _moneyTextField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
        [windowView addSubview:_moneyTextField];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, _moneyTextField.bottom+20, 60, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"实际到账";
        label.textColor = GrayTitleColor;
        [windowView addSubview:label];
        _trueMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, label.top, (windowView.width - 20 - 100), 30)];
        _trueMoneyLabel.text = @"";
        //        _trueMoneyLabel.backgroundColor = LineColor;
        [windowView addSubview:_trueMoneyLabel];
        
        UILabel* beizhulabel = [[UILabel alloc]initWithFrame:CGRectMake(label.left, label.bottom+20, label.width, label.height)];
        beizhulabel.text = @"备注";
        beizhulabel.font = [UIFont systemFontOfSize:14];
        beizhulabel.textColor = GrayTitleColor;
        [windowView addSubview:beizhulabel];
        
        _noteTextView = [[UITextView alloc]initWithFrame:CGRectMake(beizhulabel.right, _trueMoneyLabel.bottom+20, _moneyTextField.width, 30)];
        _noteTextView.delegate = self;
        _noteTextView.textColor = [UIColor grayColor];
        //        _noteTextView.text = @"备注";
        [windowView addSubview:_noteTextView];
        
        UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.0;
        sureBtn.frame = CGRectMake(20, windowView.height - 50, windowView.width - 40, 40);
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.backgroundColor = NavBarItemColor;
        [windowView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myAleareView;
}

- (void)closemyAleartViewTap:(UITapGestureRecognizer*)sender
{
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)closeBtnClick:(UIButton*)sender
{
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)sureBtnClick:(UIButton*)sender
{
    if ([_moneyTextField.text isEqualToString:@""]) {
        [self showAlert:@"请填写提现金额"];
        return;
    }
    if ([_moneyTextField.text floatValue]==0.00) {
        [self showAlert:@"请输入大于0的金额"];
        return;
    }
    if ([_moneyTextField.text doubleValue] <= [_addcashMax doubleValue]) {
        [self addCashRequestData:sender];
    }else{
        [self showAlert:@"提现金额大于可提现金额"];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _moneyTextField) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _moneyTextField) {
//        double truemoney = 0.00;
        double newoney = 0.00;
        double money = [_moneyTextField.text doubleValue];
//        newoney = money*(1-Rate);
//        NSString* str2 = [NSString stringWithFormat:@"%.3f",newoney];
//        NSString* str3 = [str2 substringToIndex:[str2 length]-1];
        double new =  money*Rate;
        NSString* str4 = [NSString stringWithFormat:@"%.2f",new];
        newoney = money - [str4 doubleValue];
        _trueMoneyLabel.text = [NSString stringWithFormat:@"%.2f",newoney];
        
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _noteTextView) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _noteTextView) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"备注";
            textView.textColor = [UIColor grayColor];
        }
    }
}



#pragma mark - 获取个人信息
- (void)getPersonContent{
    /*
     /login/getCustInfo.do
     custid:用户id
     mobile:true
     */
    NSString* custid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    custid = [self convertNull:custid];
    NSDictionary *params = @{@"custid":custid,@"mobile":@"true"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/getCustInfo.do"];
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"获取个人信息%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"未登录,请先登录!"];
            LoginViewController *relogVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:relogVC animated:YES];
            
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"个人信息数据%@",array);
            if (!IsEmptyValue(array)) {
                _senderModel = [[GetSenderInfoModel alloc]init];
                if (!IsEmptyValue(array[0])) {
                    [_senderModel setValuesForKeysWithDictionary:array[0]];
                }
            }
        }
        //        [_hud hide:YES afterDelay:.5];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}

//提现
- (void)addCashRequestData:(UIButton*)sender
{
    /*
     /cash/addCash.do
     mobile:true
     data{
     type 5分销人6配送人
     custid :
     custname:
     money:
     note:
     }
     */
    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* custname = [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
    custname = [self convertNull:custname];
    double tax = [_moneyTextField.text doubleValue] - [_trueMoneyLabel.text doubleValue];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cash/addCash.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"type\":\"5\",\"custid\":\"%@\",\"custname\":\"%@\",\"money\":\"%@\",\"note\":\"%@\",\"tax\":\"%.2f\",\"realmoney\":\"%@\"}",userid,custname,_moneyTextField.text,_noteTextView.text,tax,_trueMoneyLabel.text];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/cash/addCash.do%@",str);
        if ([str rangeOfString:@"true"].location !=NSNotFound) {
            [self showAlert:@"提现申请成功"];
            [_myAleareView removeFromSuperview];
            _myAleareView = nil;
//            [self searchyueRequestData];
            [self loadfenxiaoemployeeprofitRequestData];
            
        }else if ([str rangeOfString:@"false"].location !=NSNotFound){
            [self showAlert:@"提现申请失败"];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        sender.enabled = YES;
    }];
    
}

- (void)searchyueRequestData
{
    /*
     /cash/searchyue.do
     mobile:true
     data{
     departid
     }
     */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cash/searchyue.do?1=1"];
    NSString* datastr = [NSString stringWithFormat:@"{\"departid\":\"%@\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/cash/searchyue.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/cash/pingtaisearchCash.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                if (!IsEmptyValue(array[0])) {
                    _searchyueModel= [[CashSearchyueModel alloc]init];
                    [_searchyueModel setValuesForKeysWithDictionary:array[0]];
                    [self pingtaisearchcashRequestData];
                }
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}

- (void)pingtaisearchcashRequestData
{
    /*
     /cash/pingtaisearchCash.do
     mobile:true
     page = 1
     rows = 10000000
     flag = 1
     data{
     custidEQ
     typeEQ:6配送端5分销端
     isbudgetEQ//0未结算1结算完成
     }
     */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cash/pingtaisearchCash.do?1=1"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custidEQ\":\"%@\",\"typeEQ\":\"5\",\"isbudgetEQ\":\"0\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr,@"page":@"1",@"rows":@"10000000",@"flag":@"1"};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/cash/pingtaisearchCash.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/cash/pingtaisearchCash.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            [_searchCashDetailArray removeAllObjects];
            double busymoney = 0.00;
            if (!IsEmptyValue(dict)) {
                NSArray* array = dict[@"rows"];
                if (!IsEmptyValue(array)) {
                    for (int i = 0; i <array.count; i++) {
                        searchCashDetailModel* model = [[searchCashDetailModel alloc]init];
                        [model setValuesForKeysWithDictionary:array[i]];
                        [_searchCashDetailArray addObject:model];
                        busymoney = busymoney + [model.money doubleValue];
                    }
                }
            }
            
//            double totlemoney = [_searchyueModel.money doubleValue];
            double totlemoney = [_reportModel.money doubleValue];
            totlemoney = totlemoney - busymoney;
            _addcashMax = [NSString stringWithFormat:@"%.2f",totlemoney];
            _busymoney = [NSString stringWithFormat:@"%.2f",busymoney];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}

- (void)loadfenxiaoemployeeprofitRequestData
{
/*
 /report/loadfenxiaoemployeeprofit.do
 page:1
 rows:20
 flag:1
 mobile:true
 data:{
 custidEQ:用户id
 }
 */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/report/loadfenxiaoemployeeprofit.do?page=1&&rows=1"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr,@"flag":@"1"};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"loadfenxiaoemployeeprofit.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location!=NSNotFound) {
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(dict)) {
                NSArray* array = dict[@"rows"];
                if (!IsEmptyValue(array)) {
                    _reportModel = [[ReportFenxiaoModel alloc]init];
                    [_reportModel setValuesForKeysWithDictionary:array[0]];
                    if (!IsEmptyValue(_reportModel.money)) {
                        _reportModel.money = [NSString stringWithFormat:@"%@",_reportModel.money];
                        _moneyLabel.text = [NSString stringWithFormat:@"%.2f",[_reportModel.money doubleValue]];
                    }
                    double benyue = [_reportModel.benyueprofit doubleValue];
                    _benyuelabel.text = [NSString stringWithFormat:@"本月预结算：%.2f",benyue];
                    double up = [_reportModel.upprofit doubleValue];
                    _upyueLabel.text = [NSString stringWithFormat:@"上月预结算：%.2f",up];
                    [self pingtaisearchcashRequestData];
                }
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}






@end
