//
//  HomeAreaViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeAreaViewController.h"
#import "AreaModel.h"
#import "HomeCenterViewController.h"
#import "MBProgressHUD.h"

@interface HomeAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    NSMutableArray* _districtArray;
    MBProgressHUD* _hud;
}

@end

@implementation HomeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _districtArray = [[NSMutableArray alloc]init];
    if (![self.cityName isEqualToString:@""]) {
        [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:self.cityName];
    }
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    if (self.cityId.length!=0) {
        [self AreaRequest:self.cityId];
    }
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _districtArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString* cellID = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (_districtArray.count!=0) {
        AreaModel* model = _districtArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_districtArray.count!=0) {
        AreaModel* model = _districtArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        model.name = [self convertNull:model.name];
        HomeCenterViewController* vc = [[HomeCenterViewController alloc]init];
        vc.areaId = [NSString stringWithFormat:@"%@",model.Id];
        vc.areaName = [NSString stringWithFormat:@"%@",model.name];
        GetCustInfoAddressModel* addmodel = [[GetCustInfoAddressModel alloc]init];
        addmodel = self.addressmodel;
        addmodel.areaid = [NSString stringWithFormat:@"%@",model.Id];
        addmodel.area = [NSString stringWithFormat:@"%@",model.name];
        vc.addressmodel = addmodel;
//        [self.navigationController pushViewController:vc animated:YES];
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:viewCtl animated:YES];
        
        [[NSUserDefaults standardUserDefaults]setObject:model.Id forKey:AREAID];
        [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:AREANAME];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:ManualPositioning];
    }
}

//县数据请求
- (void)AreaRequest:(NSString*)cityID
{
    /*
     /areamanage/loadareaadd.do
     mobile：true
     cityid：市的id
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadarea.do?mobile=true&&cityid=%@",ROOT_Path,cityID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"AreaArray%@",array);
        [_districtArray removeAllObjects];
        for (int i =0; i <array.count; i++) {
            AreaModel* model = [[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_districtArray addObject:model];
        }
        [_tbView reloadData];
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
    }];
    
}





@end
