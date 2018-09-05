//
//  OrderViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderManageTableViewCell.h"
#import "OrderDetailReceiveViewController.h"
#import "MBProgressHUD.h"
#import "OrderManageListModel.h"
#import "LoginViewController.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tbView;
    NSArray* _currentDateArray;
    UIView* _navBarView;
    UITextField* _searchTextField;
    
    UIView* _myAleartView;
    UITableView* _aleartTbView;
    NSString* _SelectSendType;
    BOOL _changeRightBarSelect;
    
    MBProgressHUD* _hud;
    NSInteger _page;
    
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIDatePicker* datePicker;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    _page = 1;
//    self.dataArray = @[@"1",@"2"];
    self.title = @"订单管理";
    [self creatNavBarView];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"全部订单"];
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
    [self searchOrderDataRequest];
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
        searchBtn.frame = CGRectMake(0, 0, _navBarView.width, 40);
        searchBtn.backgroundColor = [UIColor whiteColor];
        searchBtn.alpha = 0.5;
        [_navBarView addSubview:searchBtn];
        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        searchImgView.userInteractionEnabled = YES;
        searchImgView.image = [UIImage imageNamed:@"icon-search"];
        [searchBtn addSubview:searchImgView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
        [searchImgView addGestureRecognizer:tap];

        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
        _searchTextField.delegate = self;
        [_searchTextField setPlaceholder:@"  搜索订单号"];
        [searchBtn addSubview:_searchTextField];
    }
    return _navBarView;
}

- (void)creatUI
{
    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 60 - 20)/2, 1)];
    leftline.backgroundColor = LineColor;
    [self.view addSubview:leftline];
    UILabel* dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftline.right, 0, 60, 30)];
    dataLabel.text = _currentDateArray[0];
    [self.view addSubview:dataLabel];
    UIView* rightline = [[UIView alloc]initWithFrame:CGRectMake(dataLabel.right, leftline.top, leftline.width, leftline.height)];
    rightline.backgroundColor = LineColor;
    [self.view addSubview:rightline];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(10, 30, mScreenWidth - 20, mScreenHeight - 64 - 30 - 44)];
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
        [self searchOrderDataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self searchOrderDataRequest];
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
    _changeRightBarSelect = !_changeRightBarSelect;//因为默认情况下为假，所以如果条件是先转换，那么就转换成真了。
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
        [self SearchTextOrderRequest:textField.text];
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"OrderManageTableViewCellID";
    OrderManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageTableViewCell" owner:self options:nil]firstObject];
    }
    static NSString* nomalcellID = @"cellID";
    UITableViewCell * nomalCell = [tableView dequeueReusableCellWithIdentifier:nomalcellID];
    if (!nomalCell) {
        nomalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nomalcellID];
    }
    if (tableView == _tbView) {
//        cell.titleLabel.text = _dataArray[indexPath.section];
//        cell.dayLabel.text = _currentDateArray[2];
//        cell.monthLabel.text = [NSString stringWithFormat:@"%@月",_currentDateArray[1]];
//        cell.titleLabel.text = @"总金额**元";
//        cell.countLabel.text = @"共1件商品 | 等待付款";
//        cell.statusLabel.text = @"立即付款";
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
        if (!IsEmptyValue(_dataArray)) {
            OrderManageListModel* model = _dataArray[indexPath.section];
//            model.orderno = [model.orderno uppercaseString];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            //        cell.dayLabel.text = _currentDateArray[2];
            //        cell.monthLabel.text = [NSString stringWithFormat:@"%@月",_currentDateArray[1]];
            //        cell.titleLabel.text = @"总金额**元";
            //        cell.countLabel.text = @"共1件商品 | 等待付款";
            //        cell.statusLabel.text = @"立即付款";
            
            NSArray* dateArr = [self separateDateStr:model.createtime];
            cell.dayLabel.text = dateArr[2];
            cell.monthLabel.text = [NSString stringWithFormat:@"%@月",dateArr[1]];
            if ([model.isgolds integerValue] == 1) {
                cell.titleLabel.text = [NSString stringWithFormat:@"总金额%@金币",model.ordermoney];//@"总金额**元";
            }else{
                cell.titleLabel.text = [NSString stringWithFormat:@"总金额%@元",model.ordermoney];//@"总金额**元";
            }

            NSString* str;
            NSString* selectStr;
            switch ([model.sendstatus intValue]) {
                case 0:
                    str = [NSString stringWithFormat:@"共%@件商品 | 等待配送",model.ordercount];
                    selectStr = @"立即配送";
                    break;
                case 1:
                    str = [NSString stringWithFormat:@"共%@件商品 | 配送中",model.ordercount];
                    selectStr = @"配送中";
                    break;
                case 2:
                    str = [NSString stringWithFormat:@"共%@件商品 | 已完成",model.ordercount];
                    selectStr = @"已完成";
                    break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSArray* array = @[@"待配送",@"配送中",@"已完成"];
        nomalCell.textLabel.font = [UIFont systemFontOfSize:13];
        nomalCell.textLabel.text = array[indexPath.row];
        return nomalCell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            OrderManageListModel* model = _dataArray[indexPath.section];
            OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
            detailVC.orderNo = model.orderno;
            detailVC.sendstatus = model.sendstatus;
            if (!IsEmptyValue(model.online1)) {
                if ([model.online1 integerValue] == 0) {
                    detailVC.upline = @"1";
                }
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else{
        _tbView.mj_footer.hidden = YES;
        switch (indexPath.row) {
            case 0:{
            //待配送
                _SelectSendType = @"0";
                
                [self searchOrderRequest];
            }
                break;
            case 1:{
            //配送中
                _SelectSendType = @"1";
                
                [self searchOrderRequest];
            }
                break;
            case 2:{
            //已完成
                _SelectSendType = @"2";
                 [self searchOrderRequest];
                
            }
                break;
            default:        break;
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


- (void)searchOrderDataRequest
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     senderid
     sendstatus:默认传空
     page
     rows
     }
     */
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"senderid\":\"%@\",\"sendstatus\":\"\",\"page\":\"%@\",\"rows\":\"20\"}",userid,[NSString stringWithFormat:@"%li",(long)_page]];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
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

- (void)searchOrderRequest
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     senderid
     sendstatus 0等待配送1配送中2配送完成
     page 1
     rows 10000000
     }
     */
    [_dataArray removeAllObjects];
    
    NSString* orderstatus;
    if (IsEmptyValue(_SelectSendType)) {
        orderstatus = @"";
    }else{
        orderstatus = _SelectSendType;
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"senderid\":\"%@\",\"sendstatus\":\"%@\",\"page\":\"1\",\"rows\":\"10000000\"}",userid,orderstatus];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
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

- (void)SearchTextOrderRequest:(NSString*)orderno
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     page:1
     rows:1
     }
     */
    [_hud show:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\",\"page\":\"1\",\"rows\":\"1\"}",orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderDetail.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/order/searchOrderDetail.do%@",array);
            if (array.count!=0) {
                OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
                detailVC.orderNo = [NSString stringWithFormat:@"%@",orderno];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
    }];
}





@end
