//
//  ReturnViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ReturnViewController.h"
#import "OrderManageTableViewCell.h"
#import "ReturnDetailViewController.h"
#import "MBProgressHUD.h"
#import "ExiteOrderModel.h"
#import "LoginViewController.h"
#import "OrderManageExitTableViewCell.h"

@interface ReturnViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tbView;
    NSArray* _currentDateArray;
    UIView* _navBarView;
    UITextField* _searchTextField;
    
    UIView* _myAleartView;
    UITableView* _aleartTbView;
    NSString* _SelectReturnType;
    BOOL _changeRightBarSelect;
    
    NSInteger _page;
    MBProgressHUD* _hud;
}


@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIDatePicker* datePicker;

@end

@implementation ReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
//    self.dataArray = @[@"1",@"2"];
    _page = 1;
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
    [super viewWillAppear:animated];
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
        
        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(5, 0, searchBtn.width- 30 - 40, 30)];
        _searchTextField.delegate = self;
        [_searchTextField setPlaceholder:@"  搜索订单号"];
        [searchBtn addSubview:_searchTextField];
        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(searchBtn.right+15, 10, 20, 20)];
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
    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 60 - 20)/2, 1)];
    leftline.backgroundColor = LineColor;
    [self.view addSubview:leftline];
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
        _tbView.mj_footer.hidden = NO;
        [self searchExiteOrderRequestData];
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
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(mScreenWidth - 80, 0, 80, 135)];
        _myAleartView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_myAleartView];
        _aleartTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        [_aleartTbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        _aleartTbView.delegate = self;
        _aleartTbView.dataSource = self;
        _aleartTbView.bounces = NO;
        [_myAleartView addSubview:_aleartTbView];
        
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





- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    _changeRightBarSelect = !_changeRightBarSelect;
    if (_changeRightBarSelect) {
        [self myaleartView];
    }else{
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }
}

- (void)searchClick:(UITapGestureRecognizer*)tap
{
    
}

#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
//        ReturnDetailViewController* detailVC = [[ReturnDetailViewController alloc]init];
//        detailVC.exiteno = textField.text;
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
    }else if(tableView == _aleartTbView){
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if(tableView == _aleartTbView){
        return 3;
    }else{
        return 0;
    }
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
//    static NSString* cellID = @"OrderManageTableViewCellID";
//    OrderManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageTableViewCell" owner:self options:nil]firstObject];
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
    }else
    {
        NSArray* array = @[@"待退货",@"退货中",@"已完成"];
        nomalcell.textLabel.text = array[indexPath.row];
        nomalcell.textLabel.font = [UIFont systemFontOfSize:13];
        return nomalcell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            ExiteOrderModel* model = _dataArray[indexPath.section];
            ReturnDetailViewController* detailVC = [[ReturnDetailViewController alloc]init];
//            model.exiteno = [model.exiteno uppercaseString];
            model.exiteno = [self convertNull:model.exiteno];
//            detailVC.exiteno = model.exiteno;
            detailVC.orderdetailModel = model;
            detailVC.Id = model.Id;
            detailVC.sendstatus = model.sendstatus;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if(tableView == _aleartTbView){
        switch (indexPath.row) {
            case 0:{
                _SelectReturnType = @"0";
                _tbView.mj_footer.hidden = YES;
                [self searchExiteOrderSelectRequest];
            }
                break;
            case 1:{
                _SelectReturnType = @"2";
                _tbView.mj_footer.hidden = YES;
                [self searchExiteOrderSelectRequest];
            }
                break;
            case 2:{
                _SelectReturnType = @"1";
                _tbView.mj_footer.hidden = YES;
                [self searchExiteOrderSelectRequest];
            }
                break;
                
            default:
                break;
        }
        _changeRightBarSelect = !_changeRightBarSelect;
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }
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
     page
     rows
     sendlinkerid:配送人id
     sendstatus默认传空 0未配送1配送完成2配送中
     }
     */
    [_hud show:YES];
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"%@\",\"rows\":\"20\",\"sendlinkerid\":\"%@\",\"sendstatus\":\"\"}",[NSString stringWithFormat:@"%li",(long)_page],userid];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(id result) {
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
    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
    }];
}


- (void)searchExiteOrderSelectRequest
{
    /*
     /send/searchExiteOrder.do
     mobile:true
     data{
     page
     rows
     sendstatus
     sendlinkerid:配送人id
     }
     */
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }

    NSString* orderstatus;
    if (IsEmptyValue(_SelectReturnType)) {
        orderstatus = @"";
    }else{
        orderstatus = _SelectReturnType;
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"1\",\"rows\":\"1000000\",\"sendlinkerid\":\"%@\",\"sendstatus\":\"%@\"}",userid,orderstatus];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(id result) {
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
    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
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
     sendlinkerid配送人id
     }
     */
    [_hud show:YES];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"1\",\"rows\":\"1\",\"exiteno\":\"%@\",\"sendlinkerid\":\"%@\"}",text,userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
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
    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
    }];
}





@end
