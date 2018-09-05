//
//  OrderCommentsListViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderCommentsListViewController.h"
#import "OrderCommListTableViewCell.h"
#import "StarsView.h"
#import "OrderManageListModel.h"
#import "LoginNewViewController.h"
#import "MBProgressHUD.h"
#import "OrderManageViewController.h"

#define BOOKMARK_WORD_LIMIT 200

@interface OrderCommentsListViewController ()<UITableViewDelegate,UITableViewDataSource,OrderCommListTableViewCellDelegate,UITextViewDelegate>
{
    UITableView* _tbView;
    UIView* _myAleartView;
    StarsView* _proStars;
    StarsView* _sendStar;
    UITextView* _commTextView;
    NSInteger _StarsProNum;
    NSInteger _StarsSendNum;
    MBProgressHUD* _hud;
    BOOL _addEvaluateFlag;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;

@end

@implementation OrderCommentsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _StarsProNum = 5;
    _StarsSendNum = 5;
    _addEvaluateFlag = NO;
    if (!IsEmptyValue(self.orderNo)) {
        self.title = self.orderNo;
    }else{
        self.title = @"";//订单号
    }
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    if (!IsEmptyValue(self.orderNo)) {
        [self dataRequest];
        //进度HUD
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //设置模式
        _hud.mode = MBProgressHUDModeIndeterminate;
        //_hud.labelText = @"网络不给力，正在加载中...";
        [_hud show:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray* array = self.navigationController.viewControllers;
    NSLog(@"-------%@,,,%@",array,array[array.count - 1 - 1]);
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

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    _tbView.tableHeaderView.height = 5;
    _tbView.rowHeight = 80;
    [self.view addSubview:_tbView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count == 0) {
        return 0;
    }else{
        return _dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCommListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCommListTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderCommListTableViewCell" owner:self options:nil]firstObject];
        cell.delegate = self;
        cell.cancelBtn.hidden = YES;
    }
    
    if (_dataArray.count!=0) {
        OrderManageListModel* model = _dataArray[indexPath.section];
        cell.commantsBtn.tag = indexPath.section;
        if (!IsEmptyValue(model.prostatus)) {
            if ([model.prostatus integerValue] == 1) {
                cell.commantsBtn.backgroundColor = [UIColor grayColor];
                cell.commantsBtn.enabled = NO;
            }else{
                cell.commantsBtn.backgroundColor = [UIColor redColor];
            }
            
        }else{
            cell.commantsBtn.backgroundColor = [UIColor redColor];
        }
        cell.titleLabel.text =  [NSString stringWithFormat:@"%@",model.proname];
        cell.salecountLabel.text = [NSString stringWithFormat:@"数量%@",model.count];
        model.saleprice = [NSString stringWithFormat:@"%@",model.saleprice];
        cell.priceLabel.text = [NSString stringWithFormat:@"单价￥%.2f",[model.saleprice doubleValue]];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)dataRequest
{
        /*
         /order/searchOrderDetail.do
         data{
         orderno:订单编号
         }
         */
        NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
        NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderNo];
        NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
            [_hud hide:YES];
            NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
                NSLog(@"searchOrder.do重新登录");
                LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:NO];
            }else{
                NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"searchOrder.do%@",array);
                if (array.count!=0) {
                    for (int i = 0; i < array.count; i++) {
                        _orderdetailModel = [[OrderManageListModel alloc]init];
                        [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                        [_dataArray addObject:_orderdetailModel];
                    }
                }
                 [_tbView reloadData];
            }
    } fail:^(NSError *error) {
        [_hud hide:YES];
        }];
    
}



#pragma mark OrderCommListTableViewCellDelegate点击取消
- (void)cancelClick:(UIButton*)sender
{
    
}
- (void)commantClick:(UIButton*)sender
{
    [_grayView showView];
    [self myAleartView:sender.tag];
}

- (UIView*)myAleartView:(NSInteger)index
{
    if (!_myAleartView) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleartView.backgroundColor = [UIColor clearColor];
//        [APPDelegate.window addSubview:_myAleartView];
        [self.view addSubview:_myAleartView];
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeWindowClick:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height-300)/2, _myAleartView.width - 40*2, 300)];
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.userInteractionEnabled = YES;
        [_myAleartView addSubview:windowView];
        windowView.backgroundColor = BackGorundColor;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        
        UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        scrollView.contentSize = CGSizeMake(windowView.width, 368);
        scrollView.backgroundColor = [UIColor clearColor];
        [windowView addSubview:scrollView];
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, windowView.width, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"商品评价";
        [scrollView addSubview:titleLabel];
        
        _proStars = [[StarsView alloc]initWithStarSize:CGSizeMake(20, 20) space:5 numberOfStar:5 highlight:[UIColor yellowColor]];
        _proStars.frame = CGRectMake(60, titleLabel.bottom+10, windowView.width - 120, 20);
        _proStars.selectable = YES;
        [_proStars setTransVaule:^(NSInteger index) {
            _StarsProNum = index;//[name integerValue];
        }];
        [scrollView addSubview:_proStars];
        
        UILabel* sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _proStars.bottom+20, windowView.width, 20)];
        sendLabel.text = @"配送评价";
        sendLabel.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:sendLabel];
        
        _sendStar = [[StarsView alloc]initWithStarSize:CGSizeMake(20, 20) space:5 numberOfStar:5 highlight:[UIColor blueColor]];
        _sendStar.frame = CGRectMake(60, sendLabel.bottom+10, windowView.width - 120, 20);
        _sendStar.selectable = YES;
        [scrollView addSubview:_sendStar];
        [_sendStar setTransVaule:^(NSInteger index) {
            _StarsSendNum = index;
        }];
        
        _commTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, _sendStar.bottom+20, windowView.width - 20, 60)];
        _commTextView.text = @"请输入内容...";
        _commTextView.textColor = GrayTitleColor;
        _commTextView.delegate = self;
        [scrollView addSubview:_commTextView];
        
        UILabel* bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(_commTextView.left, _commTextView.bottom+10, _commTextView.width - 60, 20)];
        bottomLabel.text = @"最多可输入200字评论";
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.textColor = GrayTitleColor;
        [scrollView addSubview:bottomLabel];
        
        UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor redColor]];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.frame = CGRectMake(bottomLabel.right, bottomLabel.top, 60, 30);
        [windowView addSubview:sendBtn];
        sendBtn.layer.masksToBounds = YES;
        sendBtn.layer.cornerRadius = 5.0;
        sendBtn.tag = index+10000;
        [scrollView addSubview:sendBtn];
        [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myAleartView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入内容..."]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入内容...";
        textView.textColor = GrayTitleColor;
    }else if (textView.text.length > BOOKMARK_WORD_LIMIT){
        [self showAlert:@"最多可以输入200字"];
        textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];//截取掉下标7之后的字符串
    }
}

//键入Done时，插入换行符，然后执行addBookmark
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > BOOKMARK_WORD_LIMIT)
    {
        textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
        return NO;
    }
    return YES;
}

- (void)sendBtnClick:(UIButton*)sender
{
    NSLog(@"_StarsProNum%li,_StarsSendNum%li,_commTextView.text%@",(long)_StarsProNum,(long)_StarsSendNum,_commTextView.text);
    if ([_commTextView.text isEqualToString:@"请输入内容..."] || [_commTextView.text isEqualToString:@""]) {
        [self showAlert:@"请输入内容"];
    }else if (_StarsSendNum == 0 || _StarsProNum == 0){
        [self showAlert:@"请选择星星评价"];
    }else{
        
        [self addEvaluateRequestData:sender];
    }
}

-(void)closeWindowClick:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

#pragma mark 添加评论
- (void)addEvaluateRequestData:(UIButton*)sender
{
/*
 /evaluate/addEvaluate.do
 mobile:true
 data{
 prolist[{
     proid:产品id
     proname:产品名
     creatorid:用户id
     creator:用户名
     createtime:传空
     orderno：订单号
     comments:评论
     score:商品星星
     sendscore；配送星星
     以上三个必须保证不能为空值。
 }，。。。]
 }
 */
//     _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
    sender.enabled = NO;
    NSMutableString* mustr = [[NSMutableString alloc]init];
    for (OrderManageListModel* model in _dataArray) {
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"creatorid\":\"%@\",\"creator\":\"%@\",\"createtime\":\"\",\"comments\":\"\",\"score\":\"\",\"sendscore\":\"\",\"orderno\":\"%@\"},",model.proid,model.proname,_orderdetailModel.custid,_orderdetailModel.custname,_orderdetailModel.orderno];
        [mustr appendString:str];
    }
    NSString* prostr = mustr;
    NSRange range = {0,prostr.length - 1};
    prostr = [prostr substringWithRange:range];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/evaluate/addEvaluate.do"];
   
    NSString* datastr = [NSString stringWithFormat:@"{\"prolist\":[%@]}",prostr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        //        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"addEvaluate.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"addEvaluate.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            _addEvaluateFlag = YES;
            [self updateEvaluateRequestData:sender];
        }else{
            _addEvaluateFlag = NO;
        }
    } fail:^(NSError *error) {
        //        sender.enabled = YES;
    }];
    
}

#pragma mark 更新评价表
- (void)updateEvaluateRequestData:(UIButton*)sender{
    /*
     /evaluate/updateEvaluate.do
     mobile:true
     data{
     id:订单id
     proid:产品id
     orderno:订单编号
     comments:评论
     score:商品星星
     sendscore；配送星星
     以上三个必须保证不能为空值。
     }
     */
    sender.enabled = NO;
    OrderManageListModel* model = _dataArray[sender.tag - 10000];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/evaluate/updateEvaluate.do"];
//    model.orderno = [model.orderno uppercaseString];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"comments\":\"%@\",\"score\":\"%@\",\"sendscore\":\"%@\",\"proid\":\"%@\",\"orderno\":\"%@\"}",model.Id,_commTextView.text,[NSString stringWithFormat:@"%li",(long)_StarsProNum],[NSString stringWithFormat:@"%li",(long)_StarsSendNum],model.proid,model.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"updateEvaluate.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"addEvaluate.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [_grayView hideView];
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
            [self showAlert:@"评论成功"];
            model.prostatus = @"1";
            [_tbView reloadData];
            if (self.commentType == typeOrderPay) {
                NSArray* array = self.navigationController.viewControllers;
                UIViewController *viewCtl = self.navigationController.viewControllers[array.count-3];
                [self.navigationController popToViewController:viewCtl animated:YES];
            }else{
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
    }];

}






@end
