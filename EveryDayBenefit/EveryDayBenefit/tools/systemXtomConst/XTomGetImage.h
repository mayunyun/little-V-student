//
//  XTomGetImage.h
//  YYZZB
//  
//  Created by lipeng on 13-5-14.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XtomImageTypeList = 0,
    XtomImageTypeDetail
}XtomImageType;

@protocol XTomGetImageDelegate;
@interface XTomGetImage : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property(nonatomic,retain)NSMutableData *receiveData;//服务器返回的数据
@property(nonatomic,retain)id target;
@property(nonatomic,assign)SEL selector;
@property(nonatomic,assign)int tag;
@property(nonatomic,assign)long allLength;
@property(nonatomic,retain)UIButton *imageButton;
@property(nonatomic,assign)XtomImageType imageType;//图片类型 1列表类型 2详情类型

- (void)addTarget:(id)target selector:(SEL)aselector requestWithURL:(NSString*)url document:(NSString*)document button:(UIButton*)imageBtn type:(XtomImageType)type;
- (void)closeConnect;//关闭连接

@end




