//
//  EScrollerView.m
//  Hnair4iPhone
//
//  Created by 02 on 14-6-18.
//  Copyright (c) 2014年 yingkong1987. All rights reserved.
//

#import "EScrollerView.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+ProgressView.h"
#define Width self.bounds.size.width
#define Height self.bounds.size.height
@interface EScrollerView()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_imageArray;
    NSTimer *timer;
    NSInteger _currentPageIndex;
    
}
@end

@implementation EScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           }
    return self;
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr
{
 
    self = [super initWithFrame:rect];
    if (self) {
        _currentPageIndex = 0;
        _imageArray = [[NSMutableArray alloc]initWithArray:imgArr];
        [_imageArray insertObject:[imgArr lastObject] atIndex:0];
        [_imageArray addObject:[imgArr firstObject]];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(Width *_imageArray.count, Height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.pagingEnabled = YES;
        
        for (int i = 0; i<_imageArray.count; i++) {
            //  NSLog(@"img %@ ",[_imageArray objectAtIndex:i]);
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Width * i, 0, Width, Height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_img_banner"] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
//                
//                CGSize newSize;
//                CGImageRef imageRef =nil;
//                
//                if ((image.size.width / image.size.height) < 1) {
//                    newSize.width = image.size.width;
//                    newSize.height = image.size.width ;
//                    
//                    imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0,fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//                    
//                } else {
//                    newSize.height = image.size.height;
//                    newSize.width = image.size.height *1;
//                    
//                    imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//                    
//                }
//                imgView.image =[UIImage imageWithCGImage:imageRef];
//                NSLog(@"轮播图中异步返回图片宽高%f,%f",image.size.width,image.size.height);
//                if (_transValue) {
//                    _transValue(image.size.width,image.size.height);
//                }
//
//            }];
            
            //imgView.contentMode =UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHaddle:)]];
            [_scrollView addSubview:imgView];
        }
        _scrollView.contentOffset = CGPointMake(Width, 0);
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Height - 30, Width, 30)];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:240/255.0 green:53/255.0 blue:53/255.0 alpha:1];//RGB(240, 60, 70);
        
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = imgArr.count;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(pageControlChange) forControlEvents:UIControlEventValueChanged];
        [_pageControl updateCurrentPageDisplay];
        
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showNextImage) userInfo:nil repeats:YES];

    }
    return self;
}

- (void)showNextImage
{
    CGFloat pageWidth = _scrollView.contentOffset.x + _scrollView.width;
    
    if (_scrollView.contentOffset.x < (([_imageArray count]-1) * _scrollView.width) ) {
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake(pageWidth, 0);
        }];
    }else {
        _scrollView.contentOffset = CGPointMake(Width, 0);
    }
    
    _currentPageIndex = floor((_scrollView.contentOffset.x - Width / 2) / Width)+1;
    _pageControl.currentPage = _currentPageIndex - 1;
    if (_currentPageIndex == [_imageArray count] - 1) {
        _pageControl.currentPage = 0;
    }
    if (_currentPageIndex == 0) {
        _pageControl.currentPage = [_imageArray count] - 2;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([timer isValid]){
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4]];
    }
    _currentPageIndex = floor((scrollView.contentOffset.x - Width / 2) / Width)+1;
    _pageControl.currentPage = _currentPageIndex - 1;
    if (_currentPageIndex == [_imageArray count] - 1) {
        _pageControl.currentPage = 0;
    }
    if (_currentPageIndex == 0) {
        _pageControl.currentPage = [_imageArray count] - 3;
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPageIndex == 0) {
        
        [_scrollView setContentOffset:CGPointMake(([_imageArray count]-2)*Width, 0)];
    }
    if (_currentPageIndex == [_imageArray count] - 1) {
        
        _currentPageIndex = -1;
        [_scrollView setContentOffset:CGPointMake(Width, 0)];
        
    }
}
- (void)pageControlChange
{
    _currentPageIndex = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(Width * _pageControl.currentPage, 0)];
}
- (void)tapHaddle:(UITapGestureRecognizer *)tap
{
    
        if ([_delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
            
    if (tap.view.tag == _imageArray.count - 1) {
        [_delegate EScrollerViewDidClicked:0];
        return;
    }
    if (tap.view.tag == 0) {
        [_delegate EScrollerViewDidClicked:_imageArray.count - 2];
        return;
    }
    [_delegate EScrollerViewDidClicked:tap.view.tag - 1];
}
}

@end
