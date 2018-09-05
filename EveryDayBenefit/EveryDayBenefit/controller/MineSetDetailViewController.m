//
//  MineSetDetailViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineSetDetailViewController.h"
#import "MineSaveDetailViewController.h"

#import "GetCustInfoModel.h"
#import "LoginNewViewController.h"

@interface MineSetDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView* _headerImgView;
}
@property (nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineSetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"设置个人资料"];
    self.custInfoModel.phone = [self convertNull:self.custInfoModel.phone];
    self.custInfoModel.account = [self convertNull:self.custInfoModel.account];
    self.custInfoModel.name = [self convertNull:self.custInfoModel.name];
    self.addressModel.linker = [self convertNull:self.addressModel.linker];
    self.custInfoModel.golds = [self convertNull:self.custInfoModel.golds];
    if (!IsEmptyValue(self.custInfoModel.name)) {
        [_dataArray addObject:self.custInfoModel.name];
    }else{
        [_dataArray addObject:[NSString stringWithFormat:@""]];
    }
    if (!IsEmptyValue(self.custInfoModel.account)) {
        [_dataArray addObject:self.custInfoModel.account];
    }else{
        [_dataArray addObject:[NSString stringWithFormat:@""]];
    }
    if (!IsEmptyValue(self.custInfoModel.phone)) {
        [_dataArray addObject:self.custInfoModel.phone];
    }else{
        [_dataArray addObject:[NSString stringWithFormat:@""]];
    }
    if (!IsEmptyValue(self.addressModel.linker)) {
        [_dataArray addObject:self.addressModel.linker];
    }else{
        [_dataArray addObject:[NSString stringWithFormat:@""]];
    }
    if (!IsEmptyValue(self.custInfoModel.golds)) {
        [_dataArray addObject:self.custInfoModel.golds];
    }else{
        [_dataArray addObject:[NSString stringWithFormat:@""]];
    }
    [self creatUI];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    UITableView* tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    tbView.backgroundColor = BackGorundColor;
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.tableHeaderView.backgroundColor = BackGorundColor;
    [self.view addSubview:tbView];
    [self setExtraCellLineHidden:tbView];
    
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(10, mScreenHeight - 64 - 49, mScreenWidth - 20, 35);
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitBtn.backgroundColor = NavBarItemColor;
    [self.view addSubview:exitBtn];
    exitBtn.layer.masksToBounds = YES;
    exitBtn.layer.cornerRadius = 5.0;
    [exitBtn addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        if (!IsEmptyValue(_dataArray)) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 10;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 44)];
    titleLabel.textAlignment = NSTextAlignmentJustified;
    [cell.contentView addSubview:titleLabel];
    UILabel* dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, mScreenWidth - 140, 44)];
    [cell.contentView addSubview:dataLabel];
    if (indexPath.section == 0) {
        cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 80);
        _headerImgView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"icon-11"]];
        _headerImgView.frame = CGRectMake(cell.contentView.width - 90, 15, 55, 55);
        if (!IsEmptyValue(_custInfoModel.picname)) {
            [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",ROOT_Path,_custInfoModel.picsrc,_custInfoModel.picname]] placeholderImage:[UIImage imageNamed:@"icon-11"]];
        }
        [cell.contentView addSubview:_headerImgView];
        cell.textLabel.text = @"头像";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        if (!IsEmptyValue(_dataArray)) {
            if (indexPath.row == 0) {
                titleLabel.text = [NSString stringWithFormat:@"真实姓名："];
                dataLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
            }else if (indexPath.row == 1){
                titleLabel.text = [NSString stringWithFormat:@"昵称："];
                dataLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
            }else if (indexPath.row == 2){
                titleLabel.text = [NSString stringWithFormat:@"电话："];
                dataLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
            }else if (indexPath.row == 3){
                titleLabel.text = [NSString stringWithFormat:@"绑定分销人："];
                dataLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
            }else if (indexPath.row == 4){
                titleLabel.text = [NSString stringWithFormat:@"金币："];
                dataLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //跳转到设置资料页面
        MineSaveDetailViewController* saveVC = [[MineSaveDetailViewController alloc]
                                                init];
        saveVC.custInfoModel = self.custInfoModel;
        saveVC.addressModel = self.addressModel;
        [self.navigationController pushViewController:saveVC animated:YES];
    }else{
        
    
    }

}

- (void)exitClick:(UIButton*)sender
{
    [self outlogin:sender];
//    UIViewController *viewCtl = self.navigationController.viewControllers[0];
//    [self.navigationController popToViewController:viewCtl animated:YES];
}

- (void)outlogin:(UIButton*)sender
{
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/outLogin.do"];
    NSLog(@"%@",urlstr);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"退出登录%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"退出登录"];
            [self.tabBarController setSelectedIndex:0];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERLINKER];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERLINKERID];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERPHONE];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"0" forKey:@"isAutoLogin"];
            [userDefault synchronize];
        }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"退出登录错误信息,%@",error.localizedDescription);
    }];
}


@end
