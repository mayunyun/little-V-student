//
//  Command.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject
+ (BOOL)islogin;
+ (BOOL)isEmptyValueProAndCityAndArea;
//转换空串
+ (NSString*)convertNull:(id)object;
+ (NSString*)sendtimeChangeData:(NSString*)str;
+ (void)soundCreat;
+ (CGFloat)detailLabelHeight:(NSString*)text width:(CGFloat)width fontsize:(NSInteger)index;
+(NSString *)filterHTML:(NSString *)html;
+ (NSString *)replaceAllOthers:(NSString *)responseString;
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
@end

//空值判断
static inline BOOL IsEmptyValue1(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0)
    ||  ([thing isKindOfClass:[NSNull class]]);
}
