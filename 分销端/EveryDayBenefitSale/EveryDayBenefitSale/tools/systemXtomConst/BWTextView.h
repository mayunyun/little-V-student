//
//  YYTextView.h
//  YYZZB
//
//  Created by 李朋 on 13-4-29.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWTextView : UITextView

@property(nonatomic,retain)UILabel *placeHolderLabel;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,retain)UIColor *placeholderColor;
@end
