//
//  XtomManager.h
//  YYZZB
//
//  Created by 李朋 on 13-4-20.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MBProgressHUD.h"

@class NSMutableArray;
@class NSMutableDictionary;

typedef enum
{
    DD_PHONE_REGISTER = 0,//注册页面类型
    DD_PHONE_LOST,//输入手机号 找回密码类型
    DD_PHONE_AGAIN//修改手机号验证类型
}GetPhoneType;

typedef enum
{
    BB_ISFIND = 0,//首页小地图进来 查找地点页面
    BB_ISFROM,//发纸条从哪儿发的
    BB_ISTO,//发纸条发到哪
    BB_ISADD, //加入地点
    BB_ISPLACE, //地点专业过来的
    BB_ISMAOPAO //冒泡
}MapPlace;

typedef enum
{
    DD_NOMORE = 0,//已完成的工作
    DD_MORE //更多完成的工作
}EnterMoreWork;

@interface XtomManager : NSObject
@property(nonatomic,retain)NSDictionary* push_aps;//从推送打开软件，收到的消息
@property(nonatomic,assign)BOOL isNetConnecting;
@property(nonatomic,retain)NSMutableDictionary *userInfor;//用户信息
@property(nonatomic,retain)NSMutableDictionary* motherInfor;//保存用户信息
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *userToken;
@property(nonatomic,copy)NSString *userHearcdIgURL;//个人头像
@property(nonatomic,copy)NSString *userNickname;
@property(nonatomic,retain)NSMutableDictionary *myinitInfor;
@property(nonatomic,retain)NSMutableDictionary *fromDic;//注册信息的保存等

+(id)sharedManager;
- (void)cleanInfor;//初始化信息

- (void)zhiFuBao:(NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId;



+ (void)zhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId;
@end
