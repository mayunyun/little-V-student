//
//  XtomFunction.h
//  WhbHelloWorld
//
//  Created by 山东三米 on 13-4-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "AppDelegate.h"
#import "XtomManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "XtomConst.h"
#import "Navbar.h"

NS_ASSUME_NONNULL_BEGIN
@interface  XtomFunction:NSObject

//whbmemo:不在.h中声明，直接在.m中书写也可以用
//建议声明，声明后可以在别的模块时实现代码书写提示


////////////////    全局函数定义区域（全部是+类静态方法）    ///////////////////

//字符串相关函数===========================================================
+ (NSString *)handleMobileNumber:(NSString *)number;//隐藏手机号码的中间四位
+ (CGSize)getSizeWithStr:(NSString*)str width:(float)width font:(float)font;//获取text文本高度(厚字体)
+ (CGSize)getSizeWithStrNo:(NSString*)str width:(float)width font:(float)font;//获取text文本高度(正常字体)
+ (NSString*)getSecreatMobile:(NSString*)_mobile;//获取隐藏的手机号
+ (NSString*)getSecreatEmail:(NSString*)_email;//获取隐藏的邮箱号
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr;   //字符串判空
+ (BOOL)xfunc_isMobileNumber:(NSString *)mobileNum;//手机号合法判断
+ (BOOL)xfunc_isEmail:(NSString*)email;//邮箱合法
+ (NSString*)getString:(id)value;//获取字符串 为空返回@“”
+(Boolean)panDuanShiFouWeiKong:(NSString*)str;
//+(Boolean)     xfunc_check_mobile:(NSString *) parmStr;
//+(NSString  *) xfunc_get_time;
+ (NSString*)getDistance:(float)distance;//获取公里数
//获取固定宽度的字符串存放长度的个数
+ (int)getLineSize:(NSString *)content startIndex:(int)start width:(float)width font:(float)font;
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2;//经纬度之间的距离
//时间相关函数===========================================================
+ (NSDate *)xfunc_get_now;//获取当前时间，已经不用
+ (NSDate*)getDateNow;//获取当前时间
+ (NSString*)getStringNow;//获取当前时间
+(NSString *)getTimeFromDate:(NSString *)fromDate;//获取操作在多久之前(用于发表话题、帖子、评论时)
+(NSString *)getTimeFromDateChat:(NSString *)fromDate;//获取操作在多久之前(用于及时聊天时)
+ (CGFloat)getDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr;//获取时间差
+(int)getRandomNumber:(int)from to:(int)to;//获取一个随机数

//弹窗相关==============================================================
//显示黑色等待弹窗
+ (MBProgressHUD*)openHUD:(NSString*)message view:(UIView*)myview;
+ (void)closeHUD:(MBProgressHUD*)HUD;
//显示黑色定时弹窗
+ (void)openIntervalHUD:(NSString*)message view:(UIView*)myview;
//显示黑色定时弹窗(带对勾的表示发表成功之类的)
+ (void)openIntervalHUDOK:(NSString*)message view:(UIView*)myview;

//视图相关函数=============================================================
+ (UIView *)findView:(UIView *)aView withName:(NSString *)name;//寻找子view
+ (void)addShadowToView:(UIView*)view;//添加阴影
+ (void)setCellSelectedStyle:(UITableViewCell*)cell;//设置cell被选择

+ (BOOL)addBorderToView:(UIView*)view borderWidth:(CGFloat)width;//添加描边
+ (BOOL)addBorderToView:(UIView*)view;//添加边角
+ (BOOL)addbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color;//自定义边角
+ (BOOL) hideTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration;//隐藏tabBar
+ (BOOL) showTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration;//显示tabBar

+ (void)xfunc_show_msg:(NSString *)parmStr;//打开一个含提示信息的系统弹窗

+ (UIBarButtonItem*)getPlainButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action;//获取navigationItem按钮
+ (UIBarButtonItem*)getBackButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action;//获取navigationItem返回按钮
+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title target:(id)target type:(NSUInteger)type;//显示等待alert
//0,等待alert; 1,带取消按钮
+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title message:(NSString*)msg target:(id)target type:(NSUInteger)type;//

+ (void)xfunc_BeginAnimations:(NSTimeInterval)duration view:(UIView*)view withHandler:(void(^)(UIView * temView))block;//对view攺变添加动画
+(void)pushToView:(UIViewController*)myView nav:(UINavigationController*)nav;//大图查看动画
+ (UIView*)getTitlView:(NSString*)title target:(id)target action:(SEL)action;//获取导航栏的标题

//获取主变量相关函数=============================================================
//获取主appdelegate
+ (AppDelegate*)xfuncGetAppdelegate;
+ (XtomManager*)xfuncGetXtomManager;//获取主单例对象
+ (NSString*)getRootPath;//获得后台服务根目录
+ (NSString*)getChatPath;
+ (NSString*)getChatPort;

//图片处理相关================================================================
+ (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius
                       color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview;//绘制阴影
+ (void)dropShadow:(CGSize)offset radius:(CGFloat)radius
             color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview;//绘制四周阴影
//等比缩放
+ (UIImage*)scaleImage:(UIImage *)image toScale:(float)scale;
//自定长宽
+ (UIImage*)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
//剪切view
+ (UIImage*)captureView:(UIView *)aView;

+ (UIImage*)getImageWithSize:(CGSize)contentSize color:(UIColor*)color;//获取一个纯色图片

+ (UIImage*)getImage:(UIImage*)image;//拍照或者从相册获取图片结束后裁剪图片
+ (UIImage*)imageToSquare:(UIImage*)image;//添加上下黑边的方法
+ (UIImage*)getFangImage:(UIImage*)oldImage wantSize:(CGSize)wantSize;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;//对图片进行旋转
+ (UIImage*)getMapImage:(UIImage*)myimg;//图形上下文方法
+ (UIImage*)getMapImageByUrl:(NSString*)imgurl; //图形上下文方法
+ (UIImage *)invertImage:(UIImage *)originalImage myColor:(UIColor*)myColor;//更改图片的颜色
//声音播放相关================================================================
//提示声
+ (void)playPoint:(NSString*)sound;
//捕捉在线视频第一帧
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
//获取视频的大小
+ (NSInteger) getFileSize:(NSString*) path;
//获取视频的时间
+ (CGFloat) getVideoDuration:(NSURL*) URL;
//获得导航条文字
+ (UIView*)getNewView:(NSString*)title;
//寻找第一响应者
+ (id) traverseResponderChainForUIViewController:(UIView*)view;
//检测网络状态
+(BOOL)canConnectNet;
@end
NS_ASSUME_NONNULL_END
