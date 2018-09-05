//
//  AddressDetailViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "MineTwoLabelTableViewCell.h"
#import "LoginNewViewController.h"
#import "GetCustInfoModel.h"

@interface AddressDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    UISwitch* _setSwitch;
    NSString* _updatadefaultFlag;
}

@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.title = @"收货地址详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
    [self creatUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPersonContent];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    if ([_addmodel.isdefault integerValue] == 1) {
        [self showAlert:@"默认地址不能删除,先更换默认地址"];
        if (!IsEmptyValue(_updatadefaultFlag)&&[_updatadefaultFlag integerValue] == 1) {
            [self showAlert:@"默认地址不能删除,先更换默认地址"];
        }else{
            [self deleteOrder:sender];
        }
    }else{
        [self deleteOrder:sender];
    }
}


- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 44*5+80)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    _tbView.backgroundColor = BackGorundColor;
    [self setExtraCellLineHidden:_tbView];
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    _tbView.tableHeaderView.height = 5;
    
    UIView* secondcellView = [[UIView alloc]initWithFrame:CGRectMake(0, _tbView.bottom+10, mScreenWidth, 44)];
    secondcellView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondcellView];
    UILabel* setLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, secondcellView.width - 70, secondcellView.height)];
    setLabel.text = @"设置为默认地址";
    setLabel.font = PCMTextFont15;
    [secondcellView addSubview:setLabel];
    _setSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(setLabel.right, 10, 50, 30)];
    _setSwitch.backgroundColor = [UIColor clearColor];
    _setSwitch.onTintColor = NavBarItemColor;
    [secondcellView addSubview:_setSwitch];
    [_setSwitch setOn:NO];
    [_setSwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count != 0) {
        if (indexPath.row == _dataArray.count - 1) {
            return 80;
        }else{
            return 50;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MineTwoLabelTableViewCell* twoCell = [tableView dequeueReusableCellWithIdentifier:@"MineTwoLabelTableViewCellID"];
    if (!twoCell) {
        twoCell = [[[NSBundle mainBundle]loadNibNamed:@"MineTwoLabelTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count == 4) {
        NSArray* array = @[@"分销人",@"省、市、区",@"街道 ",@"详细地址 "];
        NSDictionary* atrDict = @{NSFontAttributeName:PCMTextFont15};
        CGSize size1 =  [array[indexPath.row] boundingRectWithSize:CGSizeMake(mScreenWidth - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
        NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
        twoCell.nameWidth.constant = size1.width;
        twoCell.nameLabel.text = array[indexPath.row];
        twoCell.nameLabel.adjustsFontSizeToFitWidth = YES;
        twoCell.detailTextView.text = _dataArray[indexPath.row];
        twoCell.detailTextView.textAlignment = NSTextAlignmentRight;
        [self contentSizeToFitWithTextViewContent:twoCell.detailTextView];
        twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return twoCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)deleteOrder:(UIButton*)sender
{
    /*
     /login/deleteAddr.do
     mobile:true
     data{
     addrid:地址id
     }
     */
    sender.enabled = NO;
    _addmodel.Id = [self convertNull:_addmodel.Id];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/deleteAddr.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"addrid\":\"%@\"}",_addmodel.Id];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除收货地址返回数据%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/login/deleteAddr.do重新登录");
            [self showAlert:@"登录失效请重新登录"];
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"删除收货地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"删除收货地址失败"];
    }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [self showAlert:error.localizedDescription];
        NSLog(@"删除收货地址失败%@",error.localizedDescription);
    }];
    
    
    
}

- (void)swChange:(UISwitch*)sender
{
    
    if (sender.isOn) {
        
        NSLog(@"on");
        [self PretermitAddrRequest:@"1"];
        
    }else
    {
        NSLog(@"off");
        [self PretermitAddrRequest:@"0"];
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
            [self.navigationController pushViewController:relogVC animated:NO];
            
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"个人信息数据%@",array);
            NSDictionary* dict = array[0];
            _custInfoModel = [[GetCustInfoModel alloc]init];
            [_custInfoModel setValuesForKeysWithDictionary:dict];
            _custInfoModel.account = [self convertNull:_custInfoModel.account];
            _custInfoModel.phone = [self convertNull:_custInfoModel.phone];
            _addmodel.servincename = [self convertNull:_addmodel.servincename];
            _addmodel.village = [self convertNull:_addmodel.village];
            _addmodel.comunity = [self convertNull:_addmodel.comunity];
            _addmodel.roomnumber = [self convertNull:_addmodel.roomnumber];
            _addmodel.address = [self convertNull:_addmodel.address];
            _addmodel.linker = [self convertNull:_addmodel.linker];
            [_dataArray addObject:_addmodel.linker];
            [_dataArray addObject:[NSString stringWithFormat:@"%@%@%@",_addmodel.provincename,_addmodel.cityname,_addmodel.areaname]];
            [_dataArray addObject:_addmodel.servincename];
            [_dataArray addObject:[NSString stringWithFormat:@"%@%@%@%@",_addmodel.village,_addmodel.comunity,_addmodel.roomnumber,_addmodel.address]];
            [_tbView reloadData];

            if ([_addmodel.isdefault integerValue] == 0) {
                [_setSwitch setOn:NO];
            }else{
                [_setSwitch setOn:YES];
            }
        }
        //        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
        NSLog(@"用户信息获取失败%@",error.localizedDescription);
    }];
    
}

- (void)PretermitAddrRequest:(NSString*)isdefaultstr
{
    /*
     /login/pretermitAddr.do
     addrid：
     mobile:true
     isdefault:1，默认；0，不默认
     custid
     */
    _addmodel.Id = [self convertNull:_addmodel.Id];
    isdefaultstr = [self convertNull:isdefaultstr];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/pretermitAddr.do"];
    NSDictionary* params = @{@"mobile":@"true",@"addrid":_addmodel.Id,@"isdefault":isdefaultstr,@"custid":userid};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"设置默认地址%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/login/pretermitAddr.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            if ([isdefaultstr integerValue] == 0) {
                [self showAlert:@"取消默认地址成功"];
                [_setSwitch setOn:NO];
                _updatadefaultFlag = isdefaultstr;
            }else if ([isdefaultstr integerValue] == 1){
                [self showAlert:@"设置默认地址成功"];
                [_setSwitch setOn:YES];
                _updatadefaultFlag = isdefaultstr;
            }
            
        }else{
            if ([isdefaultstr integerValue] == 0) {
                [self showAlert:@"取消默认地址失败"];
                [_setSwitch setOn:YES];
            }else if ([isdefaultstr integerValue] == 1){
                [self showAlert:@"设置默认地址失败"];
                [_setSwitch setOn:NO];
            }
        }
        
    } fail:^(NSError *error) {
    }];
    

}
-(void)contentSizeToFitWithTextViewContent:(UITextView *)textView{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([textView.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = textView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= textView.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = textView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > textView.frame.size.height)
            {
                [textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = textView.contentSize;
            }
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [textView setContentSize:newSize];
        [textView setContentInset:offset];
    }
}
@end
