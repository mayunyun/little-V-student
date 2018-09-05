//
//  EScrollerView.h
//  Hnair4iPhone
//
//  Created by 02 on 14-6-18.
//  Copyright (c) 2014年 yingkong1987. All rights reserved.
//
@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

#import <UIKit/UIKit.h>
@interface EScrollerView : UIView
@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr;
@property (nonatomic,strong)void (^transValue)(CGFloat w, CGFloat h);
@end
