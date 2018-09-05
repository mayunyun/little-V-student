//
//  CashWaterViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "CashWaterViewController.h"
#import "MoneyWorterTableViewCell.h"
#import "MBProgressHUD.h"
#import "searchCashDetailModel.h"
#import "NIDropDown.h"
#define typeEQ @"5"
@interface CashWaterViewController ()<UITableViewDelegate,UITableViewDataSource,NIDropDownDelegate>
{
    UITableView* _tbView;
    NSInteger _page;
    MBProgressHUD* _HUD;
    UIView* _myAleartView;
    UILabel* _startlabel;
    UILabel* _endLabel;
    UITextField* _cashnoTextField;
    UIButton* _stutasBtn;
    UIView* _timeView;
    NSInteger _leftOrRightflag;
    NIDropDown *dropDown;
    NSString* _orderselectFlag;//结算不结算
    BOOL _orderselect;
    NSArray* _orderstatuIdArray;
    NSArray* _orderstatusArray;
    NSArray* _currentDateArray;
    
}

@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIDatePicker* datePicker;

@end

@implementation CashWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    _leftOrRightflag = 0;
    self.title = @"提现流水";
    _orderstatusArray = @[@"未结算",@"结算完成"];
    _orderstatuIdArray = @[@"0",@"1"];
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"筛选"];
    
    [self creatUI];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _HUD.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self dataRequest];
    
}

- (void)backClick:(UIButton* )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    [self myaleartViewUI];
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, mScreenWidth - 20, mScreenHeight - 64)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.rowHeight = 140;
    [self.view addSubview:_tbView];
    
    //下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        if (!IsEmptyValue(_dataArray)) {
            [_dataArray removeAllObjects];
        }
        [self dataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
}

- (UIView*)myaleartViewUI
{
    if (_myAleartView == nil) {
        if (!_myAleartView) {
            _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
//            [APPDelegate.window addSubview:_myAleartView];
            [self.view addSubview:_myAleartView];
            
            UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
            grayView.backgroundColor = MyAleartColor;
            [_myAleartView addSubview:grayView];
            UITapGestureRecognizer* graytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colseBackview:)];
            [grayView addGestureRecognizer:graytap];
            
            UIImageView* windowView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (mScreenHeight - 300)/2,mScreenWidth - 80, 300)];
            windowView.userInteractionEnabled = YES;
            windowView.backgroundColor = COLOR(240, 240, 240, 1);
            [windowView.layer setCornerRadius:5];
            windowView.clipsToBounds = YES;
            [_myAleartView addSubview:windowView];
            
            //搜索的控件
            UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 40,40, windowView.width - 80, 30)];
            Label1.text = @"时间段";
            Label1.font = [UIFont systemFontOfSize:15.0];
            [windowView addSubview:Label1];
            
            CGFloat dataLabelWidth = 80;
            CGFloat reduceWidth = 30;
            CGFloat datagap = (Label1.width - dataLabelWidth*2 - reduceWidth)/2;
            _startlabel = [[UILabel alloc]initWithFrame:CGRectMake(Label1.left, Label1.bottom+5, dataLabelWidth, 30)];
            _startlabel.font = [UIFont systemFontOfSize:13.0];
            _startlabel.text = @"请选择";
            [self changeTextColor:_startlabel Txt:_startlabel.text changeTxt:_startlabel.text];
            [windowView addSubview:_startlabel];
            UITapGestureRecognizer* startTap = [[UITapGestureRecognizer alloc]init];
            _startlabel.userInteractionEnabled = YES;
            [_startlabel addGestureRecognizer:startTap];
            [startTap addTarget:self action:@selector(startlabelTapClick:)];
            UILabel* redeceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startlabel.right+datagap, _startlabel.top, reduceWidth, _startlabel.height)];
            redeceLabel.text = @"-";
            redeceLabel.textAlignment = NSTextAlignmentCenter;
            [windowView addSubview:redeceLabel];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(redeceLabel.right + datagap, _startlabel.top, _startlabel.width, _startlabel.height)];
            _endLabel.text = @"请选择";
            _endLabel.textAlignment = NSTextAlignmentRight;
            _endLabel.font = [UIFont systemFontOfSize:13];
            [self changeTextColor:_endLabel Txt:_endLabel.text changeTxt:_endLabel.text];
            [windowView addSubview:_endLabel];
            UITapGestureRecognizer* endTap = [[UITapGestureRecognizer alloc]init];
            _endLabel.userInteractionEnabled = YES;
            [_endLabel addGestureRecognizer:endTap];
            [endTap addTarget:self action:@selector(endTapClick:)];
            
            _cashnoTextField = [[UITextField alloc]initWithFrame:CGRectMake(Label1.left, _startlabel.bottom+10, Label1.width, 20)];
//            _cashnoTextField.delegate = self;
            _cashnoTextField.placeholder = @"请输入订单号";
            _cashnoTextField.layer.borderWidth = .5;
            _cashnoTextField.layer.masksToBounds = YES;
            _cashnoTextField.layer.cornerRadius = 3;
            _cashnoTextField.layer.borderColor = GrayTitleColor.CGColor;
            _cashnoTextField.adjustsFontSizeToFitWidth = YES;
            [windowView addSubview:_cashnoTextField];
            
            
            
            UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(Label1.left, _cashnoTextField.bottom + 10, Label1.width, Label1.height)];
            label2.font = [UIFont systemFontOfSize:15];
            label2.text = @"订单状态";
            [windowView addSubview:label2];
            
            _stutasBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _stutasBtn.frame = CGRectMake(label2.left, label2.bottom+5, label2.width, label2.height);
            [_stutasBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
            [_stutasBtn setTitle:@"空" forState:UIControlStateNormal];
            _orderselectFlag = @"";
            _stutasBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _stutasBtn.layer.borderWidth = .5;
            _stutasBtn.layer.masksToBounds = YES;
            _stutasBtn.layer.cornerRadius = 3;
            _stutasBtn.layer.borderColor = GrayTitleColor.CGColor;
            [windowView addSubview:_stutasBtn];
            [_stutasBtn addTarget:self action:@selector(stutasBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView* downimg = [[UIImageView alloc]initWithFrame:CGRectMake(_stutasBtn.width - 20, 10, 10, 10)];
            downimg.image = [UIImage imageNamed:@"do"];
            [_stutasBtn addSubview:downimg];
            
            UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
            [leftBtn setBackgroundColor:NavBarItemColor];
            [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            leftBtn.frame = CGRectMake(30, _stutasBtn.bottom+30, 60, 30);
            leftBtn.layer.masksToBounds = YES;
            leftBtn.layer.cornerRadius = 5;
            [windowView addSubview:leftBtn];
            [leftBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [rightBtn setTitle:@"重置" forState:UIControlStateNormal];
            [rightBtn setBackgroundColor:[UIColor grayColor]];
            [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            rightBtn.frame = CGRectMake(windowView.width - 30 - 60, leftBtn.top, 60, leftBtn.height);
            rightBtn.layer.masksToBounds = YES;
            rightBtn.layer.cornerRadius = 5;
            [windowView addSubview:rightBtn];
            [rightBtn addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    return _myAleartView;
}

//改变某字符串的颜色并添加下划线
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1683fb"] range:NSMakeRange(location, length)];
        //添加下划线
        NSRange contentRange = {0,[str1 length]};
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        //赋值
        label.attributedText = str1;
        
    }
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
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closetime:)];
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
        [cancel addTarget:self action:@selector(closedatePickertime:) forControlEvents:UIControlEventTouchUpInside];
        [windowView addSubview:cancel];
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(windowView.width/2 +1, line.bottom, (windowView.width - 1)/2, 60)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button addTarget:self action:@selector(suredatePickertime:) forControlEvents:UIControlEventTouchUpInside];
        [windowView addSubview:button];
        
    }
    return _timeView;
}


#pragma mark 弹框的点击事件
//点击弹框左边的请选择---startData
- (void)startlabelTapClick:(UITapGestureRecognizer*)tap
{
    _leftOrRightflag = 0;
    [self startAction];
}
- (void)endTapClick:(UITapGestureRecognizer*)tap
{
    _leftOrRightflag = 1;
    [self startAction];
}
- (void)stutasBtnClick:(UIButton*)sender
{
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :_orderstatusArray :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender index:(NSInteger)index{
    [self rel];
    _orderselectFlag = [NSString stringWithFormat:@"%li",(long)index];
    NSLog(@"点击了那个id%@",_orderstatuIdArray[index]);
    _orderselect = YES;
}
-(void)rel{
    dropDown = nil;
}

- (void)sureBtnClick:(UIButton*)sender
{
    if ([_startlabel.text isEqualToString:@"请选择"]&&[_endLabel.text isEqualToString:@"请选择"]&&[_cashnoTextField.text isEqualToString:@""] && _orderselect == NO) {
        [self showAlert:@"请输入需要筛选的信息"];
    }else{
        _tbView.mj_footer.hidden = YES;
        [self dataRequest1:sender];
    }
    
}

- (void)resetClick:(UIButton*)sender
{
    _startlabel.text = @"请选择";
    _endLabel.text = @"请选择";
    [_stutasBtn setTitle:@"空" forState:UIControlStateNormal];
    _orderselectFlag = @"";
    _cashnoTextField.text = @"";
    
}

- (void)colseBackview:(UITapGestureRecognizer*)tap
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
    _orderselectFlag = @"";
}

- (void)closetime:(UITapGestureRecognizer*)tap
{
    [_timeView removeFromSuperview];
    _timeView = nil;
}

- (void)dateChange:(UIDatePicker*)sender
{
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
    if ( _leftOrRightflag == 0) {
        _startlabel.text = [NSString stringWithFormat:@"%@-%@-%@",_currentDateArray[0],_currentDateArray[1],_currentDateArray[2]];
    }else{
        _endLabel.text = [NSString stringWithFormat:@"%@-%@-%@",_currentDateArray[0],_currentDateArray[1],_currentDateArray[2]];
    }
    
}

- (void)closedatePickertime:(UIButton*)sender
{
    if (self.datePicker) {
        [_timeView removeFromSuperview];
        _timeView = nil;
    }
}

- (void)suredatePickertime:(UIButton*)sender
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
        if (_leftOrRightflag == 0) {
            _startlabel.text = [NSString stringWithFormat:@"%@-%@-%@",_currentDateArray[0],_currentDateArray[1],_currentDateArray[2]];
        }else if (_leftOrRightflag == 1){
            _endLabel.text = [NSString stringWithFormat:@"%@-%@-%@",_currentDateArray[0],_currentDateArray[1],_currentDateArray[2]];
        }
    }
}

    
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }else
    {
        return 0;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyWorterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyWorterTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MoneyWorterTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        searchCashDetailModel* model = _dataArray[indexPath.section];
        cell.dataLabel.text = [NSString stringWithFormat:@"%@",model.createtime];
        model.money = [self convertNull:model.money];
        if ([model.isbudget integerValue] ==0) {
            cell.firstLabel.text = @"未结算";
            cell.secondLabel.text = [NSString stringWithFormat:@"余额变动:-%@",model.money];
            cell.thirdLabel.text = [NSString stringWithFormat:@"单号:%@",model.cashno];
        }else{
            cell.firstLabel.text = @"已结算";
            cell.secondLabel.text = [NSString stringWithFormat:@"余额变动:-%@",model.money];
            cell.thirdLabel.text = [NSString stringWithFormat:@"单号:%@",model.cashno];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)dataRequest
{
    /*
     /cash/pingtaisearchCash.do
     mobile:true
     page
     rows
     flag = 1
     data{
     custidEQ
     typeEQ:6配送端5分销端
     isbudgetEQ//0未结算1结算完成
     }
     */
    [_HUD show:YES];
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cash/pingtaisearchCash.do?1=1"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custidEQ\":\"%@\",\"typeEQ\":\"%@\",\"isbudgetEQ\":\"\"}",userid,typeEQ];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr,@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"flag":@"1"};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_HUD hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/cash/pingtaisearchCash.do%@",str);
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(dict)) {
            NSArray* array = dict[@"rows"];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i <array.count; i++) {
                    searchCashDetailModel* model = [[searchCashDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
        }
        [_tbView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
    }];

}


- (void)dataRequest1:(UIButton*)sender
{
    /*
     /cash/pingtaisearchCash.do
     mobile:true
     page = 1
     rows = 10000000
     flag = 1
     data{
         custidEQ
         cashnoEQ
         typeEQ:6配送端5分销端
         isbudgetEQ//0未结算1结算完成
         createtimeGE开始时间
         createtimeLE结束时间
     }
     */
    [_HUD show:YES];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* startTime;
    if ([_startlabel.text isEqualToString:@"请选择"]||IsEmptyValue(_startlabel.text)) {
        startTime = @"";
    }else{
        startTime = _startlabel.text;
    }
    NSString* endTime;
    if ([_endLabel.text isEqualToString:@"请选择"]||IsEmptyValue(_endLabel.text)) {
        endTime = @"";
    }else{
        endTime = _endLabel.text;
    }
    NSString* isbudgetEQ;
    if (IsEmptyValue(_orderselectFlag)) {
        isbudgetEQ = @"";
    }else{
        isbudgetEQ = _orderstatuIdArray[[_orderselectFlag integerValue]];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cash/pingtaisearchCash.do?1=1"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custidEQ\":\"%@\",\"cashnoEQ\":\"%@\",\"typeEQ\":\"%@\",\"isbudgetEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",userid,_cashnoTextField.text,typeEQ,isbudgetEQ,startTime,endTime];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr,@"page":@"1",@"rows":@"10000000",@"flag":@"1"};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_HUD hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/cash/pingtaisearchCash.do%@",str);
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_dataArray removeAllObjects];
        if (!IsEmptyValue(dict)) {
            NSArray* array = dict[@"rows"];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i <array.count; i++) {
                    searchCashDetailModel* model = [[searchCashDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
        }
        [_tbView reloadData];
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
    }];
}


@end
