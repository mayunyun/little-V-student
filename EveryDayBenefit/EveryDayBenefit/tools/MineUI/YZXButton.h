//
//  YZXButton.h
//  BaoGongDuanAn
//
//  Created by yang on 15/5/5.
//  Copyright (c) 2015年 YZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMYShangPinButton.h"

@interface YZXButton : UIView
@property (strong,nonatomic) UIButton *button;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *classId;
@property (copy,nonatomic)   NSString *type;

- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig;
- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig juLi:(NSString*)ju;
- (id)initWithFrameBuQieJiao:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig;
@end
