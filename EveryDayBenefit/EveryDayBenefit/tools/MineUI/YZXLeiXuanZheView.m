//
//  YZXLeiXuanZheView.m
//  PingChuan
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 平川嘉恒. All rights reserved.
//

#import "YZXLeiXuanZheView.h"


@implementation YZXLeiXuanZheView

- (id)initWithFrame:(CGRect)frame xingHao:(NSArray*)array
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i=0; i<array.count; i++) {
            SMYShangPinButton *xing = [SMYShangPinButton buttonWithType:UIButtonTypeRoundedRect];
            xing.frame = CGRectMake(40+i%4*(((SCREEN_SIZE.width-50)/4.0)), i/4*30, (SCREEN_SIZE.width-50)/4.0*0.5, 25*0.5);
            [xing setTitle:kString([array objectAtIndex:i]) forState:UIControlStateNormal];
            xing.layer.borderColor = [UIColor grayColor].CGColor;
            xing.layer.borderWidth = .5;
            xing.layer.cornerRadius = 2.0;
            xing.layer.masksToBounds = YES;
            [xing setTintColor:[UIColor grayColor]];
            xing.tag = i;
            xing.titleLabel.font = [UIFont systemFontOfSize:7];
//            xing.xingHaoPrice = kString([[array objectAtIndex:i]);
//            xing.xingHaoKuCun = kString([[array objectAtIndex:i]);
//            xing.xingHao = kString([[array objectAtIndex:i] objectForKey:@"spec"]);
            [xing addTarget:self action:@selector(selectXingHao:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:xing];
            [UIView animateWithDuration:.3 animations:^{
                xing.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }];
        }
        
        
        
    }
    return self;
}

- (void)selectXingHao:(SMYShangPinButton*)btn
{
    [self.delegate didSelector:btn.titleLabel.text titile:btn.titleLabel.text view:self button:btn];
}

@end
