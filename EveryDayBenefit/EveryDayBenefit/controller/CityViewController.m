//
//  CityViewController.m
//  CityPlist
//
//  Created by cty on 14-2-21.
//  Copyright (c) 2014年 cty. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#import "CityViewController.h"
#import "City.h"
#import "HandleCityData.h"
@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initDataArray
{
    self.letters = [[NSMutableArray alloc] init];
    self.fixArray = [[NSMutableArray alloc] init];
    self.tempArray = [[NSMutableArray alloc] init];//search出来的数据存放
    self.ChineseCities = [[NSMutableArray alloc] init];
    HandleCityData * handle = [[HandleCityData alloc] init];
    NSArray * cityInforArray = [handle cityDataDidHandled];
    [self.letters addObjectsFromArray:[cityInforArray objectAtIndex:0]];//存放所有section字母
    [self.fixArray addObjectsFromArray:[cityInforArray objectAtIndex:1]];//存放所有城市信息数组嵌入数组和字母匹配
    [self.ChineseCities addObjectsFromArray:[cityInforArray objectAtIndex:2]];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatNav];
    self.isSearch = NO;
    [self initDataArray];
    [self initSearchBar];
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (IOS_VERSION >= 7.0) {
        button.frame = CGRectMake(260, 64, 50, 30);
        lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 64, 180, 30)];
//        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, 320, 480+(iPhone5?88:0) - 94 - 49) style:UITableViewStylePlain];
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, 320, mScreenHeight - 94) style:UITableViewStylePlain];
    }
    else{
        lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 44, 180, 30)];
        button.frame = CGRectMake(260, 44, 50, 30);
//        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, 480+(iPhone5?88:0) - 74 - 49) style:UITableViewStylePlain];
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, mScreenHeight - 74) style:UITableViewStylePlain];
    }
    lable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:button];
    [self.view addSubview:self.table];
    [self.view addSubview:lable];
    [button setTitle:@"定位" forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(reLOadLoction) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.loctionCity) {
        lable.text = [NSString stringWithFormat:@"定位城市:%@",self.loctionCity];
    }else{
        lable.text = @"定位失败，请重新定位";
    }
    self.table.dataSource = self;
    self.table.delegate = self;

	// Do any additional setup after loading the view.
}
- (void)creatNav
{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    NSArray* segArr = @[@"全部",@"海外"];
    UISegmentedControl* seg = [[UISegmentedControl alloc]initWithItems:segArr];
    seg.frame = CGRectMake(0, 0, 150, 30);
    seg.selectedSegmentIndex = 0;
    seg.tintColor = NavBarItemColor;
    self.navigationItem.titleView = seg;
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Initialization

- (void)initSearchBar
{
    if (IOS_VERSION >= 7.0) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44)];
    }else{
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    }
    
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"名称";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}
#pragma mark tableViewDelegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.letters.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.tempArray.count;
    }
    NSArray * letterArray = [self.fixArray objectAtIndex:section];//对应字母所含城市数组
    return letterArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    return [self.letters objectAtIndex:section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.isSearch) {
        return 1;
    }
    return index;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    City * city;
    if (self.isSearch) {
        city = [self.tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
        
    }else{
        NSArray * letterArray = [self.fixArray objectAtIndex:indexPath.section];//对应字母所含城市数组
        city = [letterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [_delegete cityViewdidSelectCity:cell.textLabel.text anamation:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark searchBarDelegete
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tempArray removeAllObjects];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (City * city in self.ChineseCities) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [self.tempArray addObject:city];
            }else if (letters.location != NSNotFound){
                [self.tempArray addObject:city];
            }
        }
    }
    [self.table reloadData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segClick:(UISegmentedControl*)sender
{

}



@end
