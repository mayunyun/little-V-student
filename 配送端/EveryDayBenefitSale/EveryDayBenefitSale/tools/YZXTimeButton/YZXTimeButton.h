//
//  YZXTimeButton.h
//  WangShangHui
//
//  Created by yang on 14/10/27.
//  Copyright (c) 2014年 MingXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXTimeButton : UIButton
{
    int _Kaishi;
}
@property (nonatomic,assign) int Kaishi;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,assign) int miao;
@property (nonatomic,retain) NSString *buttonTitle;
@property (nonatomic,retain) NSString *recoderTime;
- (void)setKaishi:(int)input;
- (id)initWithFrame:(CGRect)frame;
@end
