//
//  AddReceiveAddressViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#define TextFont 15
#import "AddReceiveAddressViewController.h"
#import "RoadViewController.h"
#import "ProvienceTableViewCell.h"
#import "AddressPickerView.h"
#import "AddressPickerViewModel.h"
#import "ThirdAddressPickerView.h"
#import "ThirdAddressPickerViewModel.h"
#import "LoginNewViewController.h"
#import "RegisterSalesModel.h"
#import "InviteCodeAddrModel.h"//收货地址的model

@interface AddReceiveAddressViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITextField* _nameTextField;
    UITextField* _phoneTextField;
    UITextView* _detailTextView;
    UISwitch* _setSwitch;
    //省
    UIView* _proBgView;
    //街道
    NSInteger _selectpro;
    NSInteger _selectcity;
    NSInteger _selectarea;
    
    UIView* _myAleartView;
    UIButton* _addressSelectBtn;
    UIButton* _linkerBtn;
    NSString* _linkerBtnID;
    UITableView* _fxCustTableView;
    NSMutableArray* _fxCustArray;
    
    UIButton* _addrNewBtn;//收货地址展示的label
    UITextField* _addrDetailTextField;//详细地址添加文本框
    UIView* _addrAleartView;
}

@property (nonatomic,strong)NSMutableArray* proArray;
@property (nonatomic,strong)NSMutableArray* cityArray;
@property (nonatomic,strong)NSMutableArray* areaArray;
@property (nonatomic,strong)AddressPickerViewModel* addmodel;
@property (nonatomic,strong)ThirdAddressPickerViewModel* villageaddmodel;
@property (nonatomic,strong)NSString* detailaddress;



@end

@implementation AddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _proArray = [[NSMutableArray alloc]init];
    _cityArray = [[NSMutableArray alloc]init];
    _areaArray = [[NSMutableArray alloc]init];
    _fxCustArray = [[NSMutableArray alloc]init];
    [self creatNavUI];
    [self creatUI];
}

- (void)creatNavUI
{
    self.title = @"添加收货地址";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"确定"];
}

- (void)creatUI
{
    UIScrollView* goundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    goundView.backgroundColor = BackGorundColor;
    [self.view addSubview:goundView];
    
    CGFloat cellHight = 45;
    CGFloat leftlabelwidth = 100;
    NSInteger leftlabelfont = 13;
    NSInteger rightbtnfont = 12;
    CGFloat downwidth = 10;
    CGFloat downheight = 5;
    UIView* firstcellView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth, cellHight)];
    firstcellView.backgroundColor = [UIColor whiteColor];
    [goundView addSubview:firstcellView];
    UILabel* firstleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, leftlabelwidth, cellHight)];
    firstleftLabel.text = @"业务中心地址";
    firstleftLabel.font = [UIFont systemFontOfSize:leftlabelfont];
    [firstcellView addSubview:firstleftLabel];
    _addressSelectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _addressSelectBtn.frame = CGRectMake(firstleftLabel.right, 0, firstcellView.width - firstleftLabel.width - 20 - downwidth, cellHight);
    _addressSelectBtn.backgroundColor = [UIColor whiteColor];
    [_addressSelectBtn addTarget:self action:@selector(addressSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _addressSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_addressSelectBtn setTitle:@"请选择业务中心地址" forState:UIControlStateNormal];
    [_addressSelectBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _addressSelectBtn.titleLabel.font = [UIFont systemFontOfSize:rightbtnfont];
    _addressSelectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _addressSelectBtn.titleLabel.numberOfLines = 0;
    [firstcellView addSubview:_addressSelectBtn];
    UIButton* downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.backgroundColor = [UIColor whiteColor];
    downBtn.frame = CGRectMake(_addressSelectBtn.right, (cellHight - downheight)/2, downwidth, downheight);
    [downBtn setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [firstcellView addSubview:downBtn];
    [downBtn addTarget:self action:@selector(addressSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* secondcellView = [[UIView alloc]initWithFrame:CGRectMake(0, firstcellView.bottom+10, mScreenWidth, cellHight)];
    secondcellView.backgroundColor = [UIColor whiteColor];
    [goundView addSubview:secondcellView];
    UILabel* secondleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstleftLabel.left, 0, leftlabelwidth, cellHight)];
    secondleftLabel.text = @"绑定分销人";
    secondleftLabel.font = [UIFont systemFontOfSize:leftlabelfont];
    [secondcellView addSubview:secondleftLabel];
    _linkerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _linkerBtn.frame = CGRectMake(secondleftLabel.right, 0, secondcellView.width - secondleftLabel.width - 20 - downwidth, cellHight);
    _linkerBtn.titleLabel.font = [UIFont systemFontOfSize:rightbtnfont];
    [_linkerBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    [_linkerBtn setTitle:@"请选择分销人" forState:UIControlStateNormal];
    [secondcellView addSubview:_linkerBtn];
    [_linkerBtn addTarget:self action:@selector(linkerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _linkerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton* downBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn1.backgroundColor = [UIColor whiteColor];
    downBtn1.frame = CGRectMake(_linkerBtn.right, (cellHight - downheight)/2, downwidth, downheight);
    [downBtn1 setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [secondcellView addSubview:downBtn1];
    [downBtn1 addTarget:self action:@selector(linkerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* thirdcellView = [[UIView alloc]initWithFrame:CGRectMake(0, secondcellView.bottom+10, mScreenWidth, cellHight)];
    thirdcellView.backgroundColor = [UIColor whiteColor];
    [goundView addSubview:thirdcellView];
    UILabel* thirdleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstleftLabel.left, 0, leftlabelwidth, cellHight)];
    thirdleftLabel.text = @"绑定收货地址";
    thirdleftLabel.font = [UIFont systemFontOfSize:leftlabelfont];
    [thirdcellView addSubview:thirdleftLabel];
    _addrNewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addrNewBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _addrNewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _addrNewBtn.frame = CGRectMake(thirdleftLabel.right, 0, thirdcellView.width - thirdleftLabel.width - 20 - downwidth, cellHight);
    [_addrNewBtn setTitle:@"请绑定收货地址" forState:UIControlStateNormal];
    _addrNewBtn.titleLabel.font = [UIFont systemFontOfSize:rightbtnfont];
    _addrNewBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _addrNewBtn.titleLabel.numberOfLines = 0;
    _addrNewBtn.backgroundColor = [UIColor whiteColor];
    [thirdcellView addSubview:_addrNewBtn];
    [_addrNewBtn addTarget:self action:@selector(addNewClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* downBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn2.backgroundColor = [UIColor whiteColor];
    downBtn2.frame = CGRectMake(_addrNewBtn.right, (cellHight - downheight)/2, downwidth, downheight);
    [downBtn2 setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [thirdcellView addSubview:downBtn2];
    [downBtn2 addTarget:self action:@selector(addNewClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* forthcellView = [[UIView alloc]initWithFrame:CGRectMake(0, thirdcellView.bottom+10, mScreenWidth, cellHight)];
    forthcellView.backgroundColor = [UIColor whiteColor];
    [goundView addSubview:forthcellView];
    UILabel* forthleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstleftLabel.left, 0, leftlabelwidth, cellHight)];
    forthleftLabel.text = @"详细地址";
    forthleftLabel.font = [UIFont systemFontOfSize:leftlabelfont];
    [forthcellView addSubview:forthleftLabel];
    _addrDetailTextField = [[UITextField alloc]initWithFrame:CGRectMake(forthleftLabel.right, 0, forthcellView.width - forthleftLabel.width - 20 - downwidth, cellHight)];
    _addrDetailTextField.delegate = self;
    _addrDetailTextField.placeholder = @"请输入详细地址";
    _addrDetailTextField.font = [UIFont systemFontOfSize:rightbtnfont];
    _addrDetailTextField.backgroundColor = [UIColor whiteColor];
    [forthcellView addSubview:_addrDetailTextField];
    UIView* firthcellView = [[UIView alloc]initWithFrame:CGRectMake(0, forthcellView.bottom+10, mScreenWidth, cellHight)];
    firthcellView.backgroundColor = [UIColor whiteColor];
    [goundView addSubview:firthcellView];
    UILabel* setLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstleftLabel.left, 0, leftlabelwidth, cellHight)];
    setLabel.text = @"设置为默认地址";
    setLabel.font = [UIFont systemFontOfSize:leftlabelfont];
    [firthcellView addSubview:setLabel];
    _setSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(firthcellView.right - 60, (cellHight - 30)/2, 50, 30)];
    _setSwitch.backgroundColor = [UIColor clearColor];
    _setSwitch.onTintColor = NavBarItemColor;
    [firthcellView addSubview:_setSwitch];
    [_setSwitch setOn:YES];
    [_setSwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (CGSize)height:(NSString*)text
{
    NSDictionary* atrDict = @{NSFontAttributeName:PCMTextFont14};
    CGSize size1 =  [text boundingRectWithSize:CGSizeMake(mScreenWidth - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
    return size1;
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
//    if (_nameTextField.text.length == 0) {
//        [self showAlert:@"请输入收货人姓名"];
//    }else if (_phoneTextField.text.length == 0){
//        [self showAlert:@"请输入联系方式"];
//    }else{
        //以上信息都输入完毕可以保存了
        sender.enabled = NO;
        [self AddCustAddrRequest:sender];
    
//    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"详细地址";
        textView.textColor = GrayTitleColor;
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (int i = 0; i < 3; i ++) {
        UIButton* btn = (UIButton*)[APPDelegate.window viewWithTag:2000+i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIView* view = (UIView*)[APPDelegate.window viewWithTag:2100+i];
        view.backgroundColor = [UIColor clearColor];
    }
    
    int i = scrollView.contentOffset.x/mScreenWidth;
    UIView* line = (UIView*)[APPDelegate.window viewWithTag:2100 +i];
    line.backgroundColor = NavBarItemColor;
    UIButton* btn = (UIButton*)[APPDelegate.window viewWithTag:2000 + i];
    [btn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    
}

#pragma mark 点击了分销人
- (void)linkerBtnClick:(UIButton*)sender
{
    _addmodel.village_id = [self convertNull:_addmodel.village_id];
    if (!IsEmptyValue(_addmodel.village_id)) {
        [self FxCustRequest];
        [_grayView showView];
        [self creatFxCustUI];
    }else{
        [self showAlert:@"业务中心为空请核对地址"];
    }
}
- (UIView*)creatFxCustUI{
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
        [self setExtraCellLineHidden:_fxCustTableView];
        [windowView addSubview:_fxCustTableView];
        
    }
    return _myAleartView;
}

- (void)closeFxCustAleartView:(UITapGestureRecognizer*)sender
{
    [_grayView hideView];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}
- (void)closeAleartView:(UIButton*)sender
{
    [_grayView hideView];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}
#pragma mark 点击了绑定收货地址
- (void)addNewClick:(UIButton*)sender
{
    if (!IsEmptyValue(_addmodel.sevicecenter_id)) {
        [_grayView showView];
        [self creatAddrUI:[NSString stringWithFormat:@"%@",_addmodel.village_id]];
    }
}

- (UIView*)creatAddrUI:(NSString*)village_id{
    if (_addrAleartView == nil) {
        _addrAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _addrAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_addrAleartView];
        
        UIImageView* grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _addrAleartView.width, _addrAleartView.height)];
        grayView.userInteractionEnabled = YES;
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_addrAleartView addSubview:grayView];
        UITapGestureRecognizer* garytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAddrTapAleartView:)];
        [grayView addGestureRecognizer:garytap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (mScreenHeight - 300)/2, _addrAleartView.width-20, 300)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        [_addrAleartView addSubview:windowView];
        
        UIScrollView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        [windowView addSubview:sView];
        
        ThirdAddressPickerView* pickerView = [[ThirdAddressPickerView alloc]initWithFrame:CGRectMake(0, 0, windowView.width , windowView.height) Id:village_id];
        [pickerView setTransVaule:^(ThirdAddressPickerViewModel * model,BOOL istrue) {
            _villageaddmodel = [[ThirdAddressPickerViewModel alloc]init];
            _villageaddmodel = model;
            _villageaddmodel.village = [self convertNull:_villageaddmodel.village];
            _villageaddmodel.comunity = [self convertNull:_villageaddmodel.comunity];
            _villageaddmodel.roomnumber = [self convertNull:_villageaddmodel.roomnumber];
            NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@",_villageaddmodel.village,_villageaddmodel.comunity,_villageaddmodel.roomnumber];
            NSLog(@"地址选择器返回值%@",showMsg);
            if (istrue) {
                [_addrNewBtn setTitle:showMsg forState:UIControlStateNormal];
            }else{
//                [_addrNewBtn setTitle:@"绑定收货地址" forState:UIControlStateNormal];
            }
            [_addrAleartView removeFromSuperview];
            _addrAleartView = nil;
            [_grayView hideView];
        }];
        [sView addSubview:pickerView];
    }
    return _addrAleartView;
}

- (void)closeAddrTapAleartView:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_addrAleartView removeFromSuperview];
    _addrAleartView = nil;
}

- (void)swChange:(UISwitch*)sender
{
    
    if (sender.isOn) {
        
        NSLog(@"on");
    }
    else
    {
        NSLog(@"off");
    }
}


- (void)addressSelectBtnClick:(UIButton*)sender
{
    [_grayView showView];
    [self addressAleartView];
}

- (UIView*)addressAleartView
{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleartView.backgroundColor = [UIColor clearColor];
//        [APPDelegate.window addSubview:_myAleartView];
        [self.view addSubview:_myAleartView];
        UIImageView* grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        grayView.userInteractionEnabled = YES;
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        UITapGestureRecognizer* garytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAleartClick:)];
        [grayView addGestureRecognizer:garytap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (mScreenHeight - 300)/2, _myAleartView.width-20, 300)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIScrollView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        [windowView addSubview:sView];
        
        AddressPickerView* pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, windowView.width , windowView.height)];
        [pickerView setTransVaule:^(AddressPickerViewModel * model,NSString * address,BOOL istrue) {
            _addmodel = [[AddressPickerViewModel alloc]init];
            _addmodel = model;
            _detailaddress = address;
            _addmodel.province = [self convertNull:_addmodel.province];
            _addmodel.city = [self convertNull:_addmodel.city];
            _addmodel.district = [self convertNull:_addmodel.district];
            _addmodel.sevicecenter = [self convertNull:_addmodel.sevicecenter];
            _addmodel.village = [self convertNull:_addmodel.village];
            NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@ %@ %@,%@", _addmodel.province, _addmodel.city, _addmodel.district,_addmodel.sevicecenter,_addmodel.village,address];
            NSLog(@"地址选择器返回值%@",showMsg);
            if (istrue) {
                [_addressSelectBtn setTitle:showMsg forState:UIControlStateNormal];
            }else{
//                [_addressSelectBtn setTitle:@"请选择业务中心地址" forState:UIControlStateNormal];
            }
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
            [_grayView hideView];
        }];
        [sView addSubview:pickerView];
    }
    return _myAleartView;
}

- (void)reloadheight
{
    CGFloat height1 =[self height:_addressSelectBtn.titleLabel.text].height;
    if (height1<=60) {
        _addressSelectBtn.frame = CGRectMake(_addressSelectBtn.left, _addressSelectBtn.top, _addressSelectBtn.width, height1);
    }
}

- (void)closeAleartClick:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fxCustTableView) {
        if (!IsEmptyValue(_fxCustArray)) {
            return _fxCustArray.count;
        }
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
    if (tableView == _fxCustTableView) {
        if (!IsEmptyValue(_fxCustArray)) {
            RegisterSalesModel* model = _fxCustArray[indexPath.row];
            cell.textLabel.text =[NSString stringWithFormat:@"%@",model.account];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fxCustTableView) {
        if (!IsEmptyValue(_fxCustArray)) {
            RegisterSalesModel* model = _fxCustArray[indexPath.row];
            _linkerBtnID = [NSString stringWithFormat:@"%@",model.Id];
            [_linkerBtn setTitle:[NSString stringWithFormat:@"%@",model.account] forState:UIControlStateNormal];
            [_grayView hideView];
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
        }
    }
}

- (void)FxCustRequest
{
    ///login/fxCust.do
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/fxCust.do",ROOT_Path];
    _addmodel.village_id = [self convertNull:_addmodel.village_id];
    NSDictionary* params = @{@"villageid":[NSString stringWithFormat:@"%@",_addmodel.village_id]};
    NSLog(@"urlStr---%@params---%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"FxCustRequeststr%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"FxCustRequestarray%@",array);
        if (array.count!=0) {
            [_fxCustArray removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                RegisterSalesModel* model = [[RegisterSalesModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_fxCustArray addObject:model];
            }
            [_fxCustTableView reloadData];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"FxCustRequest请求错误，错误原因%@",error.localizedDescription);
    }];
}


- (void)AddCustAddrRequest:(UIButton*)sender{
/*
 /login/appAddCustAddr.do
 mobile:true
 data{
 custid,
 provinceid,
 cityid,
 areaid,
 serviceid,
 villageid,
 xiaoqu,
 louhao,
 address,
 isdefault,
 invitecode
 }
 */
//    NSString *showMsg = [NSString stringWithFormat: @"姓名%@,电话%@,%hhd,%@ %@ %@.%@ %@,%@",_nameTextField.text,_phoneTextField.text,_setSwitch.on, _addmodel.province, _addmodel.city, _addmodel.district,_addmodel.sevicecenter,_addmodel.village,_detailaddress];
//    NSLog(@"地址选择器返回值%@",showMsg);
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
//    if ([NSString stringWithFormat:@"%@",_addmodel.province_id].length != 0&&[NSString stringWithFormat:@"%@",_addmodel.city_id].length != 0&&[NSString stringWithFormat:@"%@",_addmodel.district_id].length != 0&&[NSString stringWithFormat:@"%@",_addmodel.sevicecenter_id].length != 0&&[NSString stringWithFormat:@"%@",_detailaddress].length != 0&&[NSString stringWithFormat:@"%@",_villageaddmodel.village_id].length != 0&&[NSString stringWithFormat:@"%@",_villageaddmodel.comunity_id].length != 0&&[NSString stringWithFormat:@"%@",_villageaddmodel.roomnumber_id].length != 0) {
            _addmodel.province_id = [self convertNull:_addmodel.province_id];
            _addmodel.city_id = [self convertNull: _addmodel.city_id];
            _addmodel.district_id = [self convertNull:_addmodel.district_id];
            _addmodel.sevicecenter_id = [self convertNull:_addmodel.sevicecenter_id];
            _villageaddmodel.village_id = [self convertNull:_villageaddmodel.village_id];
            _villageaddmodel.comunity_id = [self convertNull:_villageaddmodel.comunity_id];
            _villageaddmodel.roomnumber_id = [self convertNull:_villageaddmodel.roomnumber_id];
            _detailaddress = [self convertNull:_detailaddress];
            
            _linkerBtnID = [self convertNull:_linkerBtnID];
        if (![_linkerBtnID isEqualToString:@""]) {
            NSString* isdefault = @"0";
            if (_setSwitch.on) {
                isdefault = @"1";
            }else{
                isdefault = @"0";
            }
            NSString* urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appAddCustAddr.do"];
            NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
            [parmas setObject:@"true" forKey:@"mobile"];
            NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"serviceid\":\"%@\",\"villageid\":\"%@\",\"xiaoqu\":\"%@\",\"louhao\":\"%@\",\"address\":\"%@\",\"isdefault\":\"%@\",\"invitecode\":\"%@\"}",userid,_addmodel.province_id,_addmodel.city_id,_addmodel.district_id,_addmodel.sevicecenter_id,_villageaddmodel.village_id,_villageaddmodel.comunity_id,_villageaddmodel.roomnumber_id,_addrDetailTextField.text,isdefault,_linkerBtnID];
            
            [parmas setObject:datastr forKey:@"data"];
            
            [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parmas success:^(id result) {
            sender.enabled = YES;
                NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                NSLog(@"添加收货地址接口%@",str);
                if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
                    NSLog(@"/login/appAddCustAddr.do重新登录");
                    [self showAlert:@"登录过期请重新登录"];
                    LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
                    [self.navigationController pushViewController:loginVC animated:NO];
                }else if ([str rangeOfString:@"true"].location != NSNotFound){
                    [self showAlert:@"收货地址添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self showAlert:@"收货地址添加失败"];
                }
                
            } fail:^(NSError *error) {
                sender.enabled = YES;
                NSLog(@"收货地址添加失败原因%@",error.localizedDescription);
            }];
 
        }else{
            sender.enabled = YES;
            [self showAlert:@"请绑定分销人"];
        }
//    }else{
//        sender.enabled = YES;
//        [self showAlert:@"请输入详细地址"];
//    }
}







@end
