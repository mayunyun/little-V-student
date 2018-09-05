//
//  AccountTableViewCell.m
//  TableListDemo
//
//  Created by albeeert on 10/8/16.
//  Copyright © 2016 albeeert. All rights reserved.
//

#import "AccountTableViewCell.h"

#define ScreenWidth self.view.frame.size.width
#define mScreenWidth [UIScreen mainScreen].bounds.size.width//设备宽
#define kDeviceFrame [UIScreen mainScreen].bounds//设备坐标
#define StatusBarStyle UIStatusBarStyleLightContent
#define mScreenHeight [UIScreen mainScreen].bounds.size.height//设备高

#define gap 10
#define inputW  (mScreenWidth - gap*4)/3 - 40// 输入框宽度
#define inputH 35  // 输入框高度

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 账号
        _account = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
        _account.font = [UIFont systemFontOfSize:12.0];
        _account.numberOfLines = 0;
        _account.adjustsFontSizeToFitWidth = YES;
        _account.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_account];
    }
    return self;
}

@end
