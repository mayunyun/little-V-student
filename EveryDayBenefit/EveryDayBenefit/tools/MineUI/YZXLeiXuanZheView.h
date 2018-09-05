//
//  YZXLeiXuanZheView.h
//  PingChuan
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//
#import "SMYShangPinButton.h"
@protocol YZXLeiXuanZheViewDelegate <NSObject>

- (void)didSelector:(NSString*)tag titile:(NSString*)title view:(UIView*)view button:(SMYShangPinButton*)btn;

@end
#import <UIKit/UIKit.h>

@interface YZXLeiXuanZheView : UIView
@property (nonatomic,assign)id<YZXLeiXuanZheViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame xingHao:(NSArray*)array;
@end
