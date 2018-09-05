//
//  HomeCityViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeCityViewController.h"
#import "CityModel.h"
#import "HomeAreaViewController.h"
#import "MBProgressHUD.h"

@interface HomeCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    NSMutableArray* _cityArray;
    MBProgressHUD* _hud;
}
@end

@implementation HomeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityArray = [[NSMutableArray alloc]init];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:self.proname];
    
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
    if (self.proId.length!=0) {
        [self CityRequest:_proId];
    }
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    if (_cityArray.count!=0) {
        CityModel* model = _cityArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cityArray.count!=0) {
        CityModel* model = _cityArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        model.name = [self convertNull:model.name];
        HomeAreaViewController* homeVC = [[HomeAreaViewController alloc]init];
        homeVC.cityId = [NSString stringWithFormat:@"%@",model.Id];
        homeVC.cityName = [NSString stringWithFormat:@"%@",model.name];
        GetCustInfoAddressModel* addmodel = [[GetCustInfoAddressModel alloc]init];
        addmodel = self.addressmodel;
        addmodel.cityid = [NSString stringWithFormat:@"%@",model.Id];
        addmodel.city = [NSString stringWithFormat:@"%@",model.name];
        homeVC.addressmodel = addmodel;
        [self.navigationController pushViewController:homeVC animated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:model.Id forKey:CITYID];
        [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:CITYNAME];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:CITYNAME object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }

}

//市数据请求
- (void)CityRequest:(NSString*)provinceID
{
    /*
     /areamanage/loadcityadd.do
     mobile:true
     provinceid :省的id
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadcity.do?mobile=true&&provinceid=%@",ROOT_Path,provinceID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"CityArray%@",array);
        [_cityArray removeAllObjects];
        for (int i =0; i <array.count; i++) {
            CityModel* model = [[CityModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_cityArray addObject:model];
        }
        [_tbView reloadData];
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
        
    }];
    
}



@end
