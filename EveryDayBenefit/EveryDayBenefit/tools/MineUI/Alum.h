//
//  Alum.h
//  TestQQOuthour
//
//  Created by 杨雨 on 13-12-30.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alum : UIView
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) UILabel *backLabel;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *IDD;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *app;//用于判断服务器让不让打开 有米广告
- (id)initWithFrame:(CGRect)frame url:(NSString*)url name:(NSString*)name;
@end
