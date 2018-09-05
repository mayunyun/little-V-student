//
//  ProDetailViewController.m
//  lx
//
//  Created by 联祥 on 16/1/8.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "ProDetailViewController.h"
#import "MBProgressHUD.h"
#import "ProCommentsViewController.h"
#import "UIproessMy.h"//自定义进度条
#import "PayForVC.h"//收银台

@interface ProDetailViewController ()
{
    MBProgressHUD* _hud;
    UIButton* _leftBarBtn;
    UIButton* _payCarBarBtn;
    //
    UIScrollView* _groundView;
    UIImageView* _bannerImgView;
    UILabel* _proTitleLabel;
    UILabel* _proCountLabel;
    UILabel* _proPriceLabel;
    UIButton* _procollBtn;
    UIImageView* _collimgView;
    UILabel* _proMessTitleLabel;
    UILabel* _proMessDetailLabel;
    UILabel* _proCommTitleLabel;
    UILabel* _proGoodRateLabel;
    UILabel* _goodCountLabel;
    UILabel* _badCountLabel;
    UIView* _proRateView;
    
    UILabel* _proPayCountLabel;
    NSInteger _procount;

}
@property (nonatomic,strong)UIproessMy* proess;

@end

@implementation ProDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _procount = 0;
    [self creatUI];
    [self dataRequest];
}

- (void)creatUI
{
    _leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarBtn setImage:[UIImage imageNamed:@"icon-back2"] forState:UIControlStateNormal];
    _leftBarBtn.frame = CGRectMake(10, 20, 30, 30);
    [APPDelegate.window addSubview:_leftBarBtn];
    [_leftBarBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _payCarBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payCarBarBtn setImage:[UIImage imageNamed:@"icon-gouwuce"] forState:UIControlStateNormal];
    _payCarBarBtn.frame = CGRectMake(mScreenWidth - 40, 20, 30, 30) ;
    [APPDelegate.window addSubview:_payCarBarBtn];
    [_payCarBarBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, mScreenHeight - 49 - 20)];
    _groundView.contentSize = CGSizeMake(mScreenWidth, 545);//180+115+100+100+50
    _groundView.bounces = NO;
    _groundView.showsVerticalScrollIndicator = NO;
    _groundView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_groundView];
    
    _bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 180)];
    _bannerImgView.userInteractionEnabled = YES;
    [_groundView addSubview:_bannerImgView];
    
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _bannerImgView.bottom, mScreenWidth, 115)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:contentView];
    _proTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, contentView.width - 20, 30)];
    _proTitleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:_proTitleLabel];
    _proCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_proTitleLabel.left, _proTitleLabel.bottom, contentView.width/2, 30)];
    _proCountLabel.font = [UIFont systemFontOfSize:13];
    _proCountLabel.textColor = GrayTitleColor;
    [contentView addSubview:_proCountLabel];
    _proPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_proTitleLabel.left, _proCountLabel.bottom, _proTitleLabel.width - 60, 50)];
    _proPriceLabel.font = [UIFont systemFontOfSize:18];
    _proPriceLabel.textColor = NavBarItemColor;
    [contentView addSubview:_proPriceLabel];
    _procollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _procollBtn.frame = CGRectMake(_proPriceLabel.right, _proPriceLabel.top, 60, _proPriceLabel.height);
    _collimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 15, 15)];
    _collimgView.image = [UIImage imageNamed:@"collection"];
    [_procollBtn addSubview:_collimgView];
    UILabel* collLabel = [[UILabel alloc]initWithFrame:CGRectMake(_collimgView.right, _collimgView.top, _procollBtn.width - _collimgView.width, 30)];
    collLabel.font = [UIFont systemFontOfSize:13];
    collLabel.textColor = GrayTitleColor;
    collLabel.text = @"收藏";
    [_procollBtn addSubview:collLabel];
    [contentView addSubview:_procollBtn];
    [_procollBtn addTarget:self action:@selector(procollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.bottom - 1, contentView.width, 1)];
    line.backgroundColor = LineColor;
    [_groundView addSubview:line];
    
    
    UIView* contentMessView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.bottom, mScreenWidth, 100)];
    contentMessView.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:contentMessView];
    _proMessTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, contentMessView.width - 20, 20)];
    _proMessTitleLabel.text = @"商品信息";
    _proMessTitleLabel.textColor = LineColor;
    _proMessTitleLabel.font = [UIFont systemFontOfSize:13];
    [contentMessView addSubview:_proMessTitleLabel];
    _proMessDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_proMessTitleLabel.left, _proMessTitleLabel.bottom, _proMessTitleLabel.width, 80)];
    _proMessDetailLabel.numberOfLines = 0;
    _proMessDetailLabel.font = [UIFont systemFontOfSize:13];
    _proMessDetailLabel.textColor = GrayTitleColor;
    [contentMessView addSubview:_proMessDetailLabel];
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, contentMessView.bottom - 1, contentMessView.width, 1)];
    line1.backgroundColor = LineColor;
    [_groundView addSubview:line1];
    
    UIView* contentcommView = [[UIView alloc]initWithFrame:CGRectMake(0, contentMessView.bottom, _groundView.width, 100)];
    contentcommView.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:contentcommView];
    _proCommTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, contentcommView.width - 20, 20)];
    _proCommTitleLabel.font = [UIFont systemFontOfSize:13];
    _proCommTitleLabel.textColor = LineColor;
    _proCommTitleLabel.text = @"商品评价";
    [contentcommView addSubview:_proCommTitleLabel];
    //好评度
    _proGoodRateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_proCommTitleLabel.left, _proCommTitleLabel.bottom, _proCommTitleLabel.width, 30)];
    _proGoodRateLabel.userInteractionEnabled = YES;
    _proGoodRateLabel.font = [UIFont systemFontOfSize:13];
    _proGoodRateLabel.textAlignment = NSTextAlignmentCenter;
    [contentcommView addSubview:_proGoodRateLabel];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RateClick:)];
    [_proGoodRateLabel addGestureRecognizer:tap];
    UIView* rateView = [[UIView alloc]initWithFrame:CGRectMake(10, _proGoodRateLabel.bottom, _proGoodRateLabel.width, 50)];
    [contentcommView addSubview:rateView];
   UIButton* proGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proGoodBtn.frame = CGRectMake(0, 0, 40, 40);
    UIImageView* goodView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 10, 10)];
    goodView.image = [UIImage imageNamed:@"goodjudge"];
    [proGoodBtn addSubview:goodView];
    _goodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodView.right+5, 10, proGoodBtn.width - goodView.width - 5, 20)];
    _goodCountLabel.textColor = LineColor;
    _goodCountLabel.font = [UIFont systemFontOfSize:10];
    [proGoodBtn addSubview:_goodCountLabel];
    [rateView addSubview:proGoodBtn];
    [proGoodBtn addTarget:self action:@selector(goodZanClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* proBadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBadBtn.frame = CGRectMake(rateView.right - 40, 0, 40, 40);
    UIImageView* badView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 10, 10)];
    badView.image = [UIImage imageNamed:@"badjudge"];
    [proBadBtn addSubview:badView];
    _badCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(badView.right+5, 10, proBadBtn.width - badView.width - 5, 20)];
    _badCountLabel.textColor = LineColor;
    _badCountLabel.font = [UIFont systemFontOfSize:10];
    [proBadBtn addSubview:_badCountLabel];
    [rateView addSubview:proBadBtn];
    [proBadBtn addTarget:self action:@selector(badZanClick:) forControlEvents:UIControlEventTouchUpInside];
    self.proess=[[UIproessMy alloc]initWithFrame:CGRectMake(0, proGoodBtn.bottom+5, rateView.width, 3) color:NavBarItemColor];
    [rateView addSubview:self.proess];
    
    
    UIImageView* bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49, mScreenWidth, 49)];
    bottomView.userInteractionEnabled = YES;
    bottomView.image = [UIImage imageNamed:@""];
    [self.view addSubview:bottomView];
    CGFloat bottomWidth = mScreenWidth/3;
    UIView* bottomleftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomWidth, bottomView.height)];
    [bottomView addSubview:bottomleftView];
    UIButton* leftReduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftReduceBtn.frame = CGRectMake(10, 10, 30, 30);
    [leftReduceBtn setImage:[UIImage imageNamed:@"icon-14"] forState:UIControlStateNormal];
    [bottomleftView addSubview:leftReduceBtn];
    [leftReduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* leftAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftAddBtn.frame = CGRectMake(bottomleftView.right - 30, 10, 30, 30);
    [leftAddBtn setImage:[UIImage imageNamed:@"icon-17"] forState:UIControlStateNormal];
    [bottomleftView addSubview:leftAddBtn];
    [leftAddBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _proPayCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftReduceBtn.right, 10, leftAddBtn.right - leftReduceBtn.right, 20)];
    _proPayCountLabel.text = @"0";
    _proPayCountLabel.textAlignment = NSTextAlignmentCenter;
    _proPayCountLabel.textColor = NavBarItemColor;
    [bottomleftView addSubview:_proPayCountLabel];
    
    UIButton* bottomcenterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomcenterBtn.frame = CGRectMake(bottomleftView.right, 0, bottomWidth, bottomView.height);
    [bottomcenterBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [bottomcenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomcenterBtn.backgroundColor = [UIColor blackColor];
    [bottomView addSubview:bottomcenterBtn];
    [bottomcenterBtn addTarget:self action:@selector(bottomCenerClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* bottomrightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomrightBtn.frame = CGRectMake(bottomcenterBtn.right, 0, bottomWidth, bottomView.height);
    [bottomrightBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [bottomrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomrightBtn.backgroundColor = NavBarItemColor;
    [bottomView addSubview:bottomrightBtn];
    [bottomrightBtn addTarget:self action:@selector(bottomRightClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1683fb"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _leftBarBtn.hidden = NO;
    _payCarBarBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _leftBarBtn.hidden = YES;
    _payCarBarBtn.hidden = YES;
}

- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{

}
#pragma  mark 收藏
- (void)procollBtnClick:(UIButton*)sender
{

}

- (void)RateClick:(UITapGestureRecognizer*)tap
{
    ProCommentsViewController* commVC = [[ProCommentsViewController alloc]init];
    [self.navigationController pushViewController:commVC animated:YES];

}

- (void)goodZanClick:(UIButton*)sender
{

}

- (void)badZanClick:(UIButton*)sender
{

}

- (void)reduceBtnClick:(UIButton*)sender
{
    if (_procount > 0) {
        _procount = _procount-1;
    }
    _proPayCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_procount];
}

- (void)addBtnClick:(UIButton*)sender
{
    _procount = _procount+1;
    _proPayCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_procount];
}
//立即购买
- (void)bottomCenerClick:(UIButton*)sender
{
    //
    PayForVC* vc = [[PayForVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)bottomRightClick:(UIButton*)sender
{

}



- (void)dataRequest
{
    _bannerImgView.image = [UIImage imageNamed:@"2016021853.jpg"];
    _proTitleLabel.text = @"汤臣倍健蛋白粉";
    NSString* count = @"200";
    _proCountLabel.text = [NSString stringWithFormat:@"销量%@",count];
    _proPriceLabel.text = [NSString stringWithFormat:@"￥200.00"];
    if (self.isCollection) {
    //收藏
        _collimgView.image = [UIImage imageNamed:@"collection1"];
    }else{
    //未收藏
        _collimgView.image = [UIImage imageNamed:@"collection"];
    }
    _proMessTitleLabel.text = @"商品信息";
    _proMessDetailLabel.text = @"商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息商品信息";
    
//    //原高度是80
//    NSDictionary* atrDict = @{NSFontAttributeName:PCMTextFont13};
//    CGSize size1 =  [_proMessDetailLabel.text boundingRectWithSize:CGSizeMake(_proMessDetailLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
//    NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
//    _proMessDetailLabel.frame = CGRectMake(10, 30, _proMessDetailLabel.width, size1.height);
//    _groundView.contentSize = CGSizeMake(_groundView.width, _groundView.height+size1.height);
    _proCommTitleLabel.text = @"商品评价";
    //
    _proGoodRateLabel.text = @"好评度75%";
    [self changeTextColor:_proGoodRateLabel Txt:_proGoodRateLabel.text changeTxt:@"75%"];
    //设置值 百分比
    self.proess.rate= 0.75;
    CGFloat num = (CGFloat)75/100;
    NSLog(@"self.proess.rate%f",num);
    _goodCountLabel.text = @"3";
    _badCountLabel.text = @"1";

}






@end
