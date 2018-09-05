//
//  LeadScrollView.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/27.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LeadScrollView.h"
#import "LeadModel.h"

@interface LeadScrollView ()

@property (nonatomic , strong) UIPageControl *pageContrl;

@property (nonatomic , strong) NSTimer *codeTimer;

@property (nonatomic , strong) NSMutableArray* dataArray;


@end

@implementation LeadScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dataArray  = [[NSMutableArray alloc]init];
        [self dataRequestLead];
    }
    return self;
}

- (void)creatIMG
{
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    //创建图片
    for(int i = 0 ; i < _imageUrlArray.count ; i ++)
    {
        UIImageView *leadPicture = [[UIImageView alloc] initWithFrame:self.bounds];
        leadPicture.left = i * self.width;
        if (kDevice_Is_iPhone4s) {
//            leadPicture.image = [UIImage imageNamed:LeadPictures4[i]];
            [leadPicture sd_setImageWithURL:[NSURL URLWithString:_imageUrlArray[i]] placeholderImage:[UIImage imageNamed:@"defaultguide"]];
        }else{
//            leadPicture.image = [UIImage imageNamed:LeadPictures[i]];
            [leadPicture sd_setImageWithURL:[NSURL URLWithString:_imageUrlArray[i]] placeholderImage:[UIImage imageNamed:@"defaultguide"]];
        }
        
        [self addSubview:leadPicture];
    }
    //这样创建btn的原因是当只有一张图片的时候是不可滑动的。所以手动点击跳出引导页。
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((_imageUrlArray.count-1)*mScreenWidth+(mScreenWidth - 100)/2, mScreenHeight - 50, 100, 40);
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(beginTouchAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createPageContrl
{
    //页码
    self.pageContrl = [[UIPageControl alloc] init];
    self.pageContrl.width = _imageUrlArray.count * 20;
    self.pageContrl.height = 20;
    self.pageContrl.right = self.left + self.width - mScreenWidth/2+self.pageContrl.width/2;
//    self.pageContrl.right = self.left + self.width -10;
    self.pageContrl.bottom = self.top + self.height;
    self.pageContrl.numberOfPages = _imageUrlArray.count;
    [self.superview addSubview:self.pageContrl];
}

- (void)beginTouchAction
{
    [self.codeTimer invalidate];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FristLaunch];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.beginBlock();
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0;
        self.pageContrl.alpha =0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageContrl.currentPage = self.contentOffset.x/mScreenWidth;
    
    if(self.pageContrl.currentPage == _imageUrlArray.count - 1)
    {
        self.pageContrl.currentPage = _imageUrlArray.count - 1;
        self.scrollEnabled = NO;
        //初始化定时器
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginTouchAction) userInfo:nil repeats:YES];
    }
}

#pragma mark 类方法-判断程序是否第一次启动
+ (BOOL)launchFirst
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:FristLaunch] boolValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dataRequestLead
{
    /*
     /guidepagesite/searchGuidepagePhone.do
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/guidepagesite/searchGuidepagePhone.do"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"guidepagesite/searchGuidepagePhone.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (array.count!=0) {
            NSMutableArray* imageArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < array.count; i++) {
                LeadModel* model = [[LeadModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                NSString* imageurl = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname];
                [imageArray addObject:imageurl];
            }
            self.imageUrlArray = [NSArray arrayWithArray:imageArray];
            [self creatIMG];
            [self setPagingEnabled:YES];
            [self createPageContrl];
            if (_transValue) {
                _transValue(self.imageUrlArray);
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}



@end
