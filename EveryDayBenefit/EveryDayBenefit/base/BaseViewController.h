//
//  BaseViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowAnimationView.h"

@interface BaseViewController : UIViewController
{
    ShowAnimationView* _grayView;
}
- (void)showAlert:(NSString *)message;

- (void)backBarButtonItemTarget:(id)target action:(SEL)action;
- (void)backBarTitleButtonItemTarget:(id)target action:(SEL)action text:(NSString*)str;
- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str;
- (void)rightBarImgButtonTarget:(id)target action:(SEL)action imgname:(NSString*)str;

//取消多余cell
- (void)setExtraCellLineHidden: (UITableView *)tableView;
//转换空串
-(NSString*)convertNull:(id)object;

- (void)showTabBar;
- (void)hideTabBar;

//NSString* string =@"2016-08-31“转化成数组中
- (NSArray*)separateDateStr:(NSString*)str;

- (void)isLogin;

@end

//空值判断
static inline BOOL IsEmptyValue(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0)
    ||  ([thing isKindOfClass:[NSNull class]]);
}
