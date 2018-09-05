//
//  OrderDetailWaitViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailWaitViewController.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
#import "OrderDetailTableView.h"
#import "OrderDetailProTbViewModel.h"
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "PayTypeTbVC.h"
#import "XMLDictionary.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

#import "OrderManageViewController.h"

@interface OrderDetailWaitViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIView* _orderView;
    UILabel* _orderNoLabel;
    UITableView* _tbView;
    NSMutableArray* _dataArray;
    NSMutableArray* _proDataArray;
    NSString* _ordermoneyPay;
    NSString* _ordernoPay;
}
//@property (nonatomic,strong)NSMutableArray* dataWaitArray;
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,strong)NSMutableArray* getCustInfoAddrArray;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;



@end

@implementation OrderDetailWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    _getCustInfoAddrArray = [[NSMutableArray alloc]init];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
//    _dataWaitArray = @[@"1",@"2"];
    [self tbViewcellDataRequest];
    [self SearchOrderRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPersonContent];
}

- (void)creatUI
{
    _orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 44)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderView];
    _orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mScreenWidth - 20 - 60, _orderView.height)];
    _orderNoLabel.text = @"订单号:";
    _orderNoLabel.numberOfLines = 0;
    _orderNoLabel.adjustsFontSizeToFitWidth = YES;
    [_orderView addSubview:_orderNoLabel];
    UILabel* orderSignLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNoLabel.right, 0, 60, _orderView.height)];
    orderSignLabel.text = @"等待付款";
    orderSignLabel.textColor = NavBarItemColor;
    orderSignLabel.font = [UIFont systemFontOfSize:13];
    [_orderView addSubview:orderSignLabel];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _orderView.bottom, mScreenWidth, mScreenHeight - _orderView.height - 49)];

    [_tbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.showsVerticalScrollIndicator = YES;
    _tbView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_tbView];
    
    if (self.typeOrder == typeOrderCancel) {
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49 - 64, mScreenWidth, 49)];
        footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footerView];
        UIButton* footBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        footBtn.frame = CGRectMake(footerView.right - 90, 10, 70, 30) ;
        [footBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [footBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
        footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        footBtn.layer.masksToBounds = YES;
        footBtn.layer.cornerRadius = 5.0;
        CALayer *layer = [footBtn layer];
        layer.borderColor = NavBarItemColor.CGColor;
        layer.borderWidth = .5f;
        [footerView addSubview:footBtn];
        [footBtn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        footerView.backgroundColor = BackGorundColor;
        UIButton* delectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        delectBtn.frame = CGRectMake(10, 10, 80, 30);
        [delectBtn setBackgroundColor:[UIColor clearColor]];
        [delectBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        delectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [delectBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
        [footerView addSubview:delectBtn];
        delectBtn.layer.masksToBounds = YES;
        delectBtn.layer.cornerRadius = 5.0;
        delectBtn.layer.borderColor = NavBarItemColor.CGColor;
        delectBtn.layer.borderWidth = .5f;
        [delectBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }else if (self.typeOrder == typeOrderDel){
        
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49 - 64, mScreenWidth, 49)];
        footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footerView];
        
        footerView.backgroundColor = BackGorundColor;
        UIButton* delectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        delectBtn.frame = CGRectMake(10, 10, 80, 30);
        [delectBtn setBackgroundColor:[UIColor clearColor]];
        [delectBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        delectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [delectBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
        [footerView addSubview:delectBtn];
        delectBtn.layer.masksToBounds = YES;
        delectBtn.layer.cornerRadius = 5.0;
        delectBtn.layer.borderColor = NavBarItemColor.CGColor;
        delectBtn.layer.borderWidth = .5f;
        [delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray* array = self.navigationController.viewControllers;
    if ([array[array.count - 1] isKindOfClass:[OrderManageViewController class]]) {
        if (_transVaule) {
            _transVaule(self.orderStatusFlag);
        }
    }
}


- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 2) {
        return 0;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
        case 1:
            if (IsEmptyValue(_dataArray)) {
                return 0;
            }else{
                return 100*_dataArray.count;
            }
            break;
        case 2:
//            return 110;
            break;
        case 3:
//            return 90;
            break;
        case 4:
            return 100;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    OrderDetailNameTableViewCell* nameCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailNameTableViewCellID"];
    if (!nameCell) {
        nameCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailNameTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailPayTypeTableViewCell* payCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailPayTypeTableViewCellID"];
    if (!payCell) {
        payCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailPayTypeTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailBillTableViewCell* billCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailBillTableViewCellID"];
    if (!billCell) {
        billCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailBillTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailPriceTableViewCell* priceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailPriceTableViewCellID"];
    if (!priceCell) {
        priceCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailPriceTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (indexPath.section == 0) {

        nameCell.selectBtn.hidden = YES;
        
        nameCell.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",_orderdetailModel.custname];
        nameCell.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",_orderdetailModel.custphone];
        nameCell.addressLabel.text = [NSString stringWithFormat:@"地址：%@",_orderdetailModel.receiveraddr];
        if ([_orderdetailModel.pickupway integerValue] == 1) {
            [nameCell.pickUpWayBtn setTitle:@"自取" forState:UIControlStateNormal];
        }else{
            [nameCell.pickUpWayBtn setTitle:@"配送" forState:UIControlStateNormal];
        }
        nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return nameCell;
    }else if (indexPath.section == 1) {

        if (!IsEmptyValue(_dataArray)) {
            cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count);
            OrderDetailTableView *view = [[OrderDetailTableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count)];
            view.backgroundColor = [UIColor redColor];
            view.dataArray = _proDataArray;
            [cell.contentView addSubview:view];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
        
    }else if (indexPath.section == 2){

        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return payCell;
    }else if (indexPath.section == 3){
        
        //        billCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        return billCell;
    }else{
        if (!IsEmptyValue(_orderdetailModel.ordermoney)) {
            priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"钱数：%.2f",[_orderdetailModel.ordermoney floatValue]];
            _orderdetailModel.createtime = [self convertNull:_orderdetailModel.createtime];
            priceCell.orderDataLabel.text = [NSString stringWithFormat:@"下单时间：%@",[Command sendtimeChangeData:_orderdetailModel.createtime]];
        }
        priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return priceCell;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            [self payGoldsOrderRequestData];
        }
    }
}

- (void)selectAddBtnClick:(UIButton *)sender
{
    NSLog(@"==点击了地址选择按钮==");
}

- (void)footBtnClick:(UIButton*)sender
{
    //添加订单
    if (_getCustInfoAddrArray.count == 0) {
        [self showAlert:@"默认地址没取到"];
    }else{
        _ordermoneyPay = [NSString stringWithFormat:@"%@",_orderdetailModel.ordermoney];
        _ordernoPay = [NSString stringWithFormat:@"%@",_orderdetailModel.orderno];
        NSString* name = [NSString stringWithFormat:@"%@",_orderdetailModel.proname];
        if ([_orderdetailModel.isgolds integerValue] == 1) {
            
            UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您持有的金币数%@",_custInfoModel.golds] message:[NSString stringWithFormat:@"应支付的金币数%@",_orderdetailModel.ordermoney] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            aleartView.tag = 1001;
            [aleartView show];
        }else{
            PayTypeTbVC* vc = [[PayTypeTbVC alloc]init];
            vc.orderMoney1 = _ordermoneyPay;
            vc.orderno1 = _ordernoPay;
            vc.ordernewUUid = [NSString stringWithFormat:@"%@",_orderdetailModel.uniqueidentiteny];
            vc.name = [NSString stringWithFormat:@"%@",name];
            vc.mssage1 = [NSString stringWithFormat:@"%@",_ordernoPay];//@"测试";
            vc.time = [NSString stringWithFormat:@"%@",_orderdetailModel.createtime];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)delectBtnClick:(UIButton*)sender
{
    if (IsEmptyValue(_orderdetailModel.orderno)) {
        [self showAlert:@"订单号未取到"];
    }else if([_orderdetailModel.orderstatus integerValue] != -1){
        [self showAlert:@"关闭的订单才能删除"];
    }else{
        [self delOrderRequestData:sender];
    }
}

- (void)cancelBtnClick:(UIButton*)sender
{
    if (IsEmptyValue(_orderdetailModel.orderno)) {
        [self showAlert:@"订单信息待获取"];
    }else{
        [self cancelOrderRequestData:sender];
    }

}


- (void)tbViewcellDataRequest
{
    for (int i =0; i < _dataArray.count; i++) {
        OrderManageListModel* promodel = _dataArray[i];
        OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
        model.picname = promodel.picname;
        model.proname = promodel.proname;
        model.price = promodel.saleprice;
        model.folder = promodel.folder;
        model.isgolds = promodel.isgolds;
        model.count = [NSString stringWithFormat:@"%@",promodel.count];
        [_proDataArray addObject:model];
        [_tbView reloadData];
    }
}


#pragma mark - 获得用户个人信息
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
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
//            [self showAlert:@"未登录,请先登录!"];
            LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
            //            [self presentViewController:relogVC animated:YES completion:nil];
            [self.navigationController pushViewController:relogVC animated:NO];
            
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"个人信息数据%@",array);
            
            NSDictionary* dict = array[0];
            _custInfoModel = [[GetCustInfoModel alloc]init];
            [_custInfoModel setValuesForKeysWithDictionary:dict];
            [_getCustInfoAddrArray removeAllObjects];
            NSArray* addArray = array[1][@"addrlist"];
            for (int i =0; i < addArray.count; i++) {
                GetCustInfoAddressModel* addressModel = [[GetCustInfoAddressModel alloc]init];
                [addressModel setValuesForKeysWithDictionary:addArray[i]];
                [_getCustInfoAddrArray addObject:addressModel];
            }
            [_tbView reloadData];
            
        }
        //        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
    }];
    
}


- (void)SearchOrderRequest
{
/*
 /order/searchOrderDetail.do
 mobile:true
 data{
     orderno:订单编号
 }
 */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderNo];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderDetail.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/order/searchOrderDetail.do%@",array);
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    _orderdetailModel = [[OrderManageListModel alloc]init];
                    [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:_orderdetailModel];
                }
                _orderNoLabel.text = [NSString stringWithFormat:@"订单号:%@",_orderdetailModel.orderno];
//                [self searchPayIdRequest:_orderdetailModel.orderno];
                [self tbViewcellDataRequest];
                [_tbView reloadData];
            }
        }
    } fail:^(NSError *error) {
    }];
}


- (void)cancelOrderRequestData:(UIButton*)sender
{
    /*
     /send/cancelOrder.do
     mobile:true
     data{
     orderno
     }
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/cancelOrder.do"];
//    _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",_orderdetailModel.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/cancelOrder.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"取消订单成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"取消订单失败"];
        }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        
    }];
    
}



- (void)delOrderRequestData:(UIButton*)sender
{
    /*
     传的时候要判断订单状态是-1
     /send/delOrder.do
     mobile:true
     data{
     orderno:订单号
     }
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/delOrder.do"];
//    _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",_orderdetailModel.orderno];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"delOrder.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"删除订单成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"删除订单不成功"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        
    }];
    
}

#pragma mark 金币商城商品确认支付
- (void)payGoldsOrderRequestData
{
    /*
     /golds/payGoldsOrder.do
     mobile:true
     data{
     ordermoney购买商品所需要的金币数量，custid客户登陆id，orderno订单号
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/golds/payGoldsOrder.do"];
    NSString* useridstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    useridstr = [self convertNull:useridstr];
    
    NSString* datastr = [NSString stringWithFormat:@"{\"ordermoney\":\"%@\",\"custid\":\"%@\",\"orderno\":\"%@\"}",_ordermoneyPay,useridstr,_ordernoPay];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/golds/payGoldsOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/golds/payGoldsOrder.do登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"支付成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"支付失败"];
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        
    }];
    
}


//查询名单号

- (void)searchPayIdRequest:(NSString*)orderno
{
    //    https://api.mch.weixin.qq.com/pay/unifiedorder
    /*
     appid      应用ID：wxd678efh567hg6787
     mch_id     商户号：1230000109
     nonce_str  随机字符串：5K8264ILTKCH16CQ2502SI8ZNMTM67VS
     sign       签名：C380BEC2BFD727A4B6845133519F3AD6
     out_trade_no商户订单号
     */
    NSString* appid = WXPay_APPID;
    NSString* mch_id = WXPay_mch_id;
    NSString* nonce_str = [self ret32bitString];// @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";//;//
    NSLog(@"随机字符串生成%@",nonce_str);
    NSString* out_trade_no = orderno;
    NSArray* parmaArray = @[appid,mch_id,nonce_str,out_trade_no];
    NSString* sign = [self creatsearchsign:parmaArray];//@"C380BEC2BFD727A4B6845133519F3AD6";
    NSLog(@"sign = %@",sign);
    NSString *urlStr = @"https://api.mch.weixin.qq.com/pay/orderquery";
    NSString *xmlstr = [NSString stringWithFormat:@"<xml><appid>%@</appid><mch_id>%@</mch_id><nonce_str>%@</nonce_str><out_trade_no>%@</out_trade_no><sign>%@</sign></xml>",appid,mch_id,nonce_str,out_trade_no,sign];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //
    NSData *data = [xmlstr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"查询returnStr%@",returnStr);
    NSDictionary *dict = [NSDictionary dictionaryWithXMLString:returnStr];
    NSLog(@"test = %@",dict);
    NSLog(@"return_code:%@,return_msg:%@",[dict objectForKey:@"return_code"],[dict objectForKey:@"return_msg"]);
    if ([[dict objectForKey:@"return_code"]isEqualToString:@"SUCCESS"]) {
        //预处理成功
        if ([[dict objectForKey:@"result_code"]isEqualToString:@"SUCCESS"]) {
            double money = [[dict objectForKey:@"total_fee"] intValue]*0.01;
            if ([[dict objectForKey:@"trade_state"] isEqualToString:@"SUCCESS"]) {
                [self shangChuan:orderno money:[NSString stringWithFormat:@"%.2f",money]];
            }
        }
    }else{
    }
}

- (NSString*)creatsearchsign:(NSArray*)pramaArr
{
#pragma mark - - - - - - 预支付签名
    //    NSString* signstr = @"appid=wx956f59da3ba662b6&body=测试&mch_id=1230000109&nonce_str=5K8264ILTKCH16CQ2502SI8ZNMTM67VS&notify_url=http://182.92.96.58:8004/qitao/getNotifyAction&out_trade_no=11112222&spbill_create_ip=14.23.150.211&total_fee=1&trade_type=APP&key=192006250b4c09247ec02edce69f6a2d"
    //appid,mch_id,nonce_str,out_trade_no;
    NSString* signstr = [NSString stringWithFormat:@"appid=%@&mch_id=%@&nonce_str=%@&out_trade_no=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],WXPay_key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[self md5:signstr] uppercaseString];
}

- (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma  mark 支付成功后订单传给后台。
- (void)shangChuan:(NSString*)orderno money:(NSString*)money
{
    /*
     /order/payOrder.do
     mobile:true
     data{
     orderno    //订单号
     payno      //交易单号 空
     custid     //用户id
     paymethod  //1支付宝0微信
     money
     }
     */
//    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
//    userid = [self convertNull:userid];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/payOrder.do?1=1"];
//    NSDictionary *params = @{@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\",\"payno\":\"\",\"custid\":\"%@\",\"paymethod\":\"0\",\"money\":\"%@\"}",orderno,userid,money]};
//    NSLog(@"上传的url%@,上传参数%@",urlStr,params);
//    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
//        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"/order/payOrder.do%@",str);
//        if ([str rangeOfString:@"true"].location != NSNotFound) {
//            NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
//            UIViewController *viewCtl = self.navigationController.viewControllers[1];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            NSLog(@"updateOrderType%@",array);
////            [self showAlert:@"支付成功"];
//        }else{
//            //            [self showAlert:@"更新支付状态失败"];
//        }
//    } failureBlock:^(AFHTTPRequestOperationManager *operationdata
//                     , NSError *error) {
//        NSInteger errorCode = error.code;
//        NSLog(@"错误信息%ld%@",(long)errorCode,error);
//        
//    }];
    
}



@end
