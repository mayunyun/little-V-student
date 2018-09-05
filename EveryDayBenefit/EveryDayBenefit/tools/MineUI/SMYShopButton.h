//
//  SMYShopButton.h
//  PingChuan
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMYShangPinButton.h"

@interface SMYShopButton : UIView
@property (strong,nonatomic) SMYShangPinButton *button;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *shopId;
- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(NSString*)url;
- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig juLi:(NSString*)ju;
@end
