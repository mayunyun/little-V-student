//
//  BaseViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//{
//    UIView *_navMaskView;
//    UIView *_baseSearchView;
//}

- (void)showAlert:(NSString *)message;

- (void)backBarButtonItemTarget:(id)target action:(SEL)action;
- (void)backBarTitleButtonItemTarget:(id)target action:(SEL)action text:(NSString*)str;
- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str;
- (void)rightBarImgButtonTarget:(id)target action:(SEL)action imgname:(NSString*)str;
//- (void)initBaseSearchView;
//取消多余cell
- (void)setExtraCellLineHidden: (UITableView *)tableView;
-(NSString*)convertNull:(id)object;

- (NSArray*)separateDateStr:(NSString*)str;
- (NSString*)sendtimeChangeData:(NSString*)str;

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
