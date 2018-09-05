//
//  XtomCashManager.h
//  YYZZB
//
//  Created by lipeng on 13-5-17.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XtomCashManager : NSObject

@property(assign) dispatch_queue_t myIOQueue;
@property(assign) dispatch_queue_t myAvatarQueue;//存头像的线程
@property(assign) dispatch_queue_t mySQLQueue;//存取sql的线程

+ (id)sharedManager;

-(NSString*)getFilePath:(NSString*)fileName;//获取文件完整路径
//获取博文图片目录
- (NSString*)getBlogDocument;

-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName;//获取带文件夹的文件路径 例子：my/abc/img

//由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url;

- (BOOL)removeDocument:(NSString*)document;//删除文件夹

-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn document:(NSString*)document url:(NSString*)url;////把图片设为按钮的背景

-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView document:(NSString*)document url:(NSString*)url;////往imgView添加图片
//左滑删除视频
-(void)deleteCashVideo:(NSString*)url;
//缓存声音
-(BOOL)downloadAudioFromDocumentORURL:(NSString*)document url:(NSString*)url;
//缓存视频
-(BOOL)downloadVideoFromDocumentORURL:(NSString*)document url:(NSString*)url;

-(UIImage *)getImagefrompath:(NSString *)path;//从文件获取图像

-(dispatch_queue_t)runOnIOThread;//获取线程
-(dispatch_block_t) BlockWithAutoreleasePool:(dispatch_block_t)block;//自动释放
@end
