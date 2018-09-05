//
//  MyAleartTbView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/21.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MyAleartTbView.h"
@interface MyAleartTbView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, strong) UIView *myAleartView;
@property(nonatomic, assign) BOOL isclick;
@end
@implementation MyAleartTbView

- (instancetype)init:(UIButton*)b
{
    self = [super init];
    self.table = (UITableView*)[super init];
    self.btnSender = b;
    if (self) {
        
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
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        self.table.backgroundColor = [UIColor grayColor];
        self.table.delegate = self;
        self.table.dataSource = self;
        [windowView addSubview:self.table];
    }
    return self;
}


- (void)closeFxCustAleartView:(UITapGestureRecognizer*)tap
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (void)closeAleartView:(UIButton*)sender
{
    _isclick = !_isclick;
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
    //    通过block反向传值
    if (_transVaule) {
        _transVaule(self.isclick);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text =[self.list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self myDelegate:indexPath.row];
}

- (void) myDelegate:(NSInteger)index {
    [self.delegate niDropDownDelegateMethod:self index:index];
}


@end
