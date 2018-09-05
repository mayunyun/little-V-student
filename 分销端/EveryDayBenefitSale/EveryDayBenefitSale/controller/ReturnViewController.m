//
//  ReturnViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ReturnViewController.h"
#import "OrderManageReturnTableViewCell.h"
#import "ReturnDetailViewController.h"
#import "ExiteOrderModel.h"
#import "MBProgressHUD.h"
#import "NIDropDown.h"
#import "LoginViewController.h"
#import "OrderManageExitTableViewCell.h"

@interface ReturnViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NIDropDownDelegate>
{
    MBProgressHUD* _hud;
    UITableView* _tbView;
    NSArray* _currentDateArray;
    UIView* _navBarView;
    UITextField* _searchTextField;
    UIView* _myAleartView;//弹框
    UIView* _timeView;//事件弹框
    NSInteger _leftOrRightflag;//时间选择
    UILabel* _startlabel;
    UILabel* _endLabel;
    NSInteger _page;
    UIView* _reviewAleartView;
    UITableView* _reviewTbView;
    NSArray* _reviewArray;
    
    NSArray* _orderstatusArray;
    NSArray* _orderstatuIdArray;
    NSString* _orderselectFlag;
    NIDropDown *dropDown;
    
}


@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIDatePicker* datePicker;

@end

@implementation ReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
//    self.dataArray = @[@"1",@"2"];
    _reviewArray = @[@"待定",@"通过",@"拒绝"];
    _page = 1;
    _orderstatusArray = @[@"已拒绝",@"待审核",@"审核通过"];
    _orderstatuIdArray = @[@"-1",@"0",@"1"];
    self.title = @"退货管理";
    [self creatNavBarView];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"筛选"];
    [self creatdata];
    [self creatUI];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    _searchTextField.text = @"";
    [self searchExiteOrderRequestData];
}

#pragma mark ---- 原生界面
- (UIView*)creatNavBarView
{
    _navBarView.hidden = NO;
    if (_navBarView==nil) {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth - 90, 40)];
        _navBarView.userInteractionEnabled = YES;
        _navBarView.backgroundColor = [UIColor whiteColor];
        self.navigationItem.titleView = _navBarView;
        
        UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.layer.masksToBounds = YES;
        searchBtn.layer.cornerRadius = 5;
        searchBtn.layer.borderColor = GrayTitleColor.CGColor;
        searchBtn.layer.borderWidth = .5f;
        searchBtn.userInteractionEnabled = YES;
        searchBtn.frame = CGRectMake(0, 0, _navBarView.width - 40, 40);
        searchBtn.backgroundColor = [UIColor whiteColor];
        searchBtn.alpha = 0.5;
        [_navBarView addSubview:searchBtn];
        
        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(5, 0, searchBtn.width - 40, 30)];
        _searchTextField.delegate = self;
        [_searchTextField setPlaceholder:@"  输入订单查找"];
        [searchBtn addSubview:_searchTextField];
        
        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(searchBtn.right+10, 10, 20, 20)];
        searchImgView.userInteractionEnabled = YES;
        searchImgView.image = [UIImage imageNamed:@"icon-search"];
        [_navBarView addSubview:searchImgView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
        [searchImgView addGestureRecognizer:tap];
    }
    return _navBarView;
    
}

- (void)creatUI
{
//    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 60 - 20)/2, 1)];
//    leftline.backgroundColor = LineColor;
//    [self.view addSubview:leftline];
//    UILabel* dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftline.right, 0, 60, 30)];
//    dataLabel.text = _currentDateArray[0];
//    [self.view addSubview:dataLabel];
//    UIView* rightline = [[UIView alloc]initWithFrame:CGRectMake(dataLabel.right, leftline.top, leftline.width, leftline.height)];
//    rightline.backgroundColor = LineColor;
//    [self.view addSubview:rightline];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    _tbView.backgroundColor = BackGorundColor;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = 130;
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    [self setExtraCellLineHidden:_tbView];
    
    
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self searchExiteOrderRequestData];
        _tbView.mj_footer.hidden = NO;
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self searchExiteOrderRequestData];
        [_tbView.mj_footer endRefreshing];
        
    }];
    
    
}

- (UIView*)myaleartView
{
    
    if (!_myAleartView) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        [APPDelegate.window addSubview:_myAleartView];
        
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
        
        CGFloat dataLabelWidth = 60;
        CGFloat reduceWidth = 30;
        CGFloat datagap = (Label1.width - dataLabelWidth*2 - reduceWidth)/2;
        _startlabel  = [[UILabel alloc]initWithFrame:CGRectMake(Label1.left, Label1.bottom+5, dataLabelWidth, 30)];
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
        
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(Label1.left, _startlabel.bottom + 30, Label1.width, Label1.height)];
        label2.font = [UIFont systemFontOfSize:15];
        label2.text = @"订单状态";
        [windowView addSubview:label2];
        
        UIButton* stutasBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        stutasBtn.frame = CGRectMake(label2.left, label2.bottom+5, label2.width, label2.height);
        [stutasBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        [stutasBtn setTitle:@"空" forState:UIControlStateNormal];
        _orderselectFlag = @"";
        stutasBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        stutasBtn.layer.borderWidth = .5;
        stutasBtn.layer.masksToBounds = YES;
        stutasBtn.layer.cornerRadius = 3;
        stutasBtn.layer.borderColor = GrayTitleColor.CGColor;
        [windowView addSubview:stutasBtn];
        [stutasBtn addTarget:self action:@selector(stutasBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* downimg = [[UIImageView alloc]initWithFrame:CGRectMake(stutasBtn.width - 20, 10, 10, 10)];
        downimg.image = [UIImage imageNamed:@"do"];
        [stutasBtn addSubview:downimg];
        
        UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
        [leftBtn setBackgroundColor:NavBarItemColor];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(30, stutasBtn.bottom+30, 60, 30);
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


- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    [self myaleartView];
}

- (void)searchClick:(UITapGestureRecognizer*)tap
{
    
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
}
-(void)rel{
    dropDown = nil;
}


- (void)sureBtnClick:(UIButton*)sender
{
    _tbView.mj_footer.hidden = YES;
    [self searchExiteOrderSelectRequest:sender];
    
}

- (void)resetClick:(UIButton*)sender
{
    _startlabel.text = @"请选择";
    _endLabel.text = @"请选择";
    _orderselectFlag = @"";
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

- (UIView*)reviewAleartView:(NSInteger)index
{
    if (_reviewAleartView == nil) {
        _reviewAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _reviewAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_reviewAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_reviewAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeReviewAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_reviewAleartView.height - 350)/2, _reviewAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_reviewAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _reviewTbView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _reviewTbView.tag = index;
        _reviewTbView.backgroundColor = [UIColor grayColor];
        _reviewTbView.delegate = self;
        _reviewTbView.dataSource = self;
        [windowView addSubview:_reviewTbView];
    }
    return _reviewAleartView;
}
- (void)closeReviewAleartView:(UITapGestureRecognizer*)sender
{
    [_reviewAleartView removeFromSuperview];
    _reviewAleartView = nil;
}
- (void)closeAleartView:(UIButton*)sender
{
    [_reviewAleartView removeFromSuperview];
    _reviewAleartView = nil;
}


#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
//        ReturnDetailViewController* detailVC = [[ReturnDetailViewController alloc]init];
//        detailVC.orderno = textField.text;
//        [self.navigationController pushViewController:detailVC animated:YES];
        [self searchtuihuo:textField.text];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }else if (tableView == _reviewTbView){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if(tableView == _reviewTbView){
        return _reviewArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 10;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)&&_dataArray.count>=indexPath.section) {
            ExiteOrderModel* model = _dataArray[indexPath.section];
            NSArray* prolist = model.prolist;
            return 100+80*prolist.count;
        }else{
            return 100;
        }
    }else{
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString* cellID = @"OrderManageReturnTableViewCellID";
//    OrderManageReturnTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageReturnTableViewCell" owner:self options:nil]firstObject];
//    }
    static NSString* cellID = @"OrderManageExitTableViewCellID";
    OrderManageExitTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageExitTableViewCell" owner:self options:nil]firstObject];
    }
    static NSString* nomalcellID = @"cellID";
    UITableViewCell* nomalcell = [tableView dequeueReusableCellWithIdentifier:nomalcellID];
    if (!nomalcell) {
        nomalcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nomalcellID];
    }
    
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            ExiteOrderModel* model = _dataArray[indexPath.section];
            
            
//            [cell setReasonBtnClick:^(UIButton *sender) {
//                NSString* str = [NSString stringWithFormat:@"%@",model.note];
//                UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"退货原因" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                 target:self
//                                               selector:@selector(timerFireMethod:)
//                                               userInfo:promptAlert
//                                                repeats:YES];
//                [promptAlert show];
//            }];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"%@金币",model.exitmoney];//@"总金额**元";
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"%@元",model.exitmoney];//@"总金额**元";
            }
            model.linkerstatus = [self convertNull:model.linkerstatus];
            if ([model.linkerstatus integerValue] == 0) {
                cell.delBtn.enabled = YES;
                [cell.delBtn setTitle:@"未审核" forState:UIControlStateNormal];
                cell.delBtn.hidden = NO;
                [cell.delBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
            }else if ([model.linkerstatus integerValue] == 1){
//                [cell.delBtn setTitle:@"已审核" forState:UIControlStateNormal];
                cell.delBtn.hidden = YES;
                cell.delBtn.enabled = NO;
            }else if ([model.linkerstatus integerValue] == -1){
//                [cell.delBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                cell.delBtn.hidden = YES;
                cell.delBtn.enabled = NO;
            }
            cell.delBtn.tag = indexPath.section;
//            [cell setTransVaule:^(UIButton *sender) {
//                [self reviewAleartView:sender.tag];
//            }];
            NSString* str;
            NSString* selectStr;
            model.sendstatus = [self convertNull:model.sendstatus];
            switch ([model.sendstatus intValue]) {
                case -1:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.exitecount];
                    selectStr = @"未分配";// | 未分配配送人
                }break;
                case 0:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.exitecount];
                    selectStr = @"等待退货";// | 等待退货
                }
                    break;
                case 1:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.exitecount];
                    selectStr = @"退货完成";// | 退货完成
                }
                    break;
                case 2:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.exitecount];
                    selectStr = @"退货中";// | 退货中
                }break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.addrLabel.text = [NSString stringWithFormat:@"%@",model.exiteaddress];
            cell.senderNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.exiteno];
            cell.prolistArr = model.prolist;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _reviewTbView){
        nomalcell.textLabel.text = _reviewArray[indexPath.row];
        return nomalcell;
    }
    return nomalcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            ExiteOrderModel* model = _dataArray[indexPath.section];
            ReturnDetailViewController* detailVC = [[ReturnDetailViewController alloc]init];
//            model.exiteno = [model.exiteno uppercaseString];
            model.exiteno = [self convertNull:model.exiteno];
            detailVC.orderno = model.exiteno;
            model.sendstatus = [self convertNull:model.sendstatus];
            detailVC.sendstatus = model.sendstatus;
            detailVC.orderdetailModel = model;
            detailVC.Id = model.Id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if (tableView == _reviewTbView){
        [self confirmExiteOrderReuqestData:indexPath.row tag:_reviewTbView.tag];
    }

}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

- (void)creatdata
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter2 =[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd"];
    NSString* yearstr = [dateFormatter stringFromDate:currentDate];
    NSString* monthStr = [dateFormatter1 stringFromDate:currentDate];
    NSString* dataStr = [dateFormatter2 stringFromDate:currentDate];
    _currentDateArray =@[yearstr,monthStr,dataStr];
    
    
    
}

- (void)searchExiteOrderRequestData
{
/*
 /send/searchExiteOrder.do
 mobile:true
 data{
     page 页数
     rows 每页条数
     createtimeGE  传空
     createtimeLE   传空
     linkerid:分销人id
 }
 */
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"%@\",\"rows\":\"20\",\"linkerid\":\"%@\",\"createtimeGE\":\"\",\"createtimeLE\":\"\"}",[NSString stringWithFormat:@"%li",(long)_page],userid];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchExiteOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/searchExiteOrder.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ExiteOrderModel* model = [[ExiteOrderModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
                [_tbView reloadData];
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_hud hide:YES];
    }];
}

- (void)confirmExiteOrderReuqestData:(NSInteger)index tag:(NSInteger)tag
{
/*
 /distribute/confirmExiteOrder.do
 mobile:true
 data{
 linkerstatus审核状态1通过0待定-1拒绝
 exiteno退货单号
 orderno订单号
 }
 */
    NSString* linkerstatus;
    switch (index) {
        case 0:
            linkerstatus = @"0";
            break;
        case 1:
            linkerstatus = @"1";
            break;
        case 2:
            linkerstatus = @"-1";
            break;
        default:
            break;
    }
    NSString* exiteno = @"";
    NSString* orderno = @"";
    if (!IsEmptyValue(_dataArray)) {
        ExiteOrderModel* model = _dataArray[tag];
//        model.exiteno = [model.exiteno uppercaseString];
        exiteno = model.exiteno;
        orderno = model.orderno;
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/distribute/confirmExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"linkerstatus\":\"%@\",\"exiteno\":\"%@\",\"orderno\":\"%@\"}",linkerstatus,exiteno,orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/distribute/confirmExiteOrder.do%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"审核更改成功"];
//            switch ([linkerstatus integerValue]) {
//                case 0:{//待定
//                    
//                }   break;
//                case 1:{//通过
//                    
//                }   break;
//                case -1:{//拒绝
//                
//                }   break;
//                default:
//                    break;
//            }
            if (!IsEmptyValue(_dataArray)) {
                ExiteOrderModel* model = _dataArray[tag];
                //        model.exiteno = [model.exiteno uppercaseString];
                model.linkerstatus = linkerstatus;
                [_tbView reloadData];
            }
        }
        [_reviewAleartView removeFromSuperview];
        _reviewAleartView = nil;
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}

- (void)searchExiteOrderSelectRequest:(UIButton*)sender
{
    /*
     /send/searchExiteOrder.do
     mobile:true
     data{
     page
     rows
     createtimeGE   开始时间
     createtimeLE   结束时间
     linkerstatus   //审核状态0未审核1已审核-1拒绝
     linkerid:分销人id
     }
     */
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    sender.enabled = NO;
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
    NSString* orderstatus;
    if (IsEmptyValue(_orderselectFlag)) {
        orderstatus = @"";
    }else{
        orderstatus = _orderstatuIdArray[[_orderselectFlag integerValue]];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"1\",\"rows\":\"1000\",\"linkerid\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"linkerstatus\":\"%@\"}",userid,startTime,endTime,orderstatus];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        sender.enabled = YES;
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchExiteOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/searchExiteOrder.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ExiteOrderModel* model = [[ExiteOrderModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
            [_tbView reloadData];
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;

        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_hud hide:YES];
        sender.enabled = YES;
    }];

}

- (void)searchtuihuo:(NSString*)text
{
    /*
     /send/searchExiteOrder.do
     mobile:true
     data{
     page 页数
     rows 每页条数
     exiteno
     linkerid 分销人
     }
     */
    [_hud show:YES];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"1\",\"rows\":\"1\",\"exiteno\":\"%@\",\"linkerid\":\"%@\"}",text,userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchExiteOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/searchExiteOrder.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"list"];
            [_dataArray removeAllObjects];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ExiteOrderModel* model = [[ExiteOrderModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
            [_tbView reloadData];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_hud hide:YES];
    }];
}




@end
