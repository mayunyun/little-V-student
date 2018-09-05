//
//  ProDetailOnlineViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProDetailOnlineViewController.h"
#import "ProDetailImgTableViewCell.h"//imgViewCell
#import "ProDetailProTableViewCell.h"//proCell
#import "ProDetailMessTableViewCell.h"//messCell
#import "ProDetailCommTableViewCell.h"//commCell
#import "UIproessMy.h"//自定义进度条
#import "PayForVC.h"//收银台
#import "getProductDetailModel.h"
#import "getProductDetailImgModel.h"
#import "OrderDetailViewController.h"
#import "LoginNewViewController.h"
//#import "BuyCarVC.h"
#import "BuyCarViewController.h"
#import "GetCustInfoModel.h"
#import "ProCommentsViewController.h"
#import "UIproessMy.h"
#import "NSAttributedString+html.h"
#import "MBProgressHUD.h"

@interface ProDetailOnlineViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    MBProgressHUD* _hud;
    UIButton* _leftBarBtn;
    UITableView* _tbView;
    UILabel* _proPayCountLabel;
    NSMutableArray* _proDetailImgArray;
    NSInteger _proPayCount;
    CGFloat _documentHeight;
    
    UIWebView* _webView;
}
@property (nonatomic,retain)getProductDetailModel* proDetailModel;
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,strong)UIproessMy* proess;

@end

@implementation ProDetailOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    _proDetailImgArray = [[NSMutableArray alloc]init];
    _proPayCount = 1;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    [self creatUI];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _leftBarBtn.hidden = NO;
    [self dataRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _leftBarBtn.hidden = YES;
}

- (void)creatUI
{
    _leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarBtn setImage:[UIImage imageNamed:@"icon-back2"] forState:UIControlStateNormal];
    _leftBarBtn.frame = CGRectMake(10, 20, 30, 30);
    [APPDelegate.window addSubview:_leftBarBtn];
    [_leftBarBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 49)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
    UIImageView* bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49, mScreenWidth, 49)];
    bottomView.userInteractionEnabled = YES;
    bottomView.image = [UIImage imageNamed:@""];
    [self.view addSubview:bottomView];
    CGFloat bottomWidth = mScreenWidth/2;
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
    _proPayCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, bottomleftView.width - 40 - 30, 20)];
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
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
    
    
}

- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
//    BuyCarVC* buyCarVC = [[BuyCarVC alloc]init];
//    [self.navigationController pushViewController:buyCarVC animated:YES];
    BuyCarViewController* buyCarVC = [[BuyCarViewController alloc]init];
    [self.navigationController pushViewController:buyCarVC animated:YES];
}

- (void)reduceBtnClick:(UIButton*)sender
{
    if (_proPayCount > 1) {
        _proPayCount--;
    }
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
}

- (void)addBtnClick:(UIButton*)sender
{
    _proPayCount ++;
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
    
}

- (void)bottomCenerClick:(UIButton*)sender
{
    if (_proPayCount > 0) {
        OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
        orderVC.typeOrder = typeOrderAddress;
        orderVC.nowProdetailModel = _proDetailModel;
        orderVC.nowProcount = _proPayCount;
        orderVC.upline = @"1";
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self showAlert:@"商品个数为0"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0: return 240; break;
        case 1: return 100; break;
        case 2:{
            //            NSString* str = [NSString stringWithFormat:@"%@",[self convertNull:_proDetailModel.note]];
            //            NSString* heightstr = [Command filterHTML:str];
            //            CGFloat height = [Command detailLabelHeight:heightstr width:mScreenWidth - 10 fontsize:13];
            return 40+_webView.frame.size.height;
        }
            break;
        case 3: return 100; break;
        default: return 0; break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ProDetailImgTableViewCell* imgCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailImgTableViewCellID"];
    if (!imgCell) {
        imgCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailImgTableViewCell" owner:self options:nil]firstObject];
        imgCell.imgView.contentMode = UIViewContentModeScaleAspectFit;
        if (!IsEmptyValue(_proDetailImgArray)) {
            getProductDetailImgModel* model = _proDetailImgArray[0];
            [imgCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
        }
    }
    ProDetailProTableViewCell* procell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailProTableViewCellID"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailProTableViewCell" owner:self options:nil]firstObject];
    }
    ProDetailMessTableViewCell* messCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailMessTableViewCellID"];
    if (!messCell) {
        messCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailMessTableViewCell" owner:self options:nil]firstObject];
    }
    ProDetailCommTableViewCell* commCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailCommTableViewCellID"];
    if (!commCell) {
        commCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailCommTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (indexPath.row == 0) {
        if (_proDetailImgArray.count!=0) {
            getProductDetailImgModel* model = _proDetailImgArray[0];
            [imgCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
        }
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return imgCell;
    }else if (indexPath.row == 1){
        procell.titleLabel.text = [NSString stringWithFormat:@"%@",[self convertNull:_proDetailModel.proname]];
        if (!IsEmptyValue(_proDetailModel.prosale)) {
            procell.countLabel.text = [NSString stringWithFormat:@"销量%@",[self convertNull:_proDetailModel.prosale]];
        }else{
            procell.countLabel.text = [NSString stringWithFormat:@"销量0"];
        }
        if (!IsEmptyValue(_proDetailModel.price)) {
            procell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[self convertNull:_proDetailModel.price] doubleValue]];
        }else{
            procell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
        }
        procell.pickupwayLabel.hidden = YES;
        procell.collBtnImgView.hidden = YES;
        procell.collectionLabel.hidden = YES;
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }else if (indexPath.row == 2){
        [messCell.contentView addSubview:_webView];
        messCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return messCell;
    }else if (indexPath.row == 3){
        NSString* bad = [self convertNull:_proDetailModel.bad];
        NSInteger badnum = [bad integerValue];
        NSString* good = [self convertNull:_proDetailModel.good];
        NSInteger goodnum = [good integerValue];
        NSString* middle = [self convertNull:_proDetailModel.middle];
        NSInteger middlenum = [middle integerValue];
        NSInteger totlenum = goodnum+badnum+middlenum;
        CGFloat numb = (CGFloat)goodnum/totlenum*100;
        NSString* str = @"%";
        NSString* num = [NSString stringWithFormat:@"%ld%@",(long)numb,str];
        commCell.rateLabel.text = [NSString stringWithFormat:@"好评度%@",num];
        [self changeTextColor:commCell.rateLabel Txt:commCell.rateLabel.text changeTxt:num];
        commCell.goodImgView.text = [NSString stringWithFormat:@"%@",[self convertNull:good]];
        commCell.badImgView.text = [NSString stringWithFormat:@"%@",[self convertNull:bad]];
        self.proess=[[UIproessMy alloc]initWithFrame:CGRectMake(10, 5, commCell.rateView.width - 20, 3) color:NavBarItemColor];
        NSString* rate = [NSString stringWithFormat:@"%.2f",(CGFloat)goodnum/totlenum];
        if ([rate floatValue] != 0) {
            self.proess.rate = [rate floatValue];
        }
        [commCell.rateView addSubview:self.proess];
        commCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return commCell;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(UIImage *)scaleImage:(UIImage *)origin font:(UIFont *)font{
    CGFloat imgH=origin.size.height;
    CGFloat imgW=origin.size.width;
    CGFloat width;
    CGFloat height;
    CGFloat fontHeight=font.pointSize;
    if(imgW>imgH){
        width=fontHeight;
        height=fontHeight/imgW*imgH;
    }     else{
        height=fontHeight;
        width=fontHeight/imgH*imgW;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [origin drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (indexPath.row == 3) {
            ProCommentsViewController* commVC = [[ProCommentsViewController alloc]init];
            commVC.proid = [NSString stringWithFormat:@"%@",_proDetailModel.Id];
            _proDetailModel.bad = [self convertNull:_proDetailModel.bad];
            _proDetailModel.good = [self convertNull:_proDetailModel.good];
            _proDetailModel.middle = [self convertNull:_proDetailModel.middle];
            NSInteger total = [_proDetailModel.bad integerValue]+[_proDetailModel.good integerValue]+[_proDetailModel.middle integerValue];//
            if (IsEmptyValue(_proDetailModel.bad)) {
                commVC.bad = @"0";
            }else{
                commVC.bad = [NSString stringWithFormat:@"%@",_proDetailModel.bad];
            }
            if (IsEmptyValue(_proDetailModel.good)) {
                commVC.good = @"0";
            }else{
                commVC.good = [NSString stringWithFormat:@"%@",_proDetailModel.good];
            }
            if (IsEmptyValue(_proDetailModel.middle)) {
                commVC.middle = @"0";
            }else{
                commVC.middle = [NSString stringWithFormat:@"%@",_proDetailModel.middle];
            }
            commVC.total = [NSString stringWithFormat:@"%li",(long)total];
            [self.navigationController pushViewController:commVC animated:YES];
        }
    }
}

//某label改变字符串颜色
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

//首行缩进
- (void)resetContent:(UILabel*)label text:(NSString*)text{
    //    NSString *_test  =  @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = label.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    label.attributedText = attrText;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"// 图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    _documentHeight = documentHeight;
    //    [_tbView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _webView.frame = CGRectMake(_webView.frame.origin.x,_webView.frame.origin.y, mScreenWidth, documentHeight);
    [_tbView reloadData];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}

#pragma mark 接口---proid->产品详情
- (void)dataRequest
{
    /*
     /product/getProductDetail.do
     data{
     custid
     proid 商品主键id
     provinceid cityid areaid 客户定位省市区域的id
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
#pragma mark provinceid&cityid&areaid
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getProductDetail.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    _proid = [self convertNull:_proid];
    NSString* userstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userstr = [self convertNull:userstr];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",userstr,_proid,provinceid,cityid,areaid];
    [params setObject:datastr forKey:@"data"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"商品详情请求%@",str);
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"商品详情请求%@",dict);
        NSArray* listArray = dict[@"list"];
        if (listArray.count!=0) {
            _proDetailModel = [[getProductDetailModel alloc]init];
            [_proDetailModel setValuesForKeysWithDictionary:listArray[0]];
        }
        NSArray* piclistArray = dict[@"piclist"];
        [_proDetailImgArray removeAllObjects];
        if (piclistArray.count!=0) {
            for (NSDictionary* dict in piclistArray) {
                getProductDetailImgModel* model = [[getProductDetailImgModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_proDetailImgArray addObject:model];
            }
        }
        //在此处加载webView的原因是：不能在tableViewcell中加载网页那样会造成因为cellForRowAtIndexPath和webViewDidFinishLoad代理互相调用引起的内存泄漏。
        NSString* linkCss = @"<style type=\"text/css\"> img {"
        "width:100%;"
        "height:auto;"
        "}"
        "</style>";
        if (!IsEmptyValue(_proDetailModel.note)) {
            [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",_proDetailModel.note,linkCss] baseURL:nil];
        }
        [_tbView reloadData];
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"商品详情请求失败%@",urlstr);
        
    }];
    
}







@end
