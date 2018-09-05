//
//  MyAleartTbView.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/21.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
@class MyAleartTbView;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (MyAleartTbView *) sender index:(NSInteger)index;
@end

#import <UIKit/UIKit.h>

@interface MyAleartTbView : UIView

@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL istrue);

@end
