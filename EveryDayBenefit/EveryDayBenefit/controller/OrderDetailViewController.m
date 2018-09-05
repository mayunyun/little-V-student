//
//  OrderDetailViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableView.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "LoginNewViewController.h"
#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
#import "OrderDetailProTbViewModel.h"
#import "BuyCarModel.h"
#import "AddressManageModel.h"
#import "CommonModel.h"
#import "PayTypeTbVC.h"//收银台
#import "MBProgressHUD.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIAlertViewDelegate>
{
    UIView* _orderView;
    UILabel* _orderNoLabel;
    UITableView* _tbView;
    NSMutableArray* _payCarArray;
    
    //选择收货地址弹框
    UIView* _myAleartView;
    NSMutableArray* _fxCustdataArray;
    NSMutableArray* _addVillArray;
    NSArray* _pickUpwayArray;
    NSInteger _selectaddressFlag;
    NSString* _selectpickupwayFlag;
    
    NSString* _ordermoneyPay;
    NSString* _ordernoPay;
    NSString* _ordernouuid;
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSMutableArray* dataWaitArray;
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,strong)NSMutableArray* getCustInfoAddrArray;
@property (nonatomic,strong)UITableView* fxCustTableView;
@property (nonatomic,strong)UITableView* pickupWayTableView;
@property (nonatomic,strong)UITableView* addVillTableView;
@property (nonatomic,retain)GetCustInfoAddressModel* selectaddressModel;
@property (nonatomic,retain)GetCustInfoAddressModel* pickaddressmodel;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _dataWaitArray = [[NSMutableArray alloc]init];
    _getCustInfoAddrArray = [[NSMutableArray alloc]init];
    _payCarArray = [[NSMutableArray alloc]init];
    _fxCustdataArray = [[NSMutableArray alloc]init];
    _addVillArray = [[NSMutableArray alloc]init];
    _selectaddressModel = [[GetCustInfoAddressModel alloc]init];
    _pickUpwayArray = @[@"配送",@"自取"];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    [self tbViewcellDataRequest];
    if (self.typeOrder == typeOrderpayCar) {
        if (!IsEmptyValue(self.dataIdArray)) {
            [self updataCarContent];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPersonContent];
}

- (void)creatUI
{
    self.view.backgroundColor = BackGorundColor;
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 49)];
    [_tbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.showsVerticalScrollIndicator = YES;
    _tbView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_tbView];
    [self setExtraCellLineHidden:_tbView];
    
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


}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        return 5;
    }else if (tableView == _fxCustTableView){
        return 1;
    }else if (tableView == _pickupWayTableView){
        return 1;
    }else if (tableView == _addVillTableView){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if (tableView == _fxCustTableView){
        if (!IsEmptyValue(_fxCustdataArray)) {
            return _fxCustdataArray.count;
        }
    }else if (tableView == _pickupWayTableView){
        return _pickUpwayArray.count;
    }else if (tableView == _addVillTableView){
        return _addVillArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        if (section == 3 || section == 2) {
            return 0;
        }else{
            return 10;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        switch (indexPath.section) {
            case 0:
                return 80;
                break;
            case 1:
                if (self.typeOrder == typeOrderAddress) {
                    if (IsEmptyValue(_dataArray)) {
                        return 0;
                    }else{
                        return 100*_dataArray.count;
                    }
                    
                }else{
                    if (IsEmptyValue(_dataWaitArray)) {
                        return 0;
                    }else{
                        return 100*_dataWaitArray.count;
                    }
                }
                break;
            case 2:
//                return 110;
                return 0;
                break;
            case 3:
//                return 90;
                return 0;//发票
                break;
            case 4:
                return 100;
                break;
            default:
                return 0;
                break;
        }

    }else{
        return 44;
    }
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
    if (tableView == _tbView) {
        if (indexPath.section == 0) {
//            if (self.typeOrder == typeOrderAddress) {
//                nameCell.selectBtn.hidden = NO;
//            }else{
//                nameCell.selectBtn.hidden = YES;
//            }
            nameCell.delegate = self;
            nameCell.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",_custInfoModel.name];
            nameCell.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",_custInfoModel.phone];
            
//            nameCell.pickUpWayBtn.hidden = YES;
            if (self.typeOrder == typeOrderAddress) {
                if ([_nowProdetailModel.pickupway integerValue] == 0) {
                    [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[0] forState:UIControlStateNormal];
                    //配送
                    [self creatNewAddrModel];
                    [self nameCelladdressLabelEmptyDeal];
                    nameCell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.comunity,_selectaddressModel.roomnumber,_selectaddressModel.address];
                    
                }else if ([_nowProdetailModel.pickupway integerValue] == 1){
                    [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[1] forState:UIControlStateNormal];
                    if (_selectaddressFlag != 1) {
                        _selectaddressModel = _pickaddressmodel;
                    }
                    [self nameCelladdressLabelEmptyDeal];
                     nameCell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@(%@)",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.phone];
                }
            }else if (self.typeOrder == typeOrderpayCar){
                if (!IsEmptyValue(_payCarArray)) {
                    NSInteger count = 0;
                    for (BuyCarModel* model in _payCarArray) {
                        if ([model.pickupway integerValue] == 1) {
                            count++;
                        }
                    }
                    if (_payCarArray.count == count) {
                        //自取
                        [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[1] forState:UIControlStateNormal];
                        if (_selectaddressFlag != 1) {
                            _selectaddressModel = _pickaddressmodel;
                        }
                        [self nameCelladdressLabelEmptyDeal];
                        nameCell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@(%@)",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.phone];
                    }else if(count == 0){
                        //配送
                        [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[0] forState:UIControlStateNormal];
                        [self creatNewAddrModel];
                        [self nameCelladdressLabelEmptyDeal];
                        nameCell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.comunity,_selectaddressModel.roomnumber,_selectaddressModel.address];
                    }else{
                        [self showAlert:@"配送和自取不能同时结算"];
                    }
                    
                }
            }
            nameCell.pickUpWayBtn.enabled = NO;
//            if (!IsEmptyValue(_selectpickupwayFlag)) {
//                if ([_selectpickupwayFlag integerValue] == 1) {
//                    [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[1] forState:UIControlStateNormal];
//                }else if([_selectpickupwayFlag integerValue] == 0){
//                    [nameCell.pickUpWayBtn setTitle:_pickUpwayArray[0] forState:UIControlStateNormal];
//                }
//            }
            nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nameCell;
        }else if (indexPath.section == 1) {
            if (self.typeOrder == typeOrderAddress) {
                if (!IsEmptyValue(_dataArray)) {
                    cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count);
                    OrderDetailTableView *view = [[OrderDetailTableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count)];
                    view.backgroundColor = [UIColor redColor];
                    view.dataArray = _dataArray;
                    [cell.contentView addSubview:view];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                if (!IsEmptyValue(_dataWaitArray)) {
                    cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 100*_dataWaitArray.count);
                    OrderDetailTableView *view = [[OrderDetailTableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100*_dataWaitArray.count)];
                    view.backgroundColor = [UIColor redColor];
                    view.dataArray = _dataWaitArray;
                    [cell.contentView addSubview:view];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if (indexPath.section == 2){
            //支付方式
            //        if (self.typeOrder == typeOrderAddress) {
            //
            //
            //        }else {
            //
            //        }
            payCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return payCell;
        }else if (indexPath.section == 3){
            //发票
            //        billCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        return billCell;
        }else{
            //商品总额
            if (self.typeOrder == typeOrderAddress) {
                double totalprice = [_nowProdetailModel.price doubleValue]*_nowProcount;
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f",totalprice];
            }else if(self.typeOrder == typeOrderpayCar){
                double totleprice = 0.00;
                NSInteger totalcount = 0;
                for (BuyCarModel* model in _payCarArray) {
                    double proTotleprice = [model.totalprice doubleValue];
                    totalcount = totalcount+1;
                    totleprice = proTotleprice+totleprice;
                }
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f",totleprice];
            }
            priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return priceCell;
        }

    }else if (tableView == _fxCustTableView){
        AddressManageModel* model = _fxCustdataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",model.provincename,model.cityname,model.areaname,model.servincename,model.village,model.comunity,model.roomnumber,model.address];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.numberOfLines = 0;
    }else if (tableView == _pickupWayTableView){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_pickUpwayArray[indexPath.row]];
    }else if (tableView == _addVillTableView){
        GetCustInfoAddressModel* model = _addVillArray[indexPath.row];
        model.province = [self convertNull:model.province];
        model.city = [self convertNull:model.city];
        model.area = [self convertNull:model.area];
        model.servicecenter = [self convertNull:model.servicecenter];
        model.village = [self convertNull:model.village];
        model.phone = [self convertNull:model.phone];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@（%@）",model.province,model.city,model.area,model.servicecenter,model.village,model.phone];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.numberOfLines = 0;
    }
    return cell;
}

- (void)creatNewAddrModel
{
    if (_selectaddressFlag != 1) {
        if (_getCustInfoAddrArray.count!=0) {
            for (int i = 0; i < _getCustInfoAddrArray.count; i++) {
                GetCustInfoAddressModel* addressModel = _getCustInfoAddrArray[i];
                if ([addressModel.isdefault integerValue] == 1) {
                    _selectaddressModel.province = addressModel.province;
                    _selectaddressModel.provinceid = addressModel.provinceid;
                    _selectaddressModel.city = addressModel.city;
                    _selectaddressModel.cityid = addressModel.cityid;
                    _selectaddressModel.area = addressModel.area;
                    _selectaddressModel.areaid = addressModel.areaid;
                    _selectaddressModel.servicecenter = addressModel.servicecenter;
                    _selectaddressModel.serviceid = addressModel.serviceid;
                    _selectaddressModel.village = addressModel.village;
                    _selectaddressModel.villageid = addressModel.villageid;
                    _selectaddressModel.comunity = addressModel.comunity;
                    _selectaddressModel.xiaoqu = addressModel.xiaoqu;
                    _selectaddressModel.roomnumber = addressModel.roomnumber;
                    _selectaddressModel.louhao = addressModel.louhao;
                    _selectaddressModel.address = addressModel.address;
                    _selectaddressModel.linker = addressModel.linker;
                    _selectaddressModel.linkerid = addressModel.linkerid;
                }
            }
        }
    }

}

- (void)nameCelladdressLabelEmptyDeal{
    _selectaddressModel.province = [self convertNull:_selectaddressModel.province];
    _selectaddressModel.city = [self convertNull:_selectaddressModel.city];
    _selectaddressModel.area = [self convertNull:_selectaddressModel.area];
    _selectaddressModel.village = [self convertNull:_selectaddressModel.village];
    _selectaddressModel.servicecenter = [self convertNull:_selectaddressModel.servicecenter];
    _selectaddressModel.roomnumber = [self convertNull:_selectaddressModel.roomnumber];
    _selectaddressModel.comunity= [self convertNull:_selectaddressModel.comunity];
    _selectaddressModel.address = [self convertNull:_selectaddressModel.address];
    _selectaddressModel.phone = [self convertNull:_selectaddressModel.phone];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fxCustTableView) {
        _selectaddressFlag = 1;
        AddressManageModel* model = _fxCustdataArray[indexPath.row];
        _selectaddressModel.provinceid = model.provinceid;
        _selectaddressModel.province = model.provincename;
        _selectaddressModel.cityid = model.cityid;
        _selectaddressModel.city = model.cityname;
        _selectaddressModel.areaid = model.areaid;
        _selectaddressModel.area = model.areaname;
        _selectaddressModel.serviceid = model.serviceid;
        _selectaddressModel.servicecenter = model.servincename;
        _selectaddressModel.villageid = model.villageid;
        _selectaddressModel.village = model.village;
        _selectaddressModel.comunity = model.comunity;
        _selectaddressModel.xiaoqu = model.comunityid;
        _selectaddressModel.roomnumber = model.roomnumber;
        _selectaddressModel.louhao = model.roomnumberid;
        _selectaddressModel.address = model.address;
        _selectaddressModel.linker = model.linker;
        _selectaddressModel.linkerid = model.linkerid;
        [_tbView reloadData];
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
        
    }else if (tableView == _pickupWayTableView){
        if (indexPath.row == 1) {
            _selectpickupwayFlag = @"1";
        }else if(indexPath.row == 0){
            _selectpickupwayFlag = @"0";
        }
        [_tbView reloadData];
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }else if (tableView == _addVillTableView){
        if (!IsEmptyValue(_addVillArray)) {
            _selectaddressFlag = 1;
            GetCustInfoAddressModel* model = _addVillArray[indexPath.row];
            _selectaddressModel = model;
            _selectaddressModel.linkerid = [NSString stringWithFormat:@"%@",model.custid];
            [_tbView reloadData];
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
        }
    }
}

- (void)selectAddBtnClick:(UIButton *)sender
{
    if (self.typeOrder == typeOrderAddress) {
        if ([_nowProdetailModel.pickupway integerValue] == 0) {
            NSLog(@"==点击了地址选择按钮==");
            [self selectAddBtnUI];
            [self selectAddrdataRequest];
        }else if ([_nowProdetailModel.pickupway integerValue] == 1){
            [self searchDisAddressUI];
            [self searchDisAddressRequestData];
        }
    }else if (self.typeOrder == typeOrderpayCar){
        if (!IsEmptyValue(_payCarArray)) {
            NSInteger count = 0;
            for (BuyCarModel* model in _payCarArray) {
                if ([model.pickupway integerValue] == 1) {
                    count++;
                }
            }
            if (_payCarArray.count == count) {
                //自取
                [self searchDisAddressUI];
                [self searchDisAddressRequestData];
                
            }else if(count == 0){
                //配送
                NSLog(@"==点击了地址选择按钮==");
                [self selectAddBtnUI];
                [self selectAddrdataRequest];
            }else{
                [self showAlert:@"配送和自取不能同时结算"];
            }
            
        }
    }

}

- (UIView*)selectAddBtnUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _fxCustTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _fxCustTableView.backgroundColor = [UIColor grayColor];
        _fxCustTableView.delegate = self;
        _fxCustTableView.dataSource = self;
        [windowView addSubview:_fxCustTableView];
    }
    return _myAleartView;
}

- (void)selectAddrdataRequest
{
    /*
     /login/searchAddr.do
     mobile = true,
     data{
        custid:客户id
        provinceid:
        cityid
        areaid：传空
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/searchAddr.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"provinceid\":\"\",\"cityid\":\"\",\"areaid\":\"\"}",userid];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    [parmas setObject:datastr forKey:@"data"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"查询地址%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"appSearchCustAddr.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:NO];
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                [_fxCustdataArray removeAllObjects];
                for (int i = 0; i < array.count; i++) {
                    AddressManageModel* model = [[AddressManageModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_fxCustdataArray addObject:model];
                }
                [_fxCustTableView reloadData];
            }else{
                [self showAlert:@"查询收货地址列表为空，请到个人中心收货地址中添加"];
            }
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"查询地址失败返回%@",error.localizedDescription);
        [hud hide:YES];
    }];
    
}

- (UIView*)selectPickUpWayBtnUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _pickupWayTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _pickupWayTableView.backgroundColor = [UIColor grayColor];
        _pickupWayTableView.delegate = self;
        _pickupWayTableView.dataSource = self;
        [windowView addSubview:_pickupWayTableView];
    }
    return _myAleartView;
}


- (void)closeFxCustAleartView:(UITapGestureRecognizer*)tap
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}
- (void)closeAleartView:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}



- (void)pickUpWayClick:(UIButton*)sender
{
    NSLog(@"==点击了自取方式");
    [self selectPickUpWayBtnUI];
}

- (void)footBtnClick:(UIButton*)sender
{
    if (self.typeOrder == typeOrderAddress) {
        //添加订单
        if (_getCustInfoAddrArray.count == 0&&_selectaddressFlag!=1) {
            [self showAlert:@"默认地址没取到"];
        }else if ([self.golds integerValue] == 1){
            [self addGoldsOrderRequestData:sender];
        }else{
            [self sendAddOrderRequest:sender];
            //        PayForVC* vc = [[PayForVC alloc]init];
            //        vc.paytype = typeAliPay;
            //        vc.orderMoney1 = @"0.01";
            //        vc.orderno1 = @"11222";
            //        vc.orderstr = @"测试";
            //        [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(self.typeOrder == typeOrderpayCar){
        //添加订单
        if (_getCustInfoAddrArray.count == 0) {
            [self showAlert:@"默认地址没取到"];
        }else if ([self.golds integerValue] == 1){
            [self addGoldsOrderPayCarRequest:sender];
        }else{
            [self sendAddOrderPayCarRequest:sender];
        }
    
    }
}

- (void)delectBtnClick:(UIButton*)sender
{

}

#pragma mark aleartViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [self payGoldsOrderRequestData:alertView];
        }
        
    }else if (alertView.tag == 1002){
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [self payGoldsOrderRequestData:alertView];
        }
    }

}
//获取自取的时候的默认地址
- (void)searchDisAddressRequestDataDefault
{
    /*
     /order/searchDisAddressM.do
     mobile:true
     data{
        distributeid
     }
     */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    GetCustInfoAddressModel* addressModel = [[GetCustInfoAddressModel alloc]init];
    if (_getCustInfoAddrArray.count!=0) {
        addressModel = _getCustInfoAddrArray[0];
        addressModel.linkerid = [self convertNull:addressModel.linkerid];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchDisAddressM.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"distributeid\":\"%@\"}",addressModel.linkerid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/order/searchDisAddress.doM%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location!=NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:NO];
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                _pickaddressmodel = [[GetCustInfoAddressModel alloc]init];
                [_pickaddressmodel setValuesForKeysWithDictionary:array[0]];
                _pickaddressmodel.linkerid = addressModel.linkerid;
                _pickaddressmodel.linker = addressModel.linker;
            }
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];

}

- (UIView*)searchDisAddressUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _addVillTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _addVillTableView.backgroundColor = [UIColor grayColor];
        _addVillTableView.delegate = self;
        _addVillTableView.dataSource = self;
        [windowView addSubview:_addVillTableView];
    }
    return _myAleartView;
}

- (void)searchDisAddressRequestData{
    /*
     /order/searchDisAddress.do
     mobile:true
     data{
     custid
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchDisAddress.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/order/searchDisAddress.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location!=NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:NO];
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            [_addVillArray removeAllObjects];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                for (int i = 0; i <array.count; i++) {
                    GetCustInfoAddressModel* model = [[GetCustInfoAddressModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_addVillArray addObject:model];
                }
            }
            [_addVillTableView reloadData];
        }
    } fail:^(NSError *error) {
        [hud hide:YES];
    }];

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
            
            if (self.typeOrder == typeOrderAddress) {
                if ([_nowProdetailModel.pickupway integerValue] == 1){
                    [self searchDisAddressRequestDataDefault];
                }
            }else if (self.typeOrder == typeOrderpayCar){
                if (!IsEmptyValue(_payCarArray)) {
                    NSInteger count = 0;
                    for (BuyCarModel* model in _payCarArray) {
                        if ([model.pickupway integerValue] == 1) {
                            count++;
                        }
                    }
                    if (_payCarArray.count == count) {
                        //自取
                        [self searchDisAddressRequestDataDefault];
                    }
                }
            }
            [_tbView reloadData];
        }
        //        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
        
    }];
    
}


#pragma mark - 获得购物车的内容
- (void)updataCarContent{
    /*
     /cart/searchCartById.do
     mobile:true
     data{
     ids:
     provinceid&cityid&areaid
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    NSMutableString* str = [[NSMutableString alloc]init];
    for (int i = 0 ; i < self.dataIdArray.count; i++) {
        [str appendString:[NSString stringWithFormat:@"%@,",self.dataIdArray[i]]];
    }
    NSString* idstr = str;
    NSRange range = {0,idstr.length - 1};
    idstr = [idstr substringWithRange:range];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",idstr,provinceid,cityid,areaid];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/searchCartById.do"];
    NSLog(@"url%@,params%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"更新searchCart.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"更新searchCart.do重新登录");
//            [self showAlert:@"未登录,请先登录!"];
            LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
            [self.navigationController pushViewController:relogVC animated:NO];
//            [self presentViewController:relogVC animated:YES completion:nil];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"更新购物车数据%@",array);
            _payCarArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array) {
                BuyCarModel *model = [[BuyCarModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_payCarArray addObject:model];
            }
            for (BuyCarModel *carmodel in _payCarArray) {
                OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
                model.picname = carmodel.picname;
                model.proname = carmodel.proname;
                model.price = carmodel.saleprice;
                model.folder = carmodel.folder;
                model.isgolds = carmodel.isgolds;
                model.type = carmodel.type;
                model.count = [NSString stringWithFormat:@"%@",carmodel.count];
                [_dataWaitArray addObject:model];
                [_tbView reloadData];
            }
        }
//        [_hud hide:YES afterDelay:.5];
    } fail:^(NSError *error) {
        
    }];
}


- (void)tbViewcellDataRequest
{
    if (self.typeOrder == typeOrderAddress) {
        OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
        model.picname = _nowProdetailModel.picname;
        model.proname = _nowProdetailModel.proname;
        model.price = _nowProdetailModel.price;
        model.folder = _nowProdetailModel.folder;
        if ([self.golds integerValue] == 1) {
            model.isgolds = @"1";
        }
        model.type = _type;
        model.count = [NSString stringWithFormat:@"%li",(long)_nowProcount];
        [_dataArray addObject:model];
        [_tbView reloadData];
    }
}

- (void)sendAddOrderRequest:(UIButton*)sender
{
    /*
     /send/addOrder.do
     mobile:true
     data{
     custid:,客户id
     custname:,客户姓名
     custphone:,客户电话
     pickupway:0配送1自取
     receiveraddr:,收货地址
     ordercount:,订单个数
     ordermoney:,订单钱数
     spstatus:先传空,
     spnodename:先传空,
     isvalid:1,
     sendtime:先传空,
     payno:传空,
     provinceid:,定位地址的
     cityid:,定位地址的
     areaid:,定位地址的
     provinceidadd:,收货地址的
     cityidadd:,收货地址的
     areaidadd:,收货地址的
     serviceidadd:,收货地址的
     villageidadd:,收货地址的
     communityid
     roomnumberid
     distributeid:分销人
     addOrderList:[{
         proid:,产品id
         proname:,产品名
         prono:,产品编号
         specification:,产品规格
         prounitid:,产品单位id
         prounitname:,产品单位名
         saleprice:,产品单价
         count:,选择产品数量
         money:产品金额
     }]
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    sender.enabled = NO;
    self.nowProdetailModel.Id = [self convertNull:self.nowProdetailModel.Id];
    self.nowProdetailModel.proname = [self convertNull:self.nowProdetailModel.proname];
    self.nowProdetailModel.proname = [self utf8_lover:self.nowProdetailModel.proname];
    
    self.nowProdetailModel.prono = [self convertNull:self.nowProdetailModel.prono];
    self.nowProdetailModel.specification = [self convertNull:self.nowProdetailModel.specification];
    self.nowProdetailModel.specification = [self utf8_lover:self.nowProdetailModel.specification];
    
    self.nowProdetailModel.mainunitid = [self convertNull:self.nowProdetailModel.mainunitid];
    self.nowProdetailModel.mainunitname = [self convertNull:self.nowProdetailModel.mainunitname];
    self.nowProdetailModel.price = [self convertNull:self.nowProdetailModel.price];
    _custInfoModel.Id = [self convertNull:_custInfoModel.Id];
    _custInfoModel.name = [self convertNull:_custInfoModel.name];
    _custInfoModel.name = [self utf8_lover:_custInfoModel.name];
    _custInfoModel.phone = [self convertNull:_custInfoModel.phone];
    NSString* receiveaddr;
    NSInteger pickupway = 0;
    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
        pickupway = 0;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.comunity,_selectaddressModel.roomnumber,_selectaddressModel.address];
    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
        pickupway = 1;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@（%@）",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.phone];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/addOrder.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];

        double price = [_nowProdetailModel.price doubleValue];
        double totleprice = price*_nowProcount;
        NSString* prostr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"saleprice\":\"%@\",\"count\":\"%@\",\"money\":\"%@\"},",self.nowProdetailModel.Id,[NSString stringWithFormat:@"%@(%@)",self.nowProdetailModel.proname,_type],self.nowProdetailModel.prono,self.nowProdetailModel.specification,self.nowProdetailModel.mainunitid,self.nowProdetailModel.mainunitname,self.nowProdetailModel.price,[NSString stringWithFormat:@"%li",(long)_nowProcount],[NSString stringWithFormat:@"%.2f",totleprice]];
        NSRange range = {0,prostr.length - 1};
        prostr = [prostr substringWithRange:range];
        
//        addressModel.provinceid = [self convertNull:addressModel.provinceid];
//        addressModel.cityid = [self convertNull:addressModel.cityid];
//        addressModel.areaid = [self convertNull:addressModel.areaid];
//        addressModel.serviceid = [self convertNull:addressModel.serviceid];
//        addressModel.villageid = [self convertNull:addressModel.villageid];
    _selectaddressModel.xiaoqu = [self convertNull:_selectaddressModel.xiaoqu];
    _selectaddressModel.louhao = [self convertNull:_selectaddressModel.louhao];
    NSString* online;
    if ([self.upline integerValue] == 1) {
    //线下
        online = @"0";
    }else{
    //线上
        online = @"1";
    }
        NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"pickupway\":\"%@\",\"receiveraddr\":\"%@\",\"ordercount\":\"%@\",\"ordermoney\":\"%@\",\"spstatus\":\"\",\"spnodename\":\"\",\"isvalid\":\"1\",\"sendtime\":\"\",\"payno\":\"\",\"provinceidadd\":\"%@\",\"cityidadd\":\"%@\",\"areaidadd\":\"%@\",\"serviceidadd\":\"%@\",\"villageidadd\":\"%@\",\"communityid\":\"%@\",\"roomnumberid\":\"%@\",\"distributeid\":\"%@\",\"online1\":\"%@\",\"addOrderList\":[%@]}",provinceid,cityid,areaid,_custInfoModel.Id,_custInfoModel.name,_custInfoModel.phone,[NSString stringWithFormat:@"%li",(long)pickupway],receiveaddr,[NSString stringWithFormat:@"%li",(long)_nowProcount],[NSString stringWithFormat:@"%.2f",totleprice],_selectaddressModel.provinceid,_selectaddressModel.cityid,_selectaddressModel.areaid,_selectaddressModel.serviceid,_selectaddressModel.villageid,_selectaddressModel.xiaoqu,_selectaddressModel.louhao,_selectaddressModel.linkerid,online,prostr];
        [parmas setObject:datastr forKey:@"data"];
    
    if (totleprice == 0) {
        [self showAlert:@"订单金额为0不能添加订单"];
    }else{
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
            sender.enabled = YES;
            NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"str%@",str);
            if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
                NSLog(@"getAllProductType.do重新登录");
                [self showAlert:@"登录过期请重新登录"];
                LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:NO];
//                [self presentViewController:loginVC animated:YES completion:nil];
            }else{
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                if ([dict[@"status"] integerValue] == 200) {
                    [self showAlert:@"订单添加成功"];
                    _ordermoneyPay = [NSString stringWithFormat:@"%.2f",totleprice];
                    _ordernoPay = [NSString stringWithFormat:@"%@",dict[@"orderno"]];
                    _ordernouuid = [NSString stringWithFormat:@"%@",dict[@"uuid"]];
                    NSArray* array = dict[@"createtime"];
                    NSDictionary* timedict = array[0];
                    NSString* time = [NSString stringWithFormat:@"%@",timedict[@"createtime"]];
                    //商品总额
                    NSString* name = @"";
                    NSMutableString* str = [[NSMutableString alloc]init];
                    if (self.typeOrder == typeOrderAddress) {
                        name = [NSString stringWithFormat:@"%@",_nowProdetailModel.proname];
                    }else if(self.typeOrder == typeOrderpayCar){
                        for (BuyCarModel* model in _payCarArray) {
                            [str appendString:[NSString stringWithFormat:@"%@",model.proname]];
                        }
                        name = [NSString stringWithFormat:@"%@",str];
                    }
                    PayTypeTbVC* payVC = [[PayTypeTbVC alloc]init];
                    payVC.orderno1 = _ordernoPay;
                    payVC.ordernewUUid = _ordernouuid;
                    payVC.orderMoney1 = _ordermoneyPay;
                    payVC.name = name;
//                    payVC.name = _ordernoPay;
                    payVC.mssage1 = _ordernoPay;
                    payVC.time = time;
                    [self.navigationController pushViewController:payVC animated:YES];
                }else{
                    if ([str rangeOfString:@"false"].location != NSNotFound) {
                        if (!IsEmptyValue(dict)) {
                            [self showAlert:[NSString stringWithFormat:@"%@",dict[@"false"]]];
                        }
                    }
                }
            }
            
    } fail:^(NSError *error) {
        [hud hide:YES];
            sender.enabled = YES;
            NSLog(@"添加订单失败%@",error.localizedDescription);
            [self showAlert:error.localizedDescription];
        }];
    }
    
}

- (void)sendAddOrderPayCarRequest:(UIButton*)sender
{
    /*
     /send/addOrder.do
     mobile:true
     data{
     custid:,客户id
     custname:,客户姓名
     custphone:,客户电话
     pickupway:0配送1自取
     receiveraddr:,收货地址
     ordercount:,订单个数
     ordermoney:,订单钱数
     spstatus:先传空,
     spnodename:先传空,
     isvalid:1,
     sendtime:先传空,
     payno:传空,
     provinceid:,定位地址的
     cityid:,定位地址的
     areaid:,定位地址的
     provinceidadd:,收货地址的
     cityidadd:,收货地址的
     areaidadd:,收货地址的
     serviceidadd:,收货地址的
     villageidadd:,收货地址的
     communityid
     roomnumberid
     distributeid:分销人
     addOrderList:[{
     proid:,产品id
     proname:,产品名
     prono:,产品编号
     specification:,产品规格
     prounitid:,产品单位id
     prounitname:,产品单位名
     saleprice:,产品单价
     count:,选择产品数量
     money:产品金额
     }]
     }
     
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    sender.enabled = NO;
    _custInfoModel.Id = [self convertNull:_custInfoModel.Id];
    _custInfoModel.name = [self convertNull:_custInfoModel.name];
    _custInfoModel.phone = [self convertNull:_custInfoModel.phone];
    NSString* receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.address];
    NSInteger pickupway = 0;
    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
        pickupway = 0;
    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
        pickupway = 1;
    }
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/addOrder.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    double totleprice = 0.00;
    NSInteger totalcount = 0;
    
    NSMutableString* mustr = [[NSMutableString alloc]init];
    for (BuyCarModel* model in _payCarArray) {
        double proTotleprice = [model.totalprice doubleValue];
        totalcount = totalcount+1;
        totleprice = proTotleprice+totleprice;
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"saleprice\":\"%@\",\"count\":\"%@\",\"money\":\"%@\"},",model.proid,[NSString stringWithFormat:@"%@(%@)",model.proname,model.type],model.prono,model.specification,model.prounitid,model.prounitname,model.saleprice,[NSString stringWithFormat:@"%@",model.count],[NSString stringWithFormat:@"%@",model.totalprice]];
        [mustr appendString:str];
    }
    NSString* prostr = mustr;
    if (prostr.length!=0) {
        NSRange range = {0,prostr.length - 1};
        prostr = [prostr substringWithRange:range];
    }

    _selectaddressModel.provinceid = [self convertNull:_selectaddressModel.provinceid];
    _selectaddressModel.cityid = [self convertNull:_selectaddressModel.cityid];
    _selectaddressModel.areaid = [self convertNull:_selectaddressModel.areaid];
    _selectaddressModel.serviceid = [self convertNull:_selectaddressModel.serviceid];
    _selectaddressModel.villageid = [self convertNull:_selectaddressModel.villageid];
    _selectaddressModel.xiaoqu = [self convertNull:_selectaddressModel.xiaoqu];
    _selectaddressModel.louhao = [self convertNull:_selectaddressModel.louhao];
    _selectaddressModel.linkerid = [self convertNull:_selectaddressModel.linkerid];
    NSString* online = @"";
    if ([self.upline integerValue] == 1) {
    //线下
        online = @"0";
    }else{
    //线上
        online = @"1";
    }

    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"pickupway\":\"%@\",\"receiveraddr\":\"%@\",\"ordercount\":\"%@\",\"ordermoney\":\"%@\",\"spstatus\":\"\",\"spnodename\":\"\",\"isvalid\":\"1\",\"sendtime\":\"\",\"payno\":\"\",\"provinceidadd\":\"%@\",\"cityidadd\":\"%@\",\"areaidadd\":\"%@\",\"serviceidadd\":\"%@\",\"villageidadd\":\"%@\",\"communityid\":\"%@\",\"roomnumberid\":\"%@\",\"distributeid\":\"%@\",\"online1\":\"%@\",\"addOrderList\":[%@]}",provinceid,cityid,areaid,_custInfoModel.Id,_custInfoModel.name,_custInfoModel.phone,[NSString stringWithFormat:@"%li",(long)pickupway],receiveaddr,[NSString stringWithFormat:@"%li",(long)totalcount],[NSString stringWithFormat:@"%.2f",totleprice],_selectaddressModel.provinceid,_selectaddressModel.cityid,_selectaddressModel.areaid,_selectaddressModel.serviceid,_selectaddressModel.villageid,_selectaddressModel.xiaoqu,_selectaddressModel.louhao,_selectaddressModel.linkerid,online,prostr];
    [parmas setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录过期请重新登录"];
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
//            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"status"] integerValue] == 200) {
                [self showAlert:@"订单添加成功"];
                _ordermoneyPay = [NSString stringWithFormat:@"%.2f",totleprice];
                _ordernoPay = [NSString stringWithFormat:@"%@",dict[@"orderno"]];
                NSArray* array = dict[@"createtime"];
                NSDictionary* timedict = array[0];
                NSString* time = [NSString stringWithFormat:@"%@",timedict[@"createtime"]];
                //商品总额
                NSString* name = @"";
                NSMutableString* str = [[NSMutableString alloc]init];
                if (self.typeOrder == typeOrderAddress) {
                    name = [NSString stringWithFormat:@"%@",_nowProdetailModel.proname];
                }else if(self.typeOrder == typeOrderpayCar){
                    for (BuyCarModel* model in _payCarArray) {
                        [str appendString:[NSString stringWithFormat:@"%@",model.proname]];
                    }
                    name = [NSString stringWithFormat:@"%@",str];
                }
                PayTypeTbVC* payVC = [[PayTypeTbVC alloc]init];
                payVC.orderno1 = _ordernoPay;
                payVC.orderMoney1 = _ordermoneyPay;
                payVC.name = name;
//                payVC.name = _ordernoPay;
                payVC.mssage1 = _ordernoPay;
                payVC.time = time;
                [self.navigationController pushViewController:payVC animated:YES];
            }else{
                if ([str rangeOfString:@"false"].location != NSNotFound) {
                    if (!IsEmptyValue(dict)) {
                        [self showAlert:[NSString stringWithFormat:@"%@",dict[@"false"]]];
                    }
                }
            }
        }
        
    } fail:^(NSError *error) {
        [hud hide:YES];
        sender.enabled = YES;
        NSLog(@"添加订单失败%@",error.localizedDescription);
        [self showAlert:error.localizedDescription];
    }];
    
}

- (NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return [[NSString alloc] initWithData:gb2312data encoding:encoding] ;
}

- (NSData *)UTF8WithGB2312Data:(NSData *)gb2312Data
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc]initWithData:gb2312Data encoding:enc];
    NSData* utf8Data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}

- (NSString*)GB2312str_To_UTF8:(NSString*)gb2312str
{
    NSData* utf8data = [gb2312str dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc]initWithData:utf8data encoding:NSUTF8StringEncoding];
}

- (NSString*)utf8_lover:(NSString*)str
{
//    NSString* str2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString* str1 = [str2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString* str3 = [str2 lowercaseString];
    return str;
}

#pragma mark 添加积分订单
- (void)addGoldsOrderRequestData:(UIButton*)sender
{
    /*
     /golds/addGoldsOrder.do
     communityid
     roomnumberid
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    self.nowProdetailModel.Id = [self convertNull:self.nowProdetailModel.Id];
    self.nowProdetailModel.proname = [self convertNull:self.nowProdetailModel.proname];
    self.nowProdetailModel.proname = [self utf8_lover:self.nowProdetailModel.proname];
    
    self.nowProdetailModel.prono = [self convertNull:self.nowProdetailModel.prono];
    self.nowProdetailModel.specification = [self convertNull:self.nowProdetailModel.specification];
    self.nowProdetailModel.specification = [self utf8_lover:self.nowProdetailModel.specification];
    
    self.nowProdetailModel.mainunitid = [self convertNull:self.nowProdetailModel.mainunitid];
    self.nowProdetailModel.mainunitname = [self convertNull:self.nowProdetailModel.mainunitname];
    self.nowProdetailModel.price = [self convertNull:self.nowProdetailModel.price];
    _custInfoModel.Id = [self convertNull:_custInfoModel.Id];
    _custInfoModel.name = [self convertNull:_custInfoModel.name];
    _custInfoModel.name = [self utf8_lover:_custInfoModel.name];
    _custInfoModel.phone = [self convertNull:_custInfoModel.phone];
//    NSString* receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.address];
//    
//    NSInteger pickupway = 0;
//    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
//        pickupway = 0;
//    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
//        pickupway = 1;
//    }
    NSString* receiveaddr;
    NSInteger pickupway = 0;
    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
        pickupway = 0;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.comunity,_selectaddressModel.roomnumber,_selectaddressModel.address];
    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
        pickupway = 1;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/golds/addGoldsOrder.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    
    double price = [_nowProdetailModel.price doubleValue];
    double totleprice = price*_nowProcount;
    NSString* prostr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"saleprice\":\"%@\",\"count\":\"%@\",\"money\":\"%@\"},",self.nowProdetailModel.Id,self.nowProdetailModel.proname,self.nowProdetailModel.prono,self.nowProdetailModel.specification,self.nowProdetailModel.mainunitid,self.nowProdetailModel.mainunitname,self.nowProdetailModel.price,[NSString stringWithFormat:@"%li",(long)_nowProcount],[NSString stringWithFormat:@"%.2f",totleprice]];
    NSRange range = {0,prostr.length - 1};
    prostr = [prostr substringWithRange:range];
    
    //        addressModel.provinceid = [self convertNull:addressModel.provinceid];
    //        addressModel.cityid = [self convertNull:addressModel.cityid];
    //        addressModel.areaid = [self convertNull:addressModel.areaid];
    //        addressModel.serviceid = [self convertNull:addressModel.serviceid];
    //        addressModel.villageid = [self convertNull:addressModel.villageid];
    
    
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"pickupway\":\"%@\",\"receiveraddr\":\"%@\",\"ordercount\":\"%@\",\"ordermoney\":\"%@\",\"spstatus\":\"\",\"spnodename\":\"\",\"isvalid\":\"1\",\"sendtime\":\"\",\"payno\":\"\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"serviceid\":\"%@\",\"villageid\":\"%@\",\"communityid\":\"%@\",\"roomnumberid\":\"%@\",\"distributeid\":\"%@\",\"addOrderList\":[%@]}",_custInfoModel.Id,_custInfoModel.name,_custInfoModel.phone,[NSString stringWithFormat:@"%li",(long)pickupway],receiveaddr,[NSString stringWithFormat:@"%li",(long)_nowProcount],[NSString stringWithFormat:@"%.2f",totleprice],_selectaddressModel.provinceid,_selectaddressModel.cityid,_selectaddressModel.areaid,_selectaddressModel.serviceid,_selectaddressModel.villageid,_selectaddressModel.xiaoqu,_selectaddressModel.louhao,_selectaddressModel.linkerid,prostr];
    [parmas setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录过期请重新登录"];
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self presentViewController:loginVC animated:YES completion:nil];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"status"] integerValue] == 200) {
                _ordernoPay = dict[@"orderno"];
//                _ordernoPay = [_ordernoPay uppercaseString];
                _ordermoneyPay = [NSString stringWithFormat:@"%.2f",totleprice];
                UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单添加成功，是否立即支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                aleartView.delegate = self;
                aleartView.tag = 1001;
                [aleartView show];

            }else{
                if ([str rangeOfString:@"false"].location != NSNotFound) {
                    if (!IsEmptyValue(dict)) {
                        [self showAlert:[NSString stringWithFormat:@"%@",dict[@"false"]]];
                    }
                }
            }
        }
        
    } fail:^(NSError *error) {
        [hud hide:YES];
        sender.enabled = YES;
        NSLog(@"添加订单失败%@",error.localizedDescription);
        [self showAlert:error.localizedDescription];
    }];


}

#pragma mark 添加积分订单--购物车进入
- (void)addGoldsOrderPayCarRequest:(UIButton*)sender
{
    /*
     /golds/addGoldsOrder.do
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    _custInfoModel.Id = [self convertNull:_custInfoModel.Id];
    _custInfoModel.name = [self convertNull:_custInfoModel.name];
    _custInfoModel.phone = [self convertNull:_custInfoModel.phone];
//    NSString* receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.address];
//    NSInteger pickupway = 0;
//    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
//        pickupway = 0;
//    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
//        pickupway = 1;
//    }
    
    NSString* receiveaddr;
    NSInteger pickupway = 0;
    OrderDetailNameTableViewCell* cell = [_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[0]]) {
        pickupway = 0;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village,_selectaddressModel.comunity,_selectaddressModel.roomnumber,_selectaddressModel.address];
    }else if ([cell.pickUpWayBtn.titleLabel.text isEqualToString:_pickUpwayArray[1]]){
        pickupway = 1;
        receiveaddr = [NSString stringWithFormat:@"%@%@%@%@%@",_selectaddressModel.province,_selectaddressModel.city,_selectaddressModel.area,_selectaddressModel.servicecenter,_selectaddressModel.village];
    }
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/golds/addGoldsOrder.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    double totleprice = 0.00;
    NSInteger totalcount = 0;
    
    NSMutableString* mustr = [[NSMutableString alloc]init];
    for (BuyCarModel* model in _payCarArray) {
        double proTotleprice = [model.totalprice doubleValue];
//        NSInteger count = [model.count integerValue];
        //        totalcount = totalcount+count;
        totalcount = totalcount+1;
        totleprice = proTotleprice+totleprice;
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"saleprice\":\"%@\",\"count\":\"%@\",\"money\":\"%@\"},",model.proid,model.proname,model.prono,model.specification,model.prounitid,model.prounitname,model.saleprice,[NSString stringWithFormat:@"%@",model.count],[NSString stringWithFormat:@"%@",model.totalprice]];
        [mustr appendString:str];
    }
    NSString* prostr = mustr;
    NSRange range = {0,prostr.length - 1};
    prostr = [prostr substringWithRange:range];
    
    //    addressModel.provinceid = [self convertNull:addressModel.provinceid];
    //    addressModel.cityid = [self convertNull:addressModel.cityid];
    //    addressModel.areaid = [self convertNull:addressModel.areaid];
    //    addressModel.serviceid = [self convertNull:addressModel.serviceid];
    //    addressModel.villageid = [self convertNull:addressModel.villageid];
    
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"pickupway\":\"%@\",\"receiveraddr\":\"%@\",\"ordercount\":\"%@\",\"ordermoney\":\"%@\",\"spstatus\":\"\",\"spnodename\":\"\",\"isvalid\":\"1\",\"sendtime\":\"\",\"payno\":\"\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"serviceid\":\"%@\",\"villageid\":\"%@\",\"communityid\":\"%@\",\"roomnumberid\":\"%@\",\"distributeid\":\"%@\",\"addOrderList\":[%@]}",_custInfoModel.Id,_custInfoModel.name,_custInfoModel.phone,[NSString stringWithFormat:@"%li",(long)pickupway],receiveaddr,[NSString stringWithFormat:@"%li",(long)totalcount],[NSString stringWithFormat:@"%.2f",totleprice],_selectaddressModel.provinceid,_selectaddressModel.cityid,_selectaddressModel.areaid,_selectaddressModel.serviceid,_selectaddressModel.villageid,_selectaddressModel.xiaoqu,_selectaddressModel.louhao,_selectaddressModel.linkerid,prostr];
    [parmas setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录过期请重新登录"];
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self presentViewController:loginVC animated:YES completion:nil];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"status"] integerValue] == 200) {
                _ordernoPay = dict[@"orderno"];
//                _ordernoPay = [_ordernoPay uppercaseString];
                _ordermoneyPay = [NSString stringWithFormat:@"%.2f",totleprice];
                UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单添加成功，是否立即支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                aleartView.delegate = self;
                aleartView.tag = 1002;
                [aleartView show];

            }else{
                if ([str rangeOfString:@"false"].location != NSNotFound) {
                    if (!IsEmptyValue(dict)) {
                        [self showAlert:[NSString stringWithFormat:@"%@",dict[@"false"]]];
                    }
                }
            }
        }
        
    } fail:^(NSError *error) {
        [hud hide:YES];
        sender.enabled = YES;
        NSLog(@"添加订单失败%@",error.localizedDescription);
        [self showAlert:error.localizedDescription];
    }];

}


#pragma mark 金币商城商品确认支付
- (void)payGoldsOrderRequestData:(UIAlertView*)aleartView
{
    /*
     /golds/payGoldsOrder.do
     mobile:true
     data{
     ordermoney购买商品所需要的金币数量，custid客户登陆id，orderno订单号
     }
     */
    aleartView.userInteractionEnabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/golds/payGoldsOrder.do"];
    NSString* useridstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    useridstr = [self convertNull:useridstr];
    
    NSString* datastr = [NSString stringWithFormat:@"{\"ordermoney\":\"%@\",\"custid\":\"%@\",\"orderno\":\"%@\"}",_ordermoneyPay,useridstr,_ordernoPay];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        aleartView.userInteractionEnabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/golds/payGoldsOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/golds/payGoldsOrder.do登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
//            [self presentViewController:loginVC animated:YES completion:nil];
        }else if([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"支付成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"支付失败"];
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        aleartView.userInteractionEnabled = YES;
    }];

}





@end
